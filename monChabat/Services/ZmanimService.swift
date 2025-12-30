//
//  ZmanimService.swift
//  monChabat
//
//  Service pour récupérer les horaires de Shabbat via Hebcal API
//

import Foundation
import CoreLocation
import Combine

class ZmanimService: NSObject, ObservableObject {
    @Published var currentZmanim: ZmanimData?
    @Published var currentParasha: ParashaData?
    @Published var upcomingEvents: [JewishEvent] = [] // Yom Tov et Jeûnes
    @Published var isLoading = false
    @Published var error: String?
    @Published var locationName: String = "Paris, France"
    
    // MARK: - Mode manuel (date et localisation personnalisées)
    @Published var isManualMode: Bool = false
    @Published var manualDate: Date = Date()
    @Published var manualLocationName: String = ""
    @Published var manualLatitude: Double = 48.8566  // Paris par défaut
    @Published var manualLongitude: Double = 2.3522
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    // MARK: - Cache Keys
    private let cacheZmanimKey = "cached_zmanim"
    private let cacheParashaKey = "cached_parasha"
    private let cacheWeekKey = "cached_week"
    private let cacheLocationKey = "cached_location"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        // Charger les données en cache au démarrage
        loadCachedData()
    }
    
    // MARK: - Cache Management
    private func loadCachedData() {
        let defaults = UserDefaults.standard
        
        // Vérifier si le cache est pour le même Shabbat
        guard let cachedShabbatId = defaults.object(forKey: cacheWeekKey) as? String,
              cachedShabbatId == currentShabbatIdentifier() else {
            // Cache pour un autre Shabbat, ignorer
            return
        }
        
        // Vérifier que le Shabbat en cache n'est pas passé
        guard let zmanimData = defaults.data(forKey: cacheZmanimKey),
              let zmanim = try? JSONDecoder().decode(CachedZmanim.self, from: zmanimData),
              zmanim.havdalah > Date() else {
            // Cache expiré (Havdalah passée), ignorer tout le cache
            return
        }
        
        // Cache valide - charger les données
        currentZmanim = ZmanimData(
            candleLighting: zmanim.candleLighting,
            havdalah: zmanim.havdalah,
            location: zmanim.location
        )
        locationName = zmanim.location
        
        // Charger Parasha
        if let parashaData = defaults.data(forKey: cacheParashaKey),
           let parasha = try? JSONDecoder().decode(CachedParasha.self, from: parashaData) {
            currentParasha = ParashaData(name: parasha.name, hebrewName: parasha.hebrewName)
        }
    }
    
    private func saveToCache() {
        let defaults = UserDefaults.standard
        
        // Sauvegarder l'identifiant du Shabbat actuel
        defaults.set(currentShabbatIdentifier(), forKey: cacheWeekKey)
        
        // Sauvegarder Zmanim
        if let zmanim = currentZmanim {
            let cached = CachedZmanim(
                candleLighting: zmanim.candleLighting,
                havdalah: zmanim.havdalah,
                location: zmanim.location
            )
            if let data = try? JSONEncoder().encode(cached) {
                defaults.set(data, forKey: cacheZmanimKey)
            }
        }
        
        // Sauvegarder Parasha
        if let parasha = currentParasha {
            let cached = CachedParasha(name: parasha.name, hebrewName: parasha.hebrewName)
            if let data = try? JSONEncoder().encode(cached) {
                defaults.set(data, forKey: cacheParashaKey)
            }
        }
        
        // Sauvegarder la localisation
        if let location = currentLocation {
            defaults.set(location.coordinate.latitude, forKey: "\(cacheLocationKey)_lat")
            defaults.set(location.coordinate.longitude, forKey: "\(cacheLocationKey)_lon")
        }
    }
    
    private func shouldRefreshCache(newLocation: CLLocation?) -> Bool {
        let defaults = UserDefaults.standard
        
        // Toujours rafraîchir si pas de données en cache
        guard let zmanim = currentZmanim else { return true }
        
        // Rafraîchir si la Havdalah du Shabbat en cache est passée
        if zmanim.havdalah < Date() {
            return true
        }
        
        // Rafraîchir si nouvel identifiant de Shabbat
        guard let cachedShabbatId = defaults.object(forKey: cacheWeekKey) as? String,
              cachedShabbatId == currentShabbatIdentifier() else {
            return true
        }
        
        // Rafraîchir si localisation a changé significativement (> 10 km)
        if let newLoc = newLocation {
            let cachedLat = defaults.double(forKey: "\(cacheLocationKey)_lat")
            let cachedLon = defaults.double(forKey: "\(cacheLocationKey)_lon")
            
            if cachedLat != 0 && cachedLon != 0 {
                let cachedLocation = CLLocation(latitude: cachedLat, longitude: cachedLon)
                let distance = newLoc.distance(from: cachedLocation)
                return distance > 10000 // Plus de 10 km
            }
        }
        
        return false
    }
    
    /// Retourne un identifiant unique basé sur la date du prochain vendredi
    /// Après le samedi soir (après 22h), on passe automatiquement au vendredi suivant
    private func currentShabbatIdentifier() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        // Trouver le prochain vendredi
        var targetDate = now
        let weekday = calendar.component(.weekday, from: now)
        let hour = calendar.component(.hour, from: now)
        
        // weekday: 1 = dimanche, 6 = vendredi, 7 = samedi
        switch weekday {
        case 1: // Dimanche -> vendredi prochain (dans 5 jours)
            targetDate = calendar.date(byAdding: .day, value: 5, to: now)!
        case 2: // Lundi -> vendredi (dans 4 jours)
            targetDate = calendar.date(byAdding: .day, value: 4, to: now)!
        case 3: // Mardi -> vendredi (dans 3 jours)
            targetDate = calendar.date(byAdding: .day, value: 3, to: now)!
        case 4: // Mercredi -> vendredi (dans 2 jours)
            targetDate = calendar.date(byAdding: .day, value: 2, to: now)!
        case 5: // Jeudi -> vendredi (dans 1 jour)
            targetDate = calendar.date(byAdding: .day, value: 1, to: now)!
        case 6: // Vendredi -> c'est aujourd'hui
            targetDate = now
        case 7: // Samedi
            // Avant 22h -> le Shabbat est en cours (vendredi = hier)
            // Après 22h -> le Shabbat est fini, on passe au suivant
            if hour >= 22 {
                targetDate = calendar.date(byAdding: .day, value: 6, to: now)!
            } else {
                targetDate = calendar.date(byAdding: .day, value: -1, to: now)!
            }
        default:
            targetDate = now
        }
        
        // Formater comme identifiant unique (YYYY-MM-DD du vendredi)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: targetDate)
    }
    
    @MainActor
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // MARK: - Mode Manuel
    
    /// Active le mode manuel avec une date personnalisée
    @MainActor
    func setManualDate(_ date: Date) async {
        print("📅 setManualDate appelée avec date: \(date)")
        isManualMode = true
        manualDate = date
        print("📅 isManualMode: \(isManualMode), manualDate défini à: \(manualDate)")
        await fetchZmanimForManualMode()
    }
    
    /// Active le mode manuel avec une localisation personnalisée
    @MainActor
    func setManualLocation(name: String, latitude: Double, longitude: Double) async {
        isManualMode = true
        manualLocationName = name
        manualLatitude = latitude
        manualLongitude = longitude
        await fetchZmanimForManualMode()
    }
    
    /// Remet en mode automatique (localisation et date actuelles)
    @MainActor
    func resetToAutomatic() async {
        isManualMode = false
        manualLocationName = ""
        
        // Redemander la localisation actuelle
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if let location = locationManager.location {
                await fetchZmanim(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    forceRefresh: true
                )
            } else {
                locationManager.requestLocation()
            }
        } else {
            await fetchZmanim(forceRefresh: true)
        }
    }
    
    /// Fetch les horaires pour le mode manuel
    @MainActor
    private func fetchZmanimForManualMode() async {
        print("📅 fetchZmanimForManualMode - manualDate: \(manualDate), lat: \(manualLatitude), lon: \(manualLongitude)")
        await fetchZmanim(
            for: manualDate,
            latitude: manualLatitude,
            longitude: manualLongitude,
            forceRefresh: true
        )
    }

    /// Charge les données si nécessaire (cache expiré ou vide)
    @MainActor
    func loadDataIfNeeded() async {
        // En mode manuel, utiliser la date et localisation manuelles
        if isManualMode {
            await fetchZmanimForManualMode()
            return
        }
        
        // Si on a déjà des données valides en cache, on peut quand même vérifier les événements
        if let zmanim = currentZmanim, zmanim.havdalah > Date() {
            // Mais on doit quand même récupérer les événements si vides
            if upcomingEvents.isEmpty {
                let status = locationManager.authorizationStatus
                if status == .authorizedWhenInUse || status == .authorizedAlways,
                   let location = locationManager.location {
                    await fetchUpcomingEvents(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                } else {
                    await fetchUpcomingEvents(latitude: 48.8566, longitude: 2.3522)
                }
            }
            return
        }
        
        // Cache invalide ou expiré - forcer le rechargement
        // Utiliser la dernière position connue ou Paris par défaut
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Essayer d'obtenir la position actuelle
            if let location = locationManager.location {
                await fetchZmanim(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    forceRefresh: true
                )
            } else {
                // Demander une nouvelle position (le delegate appellera fetchZmanim)
                locationManager.requestLocation()
            }
        } else if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            // En attendant l'autorisation, charger avec Paris par défaut
            await fetchZmanim(forceRefresh: true)
        } else {
            // Pas d'autorisation, utiliser Paris par défaut
            await fetchZmanim(forceRefresh: true)
        }
    }
    
    // MARK: - Hebcal API
    @MainActor
    func fetchZmanim(for date: Date = Date(), latitude: Double = 48.8566, longitude: Double = 2.3522, forceRefresh: Bool = false) async {
        // Vérifier si on doit utiliser le cache (seulement en mode automatique)
        if !isManualMode {
            let testLocation = CLLocation(latitude: latitude, longitude: longitude)
            if !forceRefresh && !shouldRefreshCache(newLocation: testLocation) {
                return // Utiliser les données en cache
            }
        }
        
        isLoading = true
        error = nil
        
        // Calculer la date pour la requête API
        // En mode manuel, utiliser la date passée en paramètre
        // Sinon, calculer automatiquement
        let targetDate = isManualMode ? date : getTargetDateForAPI()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: targetDate)
        let month = calendar.component(.month, from: targetDate)
        let day = calendar.component(.day, from: targetDate)
        
        print("📅 fetchZmanim - isManualMode: \(isManualMode), targetDate: \(targetDate), year: \(year), month: \(month), day: \(day)")
        
        // Hebcal API endpoint avec la date cible
        // On utilise lg=en pour avoir des noms de parachiot propres (sans accents spéciaux)
        let urlString = "https://www.hebcal.com/shabbat?cfg=json&latitude=\(latitude)&longitude=\(longitude)&tzid=Europe/Paris&M=on&lg=en&gy=\(year)&gm=\(month)&gd=\(day)"
        
        print("🌐 API URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            error = "URL invalide"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(HebcalResponse.self, from: data)
            
            parseHebcalResponse(response)
            saveToCache() // Sauvegarder en cache après succès
            
            // Fetch upcoming events (holidays and fasts) separately
            await fetchUpcomingEvents(latitude: latitude, longitude: longitude)
        } catch {
            self.error = "Erreur de chargement: \(error.localizedDescription)"
            // Use fallback data
            useFallbackData(for: date)
        }
        
        isLoading = false
    }
    
    /// Retourne la date à utiliser pour l'appel API
    /// Après samedi 22h, on demande le Shabbat de la semaine suivante
    private func getTargetDateForAPI() -> Date {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let hour = calendar.component(.hour, from: now)
        
        // Si samedi après 22h ou dimanche, on ajoute des jours pour arriver au prochain vendredi
        if weekday == 7 && hour >= 22 {
            // Samedi soir après 22h -> ajouter 6 jours pour vendredi prochain
            return calendar.date(byAdding: .day, value: 6, to: now)!
        } else if weekday == 1 {
            // Dimanche -> ajouter 5 jours pour vendredi prochain
            return calendar.date(byAdding: .day, value: 5, to: now)!
        }
        
        // Sinon, utiliser la date actuelle (l'API retournera le Shabbat de cette semaine)
        return now
    }
    
    @MainActor
    private func parseHebcalResponse(_ response: HebcalResponse) {
        print("🔍 parseHebcalResponse - \(response.items.count) items reçus")
        for item in response.items {
            print("   📌 category: \(item.category), title: \(item.title)")
        }
        
        var candleLighting: Date?
        var havdalah: Date?
        var parashaName: String?
        var parashaHebrew: String?
        var yomTovName: String?
        var yomTovHebrew: String?
        
        let dateFormatter = ISO8601DateFormatter()
        
        for item in response.items {
            switch item.category {
            case "candles":
                candleLighting = dateFormatter.date(from: item.date)
            case "havdalah":
                havdalah = dateFormatter.date(from: item.date)
            case "parashat":
                // Utiliser title_orig (nom anglais standard) si disponible, sinon title
                let originalTitle = item.title_orig ?? item.title
                parashaName = originalTitle
                    .replacingOccurrences(of: "Parashat ", with: "")
                    .replacingOccurrences(of: "Parachah ", with: "")
                // Nettoyer le préfixe hébreu "פרשת " si présent
                parashaHebrew = item.hebrew?
                    .replacingOccurrences(of: "פרשת ", with: "")
                print("🕎 API Parasha - Title: '\(item.title)', Cleaned: '\(parashaName ?? "")', Hebrew: '\(parashaHebrew ?? "")'")
            case "holiday":
                // Prioriser les vrais Yom Tov (Pessah, Shavuot, Sukkot, etc.) sur les jeûnes
                // Les jeûnes ont souvent "Ta'anit", "Tzom", "Tisha" dans leur nom
                // Exclure aussi Chol HaMoed (CH''M) et Erev pour garder le vrai premier jour
                let isRealYomTov = !isFastDay(item.title) && !item.title.contains("Erev") && !item.title.contains("CH''M") && !item.title.contains("(CH")
                
                if isRealYomTov {
                    // C'est un vrai Yom Tov - TOUJOURS le prendre s'il n'y en a pas encore de vrai
                    // On vérifie si le yomTovName actuel est un "vrai" Yom Tov ou un secondaire
                    let currentIsSecondary = yomTovName != nil && (isFastDay(yomTovName!) || yomTovName!.contains("Erev"))
                    
                    if yomTovName == nil || currentIsSecondary {
                        yomTovName = translateHolidayName(item.title)
                        yomTovHebrew = item.hebrew
                        print("🎉 Yom Tov prioritaire détecté: \(yomTovName ?? "")")
                    }
                } else if yomTovName == nil {
                    // C'est un jeûne, Erev ou Chol HaMoed, ne le prendre que si rien d'autre
                    yomTovName = translateHolidayName(item.title)
                    yomTovHebrew = item.hebrew
                    print("📅 Holiday secondaire détecté: \(yomTovName ?? "")")
                }
            default:
                break
            }
        }
        
        if let candles = candleLighting, let havd = havdalah {
            // En mode manuel, garder le nom de ville personnalisé
            let displayLocation: String
            if isManualMode && !manualLocationName.isEmpty {
                displayLocation = manualLocationName + " (manuel)"
            } else {
                displayLocation = response.location?.title ?? locationName
            }
            
            currentZmanim = ZmanimData(
                candleLighting: candles,
                havdalah: havd,
                location: displayLocation
            )
            
            // Mettre à jour locationName aussi
            locationName = displayLocation
        }
        
        if let parasha = parashaName {
            currentParasha = ParashaData(
                name: parasha,
                hebrewName: parashaHebrew ?? parasha
            )
        } else if let yomTov = yomTovName {
            // Pas de parasha (Yom Tov), utiliser le nom du Yom Tov
            print("🎉 Pas de parasha, utilisation du Yom Tov: \(yomTov)")
            currentParasha = ParashaData(
                name: yomTov,
                hebrewName: yomTovHebrew ?? yomTov
            )
        }
    }
    
    // MARK: - Fetch Upcoming Events (Yom Tov & Fasts)
    @MainActor
    private func fetchUpcomingEvents(latitude: Double, longitude: Double) async {
        let calendar = Calendar.current
        
        // Utiliser la date de référence (manuelle ou actuelle)
        let referenceDate = isManualMode ? manualDate : Date()
        
        print("📆 fetchUpcomingEvents - referenceDate: \(referenceDate), isManualMode: \(isManualMode)")
        
        // Récupérer les événements des 30 prochains jours à partir de la date de référence
        let endDate = calendar.date(byAdding: .day, value: 30, to: referenceDate)!
        
        let startFormatter = DateFormatter()
        startFormatter.dateFormat = "yyyy-MM-dd"
        let startStr = startFormatter.string(from: referenceDate)
        let endStr = startFormatter.string(from: endDate)
        
        print("📆 API Calendar - start: \(startStr), end: \(endStr)")
        
        // Hebcal Calendar API pour les fêtes et jeûnes
        // maj=on : major holidays (Yom Tov)
        // mf=on : minor fasts
        // c=on : candle lighting times
        // F=on : fast start/end times
        let urlString = "https://www.hebcal.com/hebcal?v=1&cfg=json&latitude=\(latitude)&longitude=\(longitude)&tzid=Europe/Paris&start=\(startStr)&end=\(endStr)&maj=on&min=off&mod=off&nx=off&mf=on&ss=off&c=on&F=on&geo=pos&lg=s"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(HebcalCalendarResponse.self, from: data)
            
            print("📆 Calendar API - \(response.items.count) items reçus")
            for item in response.items {
                print("   🗓️ \(item.date) - \(item.category): \(item.title)")
            }
            
            parseCalendarEvents(response.items, referenceDate: referenceDate)
        } catch {
            print("❌ Error fetching upcoming events: \(error)")
        }
    }
    
    @MainActor
    private func parseCalendarEvents(_ items: [HebcalCalendarItem], referenceDate: Date) {
        var events: [JewishEvent] = []
        let dateFormatter = ISO8601DateFormatter()
        
        // Grouper les items par date pour associer les horaires aux événements
        var holidayCandles: [String: Date] = [:]
        var holidayHavdalah: [String: Date] = [:]
        var fastStarts: [String: Date] = [:]
        var fastEnds: [String: Date] = [:]
        var fastNames: [String: (title: String, hebrew: String?)] = [:]
        
        // Premier passage : collecter les horaires et les noms des jeûnes
        for item in items {
            let dateStr = item.date.components(separatedBy: "T").first ?? ""
            
            if item.category == "candles" {
                if let date = dateFormatter.date(from: item.date) {
                    holidayCandles[dateStr] = date
                }
            }
            
            if item.category == "havdalah" {
                if let date = dateFormatter.date(from: item.date) {
                    holidayHavdalah[dateStr] = date
                }
            }
            
            // Horaires de jeûne (zmanim)
            if item.category == "zmanim" {
                if let date = dateFormatter.date(from: item.date) {
                    if item.title.contains("Fast begins") || item.title.contains("Début du jeûne") {
                        fastStarts[dateStr] = date
                        print("⏰ Fast start collecté pour \(dateStr): \(date)")
                    } else if item.title.contains("Fast ends") || item.title.contains("Fin du jeûne") {
                        fastEnds[dateStr] = date
                        print("⏰ Fast end collecté pour \(dateStr): \(date)")
                    }
                }
            }
            
            // Collecter les noms des jeûnes (category = "holiday" avec subcat = "fast")
            if item.subcat == "fast" || isFastDay(item.title) {
                if item.category == "holiday" {
                    fastNames[dateStr] = (title: item.title, hebrew: item.hebrew)
                }
            }
        }
        
        // Deuxième passage : créer les événements
        var processedDates: Set<String> = []
        
        for item in items {
            guard let eventDate = dateFormatter.date(from: item.date) ?? parseDateOnly(item.date) else { continue }
            
            // Ne garder que les événements futurs (dans les 7 prochains jours depuis la date de référence)
            let refStart = Calendar.current.startOfDay(for: referenceDate)
            let eventStart = Calendar.current.startOfDay(for: eventDate)
            guard eventStart >= refStart else { continue }
            let daysUntil = Calendar.current.dateComponents([.day], from: refStart, to: eventStart).day ?? 0
            guard daysUntil <= 7 else { continue }
            
            let dateStr = item.date.components(separatedBy: "T").first ?? ""
            
            // Éviter de traiter plusieurs fois la même date pour les jeûnes
            if item.category == "zmanim" {
                continue // On ignore les zmanim, on les a déjà collectés
            }
            
            switch item.category {
            case "holiday":
                if item.yomtov == true {
                    // Fêtes majeures (Yom Tov)
                    let event = JewishEvent(
                        id: UUID(),
                        name: translateHolidayName(item.title),
                        hebrewName: item.hebrew ?? item.title,
                        type: .yomTov,
                        date: eventDate,
                        referenceDate: referenceDate,
                        candleLighting: holidayCandles[dateStr],
                        havdalah: holidayHavdalah[dateStr] ?? findNextHavdalah(for: dateStr, in: holidayHavdalah),
                        memo: item.memo
                    )
                    if !events.contains(where: { $0.name == event.name && Calendar.current.isDate($0.date, inSameDayAs: event.date) }) {
                        events.append(event)
                    }
                } else if (item.subcat == "fast" || isFastDay(item.title)) && !processedDates.contains(dateStr) {
                    // Jeûne - créer un seul événement avec le vrai nom
                    processedDates.insert(dateStr)
                    
                    print("🔍 Création jeûne pour dateStr: '\(dateStr)'")
                    print("   fastStarts keys: \(Array(fastStarts.keys))")
                    print("   fastEnds keys: \(Array(fastEnds.keys))")
                    print("   holidayCandles keys: \(Array(holidayCandles.keys))")
                    print("   fastStart trouvé: \(fastStarts[dateStr] != nil)")
                    print("   fastEnd trouvé: \(fastEnds[dateStr] != nil)")
                    
                    // Si pas de fin de jeûne, utiliser l'allumage des bougies du même jour
                    // (ex: Ta'anit Bechorot se termine à l'entrée de Pessah)
                    let fastEndTime = fastEnds[dateStr] ?? holidayCandles[dateStr]
                    
                    let event = JewishEvent(
                        id: UUID(),
                        name: translateFastName(item.title),
                        hebrewName: item.hebrew ?? item.title,
                        type: .fast,
                        date: eventDate,
                        referenceDate: referenceDate,
                        fastStart: fastStarts[dateStr],
                        fastEnd: fastEndTime,
                        memo: item.memo
                    )
                    events.append(event)
                    print("✅ Jeûne ajouté: \(event.name) - \(event.dateFormatted), horaires: \(event.timeFormatted)")
                }
                
            default:
                break
            }
        }
        
        // Trier par date
        upcomingEvents = events.sorted { $0.date < $1.date }
        print("📆 Total événements: \(upcomingEvents.count)")
        for event in upcomingEvents {
            print("   ➡️ \(event.name) - \(event.dateFormatted) (\(event.daysUntilText))")
        }
    }
    
    private func parseDateOnly(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
    
    private func findNextHavdalah(for dateStr: String, in havdalahDict: [String: Date]) -> Date? {
        // Chercher havdalah le jour suivant ou 2 jours après (pour fêtes de 2 jours)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateStr) else { return nil }
        
        for dayOffset in 1...3 {
            if let nextDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: date) {
                let nextStr = formatter.string(from: nextDate)
                if let havdalah = havdalahDict[nextStr] {
                    return havdalah
                }
            }
        }
        return nil
    }
    
    private func isFastDay(_ title: String) -> Bool {
        let fastKeywords = ["Tzom", "Ta'anit", "Tisha", "Yom Kippur", "Gedaliah", "Esther", "Tevet", "Tammuz", "Bechorot"]
        return fastKeywords.contains { title.contains($0) }
    }
    
    private func translateHolidayName(_ name: String) -> String {
        let translations: [String: String] = [
            "Pesach": "Pessah",
            "Pesach I": "Pessah (1er jour)",
            "Pesach II": "Pessah (2ème jour)",
            "Pesach VII": "Pessah (7ème jour)",
            "Pesach VIII": "Pessah (8ème jour)",
            "Shavuot": "Chavouot",
            "Shavuot I": "Chavouot (1er jour)",
            "Shavuot II": "Chavouot (2ème jour)",
            "Rosh Hashana": "Roch Hachana",
            "Rosh Hashana I": "Roch Hachana (1er jour)",
            "Rosh Hashana II": "Roch Hachana (2ème jour)",
            "Yom Kippur": "Yom Kippour",
            "Sukkot": "Souccot",
            "Sukkot I": "Souccot (1er jour)",
            "Sukkot II": "Souccot (2ème jour)",
            "Shmini Atzeret": "Chemini Atseret",
            "Simchat Torah": "Sim'hat Torah",
            "Chanukah": "Hanouka",
            "Purim": "Pourim",
            "Tu BiShvat": "Tou Bichvat",
            "Lag BaOmer": "Lag Baomer"
        ]
        return translations[name] ?? name
    }
    
    private func translateFastName(_ name: String) -> String {
        let translations: [String: String] = [
            "Tzom Gedaliah": "Jeûne de Guedalia",
            "Ta'anit Esther": "Jeûne d'Esther",
            "Ta'anit Bechorot": "Jeûne des Premiers-nés",
            "Tish'a B'Av": "Tisha Beav",
            "Tzom Tammuz": "17 Tamouz",
            "Asara B'Tevet": "10 Tevet"
        ]
        return translations[name] ?? name
    }
    
    @MainActor
    private func useFallbackData(for date: Date) {
        // Calcul approximatif pour Paris
        let calendar = Calendar.current
        
        // Trouver le prochain vendredi
        var nextFriday = date
        while calendar.component(.weekday, from: nextFriday) != 6 {
            nextFriday = calendar.date(byAdding: .day, value: 1, to: nextFriday)!
        }
        
        // Estimation des horaires (à 18h30 en hiver, 20h30 en été)
        let month = calendar.component(.month, from: nextFriday)
        let isWinter = month < 4 || month > 10
        
        var candleComponents = calendar.dateComponents([.year, .month, .day], from: nextFriday)
        candleComponents.hour = isWinter ? 17 : 20
        candleComponents.minute = isWinter ? 30 : 30
        
        var havdalahComponents = calendar.dateComponents([.year, .month, .day], from: nextFriday)
        havdalahComponents.day! += 1
        havdalahComponents.hour = isWinter ? 18 : 21
        havdalahComponents.minute = isWinter ? 45 : 45
        
        currentZmanim = ZmanimData(
            candleLighting: calendar.date(from: candleComponents)!,
            havdalah: calendar.date(from: havdalahComponents)!,
            location: locationName
        )
        
        currentParasha = ParashaData(
            name: "Paracha de la semaine",
            hebrewName: "פרשת השבוע"
        )
    }
    
    // MARK: - Time Calculations
    func timeUntilCandleLighting() -> TimeInterval? {
        guard let zmanim = currentZmanim else { return nil }
        return zmanim.candleLighting.timeIntervalSinceNow
    }
    
    func timeUntilHavdalah() -> TimeInterval? {
        guard let zmanim = currentZmanim else { return nil }
        return zmanim.havdalah.timeIntervalSinceNow
    }
    
    func formattedTimeRemaining(_ interval: TimeInterval) -> String {
        if interval <= 0 { return "Maintenant" }
        
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        if hours > 24 {
            let days = hours / 24
            return "\(days)j \(hours % 24)h"
        } else if hours > 0 {
            return "\(hours)h \(minutes)min"
        } else {
            return "\(minutes) min"
        }
    }
    
    func isShabbat() -> Bool {
        guard let zmanim = currentZmanim else { return false }
        let now = Date()
        return now >= zmanim.candleLighting && now <= zmanim.havdalah
    }
    
    @MainActor
    private func reverseGeocode(location: CLLocation) async {
        // Utilisation de CLGeocoder (compatible iOS 17+)
        let geocoder = CLGeocoder()
        do {
            if let placemark = try await geocoder.reverseGeocodeLocation(location).first {
                self.locationName = [placemark.locality, placemark.country]
                    .compactMap { $0 }
                    .joined(separator: ", ")
            }
        } catch {
            // Garder la valeur par défaut en cas d'erreur
            print("Reverse geocoding failed: \(error)")
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension ZmanimService: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        Task { @MainActor in
            self.currentLocation = location
            
            // Vérifier si on doit forcer le refresh (Havdalah passée)
            let shouldForce = self.currentZmanim == nil || self.currentZmanim!.havdalah < Date()
            
            await self.fetchZmanim(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                forceRefresh: shouldForce
            )
            
            // Reverse geocoding pour le nom (utilisation de CLGeocoder pour compatibilité)
            await self.reverseGeocode(location: location)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.error = "Erreur de localisation: \(error.localizedDescription)"
            await self.fetchZmanim() // Fallback to Paris
        }
    }
}

// MARK: - API Response Models
struct HebcalResponse: Codable {
    let title: String
    let items: [HebcalItem]
    let location: HebcalLocation?
}

struct HebcalItem: Codable {
    let title: String
    let date: String
    let category: String
    let hebrew: String?
    let memo: String?
    let title_orig: String?  // Nom original sans accents (pour parashat)
}

struct HebcalLocation: Codable {
    let title: String?
    let city: String?
    let country: String?
}

// MARK: - App Data Models
struct ZmanimData {
    let candleLighting: Date
    let havdalah: Date
    let location: String
    
    var candleLightingFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: candleLighting)
    }
    
    var havdalahFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: havdalah)
    }
    
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEEE d MMMM"
        return formatter.string(from: candleLighting).capitalized
    }
}

struct ParashaData {
    let name: String
    let hebrewName: String
    
    var summary: ParashaSummary? {
        let result = ParashotDatabase.getSummary(for: name) ?? ParashotDatabase.getParashaByHebrew(hebrewName)
        print("🔍 ParashaData.summary - name: '\(name)', hebrewName: '\(hebrewName)', found: \(result != nil)")
        return result
    }
}

// MARK: - Cache Models
struct CachedZmanim: Codable {
    let candleLighting: Date
    let havdalah: Date
    let location: String
}

struct CachedParasha: Codable {
    let name: String
    let hebrewName: String
}

// MARK: - Calendar API Response Models
struct HebcalCalendarResponse: Codable {
    let items: [HebcalCalendarItem]
}

struct HebcalCalendarItem: Codable {
    let title: String
    let date: String
    let category: String
    let subcat: String?
    let hebrew: String?
    let memo: String?
    let yomtov: Bool?
}

// MARK: - Jewish Event Model
struct JewishEvent: Identifiable {
    let id: UUID
    let name: String
    let hebrewName: String
    let type: EventType
    let date: Date
    let referenceDate: Date // Date de référence pour le calcul de "dans X jours"
    
    // Pour Yom Tov
    var candleLighting: Date?
    var havdalah: Date?
    
    // Pour jeûnes
    var fastStart: Date?
    var fastEnd: Date?
    
    var memo: String?
    
    enum EventType {
        case yomTov
        case fast
        
        var icon: String {
            switch self {
            case .yomTov: return "sparkles"
            case .fast: return "moon.zzz"
            }
        }
        
        var color: Color {
            switch self {
            case .yomTov: return .shabGold
            case .fast: return .shabDeepBlue
            }
        }
    }
    
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEEE d MMMM"
        return formatter.string(from: date).capitalized
    }
    
    var daysUntil: Int {
        // Utiliser le début de la journée pour les deux dates pour un calcul correct
        let calendar = Calendar.current
        let refStart = calendar.startOfDay(for: referenceDate)
        let eventStart = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: refStart, to: eventStart).day ?? 0
    }
    
    var daysUntilText: String {
        switch daysUntil {
        case 0: return "Aujourd'hui"
        case 1: return "Demain"
        default: return "Dans \(daysUntil) jours"
        }
    }
    
    var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        switch type {
        case .yomTov:
            if let candles = candleLighting {
                return "Allumage: \(formatter.string(from: candles))"
            }
            return ""
        case .fast:
            if let start = fastStart, let end = fastEnd {
                return "Début: \(formatter.string(from: start)) - Fin: \(formatter.string(from: end))"
            } else if let start = fastStart {
                return "Début: \(formatter.string(from: start))"
            } else if let end = fastEnd {
                return "Fin: \(formatter.string(from: end))"
            }
            return ""
        }
    }
}

import SwiftUI
