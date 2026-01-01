//
//  SettingsView.swift
//  monChabat
//
//  Vue des paramètres de l'application
//

import SwiftUI
import StoreKit
import Combine

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var systemColorScheme
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var zmanimService: ZmanimService
    @EnvironmentObject var notificationManager: NotificationManager
    
    @State private var showingLocationPicker = false
    @State private var showingAbout = false
    @State private var showingPrivacy = false
    @State private var showingDatePicker = false
    @State private var selectedDate: Date = Date()
    @State private var showingCitySearch = false
    
    var body: some View {
        NavigationStack {
            List {
                // Location Section
                Section {
                    // Localisation
                    Button {
                        showingCitySearch = true
                    } label: {
                        HStack {
                            Label("Ma localisation", systemImage: "location.fill")
                            Spacer()
                            Text(zmanimService.locationName)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .foregroundStyle(.primary)
                    
                    // Date
                    Button {
                        selectedDate = zmanimService.isManualMode ? zmanimService.manualDate : Date()
                        showingDatePicker = true
                    } label: {
                        HStack {
                            Label("Date", systemImage: "calendar")
                            Spacer()
                            if zmanimService.isManualMode {
                                Text(formattedDate(zmanimService.manualDate))
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Automatique")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                    
                    // Bouton Reset si mode manuel actif
                    if zmanimService.isManualMode {
                        Button {
                            Task {
                                await zmanimService.resetToAutomatic()
                            }
                        } label: {
                            HStack {
                                Label("Remettre en automatique", systemImage: "arrow.counterclockwise")
                                Spacer()
                                Image(systemName: "checkmark.circle")
                                    .foregroundStyle(Color.shabGold)
                            }
                        }
                        .foregroundStyle(Color.shabGold)
                    }
                } header: {
                    Text("Horaires")
                } footer: {
                    if zmanimService.isManualMode {
                        Text("Mode manuel activé - Les horaires affichés correspondent à la date/localisation personnalisée")
                            .foregroundStyle(Color.shabGold)
                    } else {
                        Text("Les horaires de Chabat sont calculés automatiquement selon votre position")
                    }
                }
                
                // Notifications Section
                Section("Notifications") {
                    Toggle(isOn: $notificationManager.reminder1HourEnabled) {
                        Label("Rappel 1 heure avant", systemImage: "bell")
                    }
                    
                    Toggle(isOn: $notificationManager.reminder15MinEnabled) {
                        Label("Rappel 15 minutes avant", systemImage: "bell.badge")
                    }
                    
                    Toggle(isOn: $notificationManager.candleLightingReminderEnabled) {
                        Label("Allumage des bougies", systemImage: "flame")
                    }
                    
                    Toggle(isOn: $notificationManager.hallaTimerEnabled) {
                        Label("Timer Halla", systemImage: "timer")
                    }
                }
                .tint(Color.shabGold)
                
                // Appearance Section
                Section("Apparence") {
                    Picker(selection: $appState.appearanceMode) {
                        ForEach(AppState.AppearanceMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    } label: {
                        Label("Thème", systemImage: "circle.lefthalf.filled")
                    }
                }
                
                // Recettes Section
                Section {
                    Stepper(value: $appState.defaultServings, in: 1...20) {
                        HStack {
                            Label("Personnes par défaut", systemImage: "person.2")
                            Spacer()
                            Text("\(appState.defaultServings)")
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Recettes")
                } footer: {
                    Text("Les quantités des recettes seront adaptées à ce nombre de personnes")
                }
                
                // About Section
                Section("À propos") {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("À propos de monChabat", systemImage: "info.circle")
                    }
                    
                    NavigationLink {
                        PrivacyView()
                    } label: {
                        Label("Politique de confidentialité", systemImage: "hand.raised")
                    }
                    
                    Button {
                        let email = "contact@yohannn.com"
                        let subject = "monChabat - Contact"
                        let body = "Bonjour,\n\n"
                        
                        if let url = URL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack {
                            Label("Nous contacter", systemImage: "envelope")
                            Spacer()
                            Text("Suggestions, bugs...")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .foregroundStyle(.primary)
                }
                
                // Soutenir le projet
                Section {
                    NavigationLink {
                        SupportProjectView()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "heart.fill")
                                .font(.title3)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple, .pink],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Soutenir le Projet")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.primary)
                                Text("Un petit geste, un grand merci !")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("Hakarat HaTov")
                }
                
                // Mes autres apps
                Section {
                    Button {
                        AppStoreHelper.shared.presentAppStore(appId: "6756859431")
                    } label: {
                        HStack(spacing: 14) {
                            Image("monMikve")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("monMikve")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.primary)
                                Text("Taharat Hamishpa'ha, calendrier, compteur et rappels")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        AppStoreHelper.shared.presentAppStore(appId: "6754168509")
                    } label: {
                        HStack(spacing: 14) {
                            Image("monPerekChira")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("monPerekChira")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.primary)
                                Text("Le chant de la création (FR, HE, Phonétique)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .buttonStyle(.plain)
                } header: {
                    Text("Mes autres apps")
                }
                
                // Version
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Réglages")
                        .font(.headline)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePickerSheet(
                    selectedDate: $selectedDate,
                    onConfirm: {
                        Task {
                            await zmanimService.setManualDate(selectedDate)
                        }
                    }
                )
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingCitySearch) {
                CitySearchSheet(zmanimService: zmanimService)
                    .presentationDetents([.large])
            }
            .preferredColorScheme(appState.appearanceMode == .system ? systemColorScheme : appState.appearanceMode.colorScheme)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
}

// MARK: - Date Picker Sheet
struct DatePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date
    var onConfirm: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Choisir une date")
                    .font(.headline)
                    .padding(.top)
                
                DatePicker(
                    "Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(Color.shabGold)
                .padding()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirmer") {
                        onConfirm()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.shabGold)
                }
            }
        }
    }
}

// MARK: - City Search Sheet
struct CitySearchSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var zmanimService: ZmanimService
    @State private var searchText = ""
    @State private var searchResults: [CityResult] = []
    @State private var isSearching = false
    
    // Villes populaires prédéfinies
    let popularCities: [CityResult] = [
        CityResult(name: "Paris", country: "France", latitude: 48.8566, longitude: 2.3522),
        CityResult(name: "Marseille", country: "France", latitude: 43.2965, longitude: 5.3698),
        CityResult(name: "Lyon", country: "France", latitude: 45.7640, longitude: 4.8357),
        CityResult(name: "Strasbourg", country: "France", latitude: 48.5734, longitude: 7.7521),
        CityResult(name: "Nice", country: "France", latitude: 43.7102, longitude: 7.2620),
        CityResult(name: "Jérusalem", country: "Israël", latitude: 31.7683, longitude: 35.2137),
        CityResult(name: "Tel Aviv", country: "Israël", latitude: 32.0853, longitude: 34.7818),
        CityResult(name: "New York", country: "USA", latitude: 40.7128, longitude: -74.0060),
        CityResult(name: "Los Angeles", country: "USA", latitude: 34.0522, longitude: -118.2437),
        CityResult(name: "Londres", country: "UK", latitude: 51.5074, longitude: -0.1278),
        CityResult(name: "Montréal", country: "Canada", latitude: 45.5017, longitude: -73.5673)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                // Option Ma position actuelle
                Section {
                    Button {
                        Task {
                            await zmanimService.resetToAutomatic()
                            dismiss()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundStyle(Color.shabGold)
                            Text("Ma position actuelle")
                            Spacer()
                            if !zmanimService.isManualMode {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.shabGold)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
                
                // Villes populaires ou résultats de recherche
                Section(searchText.isEmpty ? "Villes populaires" : "Résultats") {
                    if isSearching {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        ForEach(searchText.isEmpty ? popularCities : searchResults) { city in
                            Button {
                                Task {
                                    await zmanimService.setManualLocation(
                                        name: "\(city.name), \(city.country)",
                                        latitude: city.latitude,
                                        longitude: city.longitude
                                    )
                                    dismiss()
                                }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(city.name)
                                        Text(city.country)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                }
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Rechercher une ville...")
            .onChange(of: searchText) { _, newValue in
                if !newValue.isEmpty {
                    searchCity(newValue)
                } else {
                    searchResults = []
                }
            }
            .navigationTitle("Localisation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func searchCity(_ query: String) {
        isSearching = true
        
        // Recherche simple dans les villes populaires + quelques ajouts
        let allCities = popularCities + [
            CityResult(name: "Toulouse", country: "France", latitude: 43.6047, longitude: 1.4442),
            CityResult(name: "Bordeaux", country: "France", latitude: 44.8378, longitude: -0.5792),
            CityResult(name: "Nantes", country: "France", latitude: 47.2184, longitude: -1.5536),
            CityResult(name: "Lille", country: "France", latitude: 50.6292, longitude: 3.0573),
            CityResult(name: "Netanya", country: "Israël", latitude: 32.3215, longitude: 34.8532),
            CityResult(name: "Haifa", country: "Israël", latitude: 32.7940, longitude: 34.9896),
            CityResult(name: "Ashdod", country: "Israël", latitude: 31.8044, longitude: 34.6553),
            CityResult(name: "Beer Sheva", country: "Israël", latitude: 31.2530, longitude: 34.7915),
            CityResult(name: "Raanana", country: "Israël", latitude: 32.1847, longitude: 34.8714),
            CityResult(name: "Bruxelles", country: "Belgique", latitude: 50.8503, longitude: 4.3517),
            CityResult(name: "Anvers", country: "Belgique", latitude: 51.2194, longitude: 4.4025),
            CityResult(name: "Genève", country: "Suisse", latitude: 46.2044, longitude: 6.1432),
            CityResult(name: "Miami", country: "USA", latitude: 25.7617, longitude: -80.1918),
            CityResult(name: "Chicago", country: "USA", latitude: 41.8781, longitude: -87.6298)
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            searchResults = allCities.filter { city in
                city.name.localizedCaseInsensitiveContains(query) ||
                city.country.localizedCaseInsensitiveContains(query)
            }
            isSearching = false
        }
    }
}

// MARK: - City Result Model
struct CityResult: Identifiable {
    let id = UUID()
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
}

// MARK: - Data Management View
struct DataManagementView: View {
    var body: some View {
        List {
            Section {
                Button {
                    // Export data
                } label: {
                    Label("Exporter mes données", systemImage: "square.and.arrow.up")
                }
                
                Button {
                    // Import data
                } label: {
                    Label("Importer des données", systemImage: "square.and.arrow.down")
                }
            }
            
            Section {
                Button(role: .destructive) {
                    // Clear all data
                } label: {
                    Label("Supprimer toutes les données", systemImage: "trash")
                }
            } footer: {
                Text("Cette action est irréversible")
            }
        }
        .navigationTitle("Gestion des données")
    }
}

// MARK: - About View
struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Logo
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.shabGold.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.shabGold)
                    }
                    
                    Text("monChabat")
                        .font(.title.bold())
                    
                    Text("L'assistant pour un Chabat serein")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 30)
                
                // Features
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(
                        icon: "house.fill",
                        title: "Logistique simplifiée",
                        description: "Check-list intelligente et mode panique pour les retardataires"
                    )
                    
                    FeatureRow(
                        icon: "person.2.fill",
                        title: "Gestion des invités",
                        description: "Plan de table et gestion des allergies alimentaires"
                    )
                    
                    FeatureRow(
                        icon: "clock.fill",
                        title: "Horaires de Chabat",
                        description: "Entrée, sortie et zmanim selon votre localisation"
                    )
                    
                    FeatureRow(
                        icon: "book.fill",
                        title: "Recettes traditionnelles",
                        description: "Base de recettes avec convertisseur de quantités"
                    )
                }
                .padding()
                .liquidGlassCard()
                .padding(.horizontal)
                
                // Credits
                VStack(spacing: 8) {
                    Text("Développé avec ❤️ par monKodesh")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("Horaires fournis par Hebcal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                
                Spacer(minLength: 50)
            }
        }
        .navigationTitle("À propos")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.shabGold)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Privacy View
struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Politique de Confidentialité")
                    .font(.title2.bold())
                
                Group {
                    Text("Données collectées")
                        .font(.headline)
                    
                    Text("""
                    monChabat respecte votre vie privée. L'application stocke vos données localement sur votre appareil uniquement.
                    
                    • Vos listes et check-lists
                    • Vos recettes et menus
                    • Vos informations d'invités
                    • Vos préférences de notification
                    """)
                    .foregroundStyle(.secondary)
                }
                
                Group {
                    Text("Localisation")
                        .font(.headline)
                    
                    Text("""
                    Votre position est utilisée uniquement pour calculer les horaires de Chabat précis. Cette information n'est pas stockée ni partagée.
                    """)
                    .foregroundStyle(.secondary)
                }
                
                Group {
                    Text("Services tiers")
                        .font(.headline)
                    
                    Text("""
                    L'application utilise l'API Hebcal pour obtenir les horaires de Chabat et les informations sur la Paracha. Aucune donnée personnelle n'est transmise à ce service.
                    """)
                    .foregroundStyle(.secondary)
                }
                
                Group {
                    Text("Contact")
                        .font(.headline)
                    
                    Text("Pour toute question concernant la confidentialité, contactez-nous.")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Confidentialité")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Content View (sans NavigationStack pour MainTabView)
struct SettingsContentView: View {
    var body: some View {
        SettingsView()
            .navigationBarHidden(true)
    }
}

// MARK: - App Store Helper
class AppStoreHelper: NSObject, SKStoreProductViewControllerDelegate {
    static let shared = AppStoreHelper()
    
    private override init() {
        super.init()
    }
    
    func presentAppStore(appId: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            return
        }
        
        // Trouver le view controller le plus en avant
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        
        let storeVC = SKStoreProductViewController()
        storeVC.delegate = self
        
        let parameters: [String: Any] = [
            SKStoreProductParameterITunesItemIdentifier: NSNumber(value: Int(appId) ?? 0)
        ]
        
        // Présenter immédiatement (l'App Store affiche son propre loader)
        topVC.present(storeVC, animated: true)
        
        storeVC.loadProduct(withParameters: parameters) { success, error in
            if !success {
                print("Failed to load product: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    storeVC.dismiss(animated: true)
                }
            }
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true)
    }
}

// MARK: - Support Project View

struct SupportProjectView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var storeManager = DonationStoreManager()
    @State private var showThankYou = false
    @State private var selectedDonation: DonationType?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // En-tête avec icône
                headerSection
                
                // Message personnel
                messageSection
                
                // Boutons de don
                donationButtons
                
                // Info Apple
                appleInfoSection
                
                // Remerciement final
                closingSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(colorScheme == .light ? Color(.systemGroupedBackground) : Color(.systemBackground))
        .navigationTitle("Soutenir le Projet")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if showThankYou {
                ThankYouOverlay {
                    withAnimation(.spring(response: 0.3)) {
                        showThankYou = false
                    }
                }
            }
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.shabGold, Color.shabCandleOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.shabGold.opacity(0.3), radius: 15)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 35))
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 6) {
                Text("Hakarat Ha-Tov")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                
                Text("הַכָּרַת הַטּוֹב")
                    .font(.title3)
                    .foregroundStyle(Color.shabGold)
                
                Text("Pourquoi ce prix unique ?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    
    // MARK: - Message Section
    private var messageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cher utilisateur,")
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text("Nous avons fait le choix conscient de proposer cette application gratuitement, afin que l'aspect financier ne soit jamais un obstacle à la préparation d'un Chabat serein.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
            
            Text("Cependant, développer, maintenir et améliorer une application de qualité demande du temps, de l'énergie et des ressources techniques continues.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .light ? Color.white : Color(white: 0.12))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        }
    }
    
    // MARK: - Donation Buttons
    private var donationButtons: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "hands.sparkles.fill")
                    .foregroundStyle(Color.shabGold)
                Text("Devenir Partenaire")
                    .font(.headline)
            }
            
            Text("Si vous appréciez cet outil et qu'il vous apporte de la sérénité au quotidien, vous avez la possibilité de faire un geste supplémentaire.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                DonationButton(
                    emoji: "☕",
                    title: "Offrir un café",
                    subtitle: "Petit geste, grand merci !",
                    price: "3,00 €",
                    color: .brown,
                    isLoading: storeManager.purchaseInProgress && selectedDonation == .coffee
                ) {
                    selectedDonation = .coffee
                    purchaseDonation(.coffee)
                }
                
                DonationButton(
                    emoji: "🥗",
                    title: "Offrir un repas",
                    subtitle: "Un soutien précieux",
                    price: "10,00 €",
                    color: .green,
                    isLoading: storeManager.purchaseInProgress && selectedDonation == .meal
                ) {
                    selectedDonation = .meal
                    purchaseDonation(.meal)
                }
                
                DonationButton(
                    emoji: "💎",
                    title: "Pilier de la Mitsva",
                    subtitle: "Chiffre \"Haï\" (חי) - La Vie",
                    price: "18,00 €",
                    color: Color.shabGold,
                    isPremium: true,
                    isLoading: storeManager.purchaseInProgress && selectedDonation == .chai
                ) {
                    selectedDonation = .chai
                    purchaseDonation(.chai)
                }
            }
            
            // Ce que le don permet
            VStack(alignment: .leading, spacing: 10) {
                Text("Votre soutien nous aide à :")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                
                SupportBenefitRow(icon: "arrow.triangle.2.circlepath", text: "Maintenir l'app à jour avec iOS")
                SupportBenefitRow(icon: "sparkles", text: "Ajouter de nouvelles fonctionnalités")
                SupportBenefitRow(icon: "heart.fill", text: "Améliorer l'expérience de tous")
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.shabGold.opacity(0.08))
            }
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .light ? Color.white : Color(white: 0.12))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        }
    }
    
    // MARK: - Apple Info
    private var appleInfoSection: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "apple.logo")
                .foregroundStyle(.secondary)
            Text("Les paiements sont sécurisés par Apple. Ce don est un achat unique et non un abonnement.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        }
    }
    
    // MARK: - Closing
    private var closingSection: some View {
        VStack(spacing: 12) {
            Text("Merci pour votre confiance et votre soutien.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Text("Qu'Hachem bénisse votre foyer avec joie, santé et un Chabat serein ✨")
                .font(.subheadline.italic())
                .foregroundStyle(Color.shabGold)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 8)
    }
    
    private func purchaseDonation(_ type: DonationType) {
        Task {
            let success = await storeManager.purchase(type)
            if success {
                HapticManager.notification(.success)
                withAnimation(.spring(response: 0.5)) {
                    showThankYou = true
                }
            }
            selectedDonation = nil
        }
    }
}

// MARK: - Donation Type

enum DonationType: String {
    case coffee = "com.monchabat.donation.coffee"
    case meal = "com.monchabat.donation.meal"
    case chai = "com.monchabat.donation.chai"
}

// MARK: - Donation Button

struct DonationButton: View {
    let emoji: String
    let title: String
    let subtitle: String
    let price: String
    let color: Color
    var isPremium: Bool = false
    var isLoading: Bool = false
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: {
            HapticManager.impact(.medium)
            action()
        }) {
            HStack(spacing: 14) {
                // Emoji
                Text(emoji)
                    .font(.system(size: 28))
                    .frame(width: 44, height: 44)
                    .background {
                        Circle()
                            .fill(color.opacity(0.15))
                    }
                
                // Texte
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Prix ou loading
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Text(price)
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background {
                            Capsule()
                                .fill(
                                    isPremium
                                    ? LinearGradient(colors: [Color.shabGold, Color.shabCandleOrange], startPoint: .leading, endPoint: .trailing)
                                    : LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                                )
                        }
                }
            }
            .padding(14)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(colorScheme == .light ? Color.white : Color(white: 0.15))
                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
            }
            .overlay {
                if isPremium {
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(
                            LinearGradient(colors: [Color.shabGold.opacity(0.5), Color.shabCandleOrange.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 2
                        )
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }
}

// MARK: - Support Benefit Row

struct SupportBenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Color.shabGold)
                .frame(width: 20)
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Thank You Overlay

struct ThankYouOverlay: View {
    let onDismiss: () -> Void
    @State private var showConfetti = true
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }
            
            VStack(spacing: 24) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(
                        LinearGradient(colors: [Color.shabGold, Color.shabCandleOrange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .modifier(PulseModifier())
                
                VStack(spacing: 8) {
                    Text("Toda Raba ! 💛")
                        .font(.title.bold())
                    
                    Text("תודה רבה")
                        .font(.title2)
                        .foregroundStyle(Color.shabGold)
                    
                    Text("Votre générosité est une bénédiction.\nQu'Hachem vous le rende au centuple !")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Button {
                    onDismiss()
                } label: {
                    Text("Fermer")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background {
                            Capsule()
                                .fill(
                                    LinearGradient(colors: [Color.shabGold, Color.shabCandleOrange], startPoint: .leading, endPoint: .trailing)
                                )
                        }
                }
            }
            .padding(32)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
            }
            .padding(40)
            
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
    }
}

// MARK: - Pulse Modifier

struct PulseModifier: ViewModifier {
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.1 : 1.0)
            .animation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

// MARK: - Confetti View

struct ConfettiView: View {
    @State private var confetti: [ConfettiPiece] = []
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(confetti) { piece in
                    Text(piece.emoji)
                        .font(.system(size: piece.size))
                        .position(piece.position)
                        .opacity(piece.opacity)
                }
            }
            .onAppear {
                createConfetti(in: geo.size)
            }
        }
        .ignoresSafeArea()
    }
    
    private func createConfetti(in size: CGSize) {
        let emojis = ["🎉", "✨", "💛", "⭐️", "🌟", "💫", "🕯️"]
        
        for i in 0..<30 {
            let piece = ConfettiPiece(
                id: i,
                emoji: emojis.randomElement() ?? "✨",
                position: CGPoint(x: CGFloat.random(in: 0...size.width), y: -50),
                size: CGFloat.random(in: 20...35),
                opacity: 1.0
            )
            confetti.append(piece)
            
            // Animation de chute
            withAnimation(.easeIn(duration: Double.random(in: 2...4)).delay(Double.random(in: 0...1))) {
                if let index = confetti.firstIndex(where: { $0.id == piece.id }) {
                    confetti[index].position.y = size.height + 50
                    confetti[index].opacity = 0
                }
            }
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id: Int
    let emoji: String
    var position: CGPoint
    let size: CGFloat
    var opacity: Double
}

// MARK: - Donation Store Manager

@MainActor
class DonationStoreManager: ObservableObject {
    @Published var purchaseInProgress = false
    
    func purchase(_ donationType: DonationType) async -> Bool {
        purchaseInProgress = true
        defer { purchaseInProgress = false }
        
        do {
            // Récupérer le produit
            let products = try await Product.products(for: [donationType.rawValue])
            guard let product = products.first else {
                print("❌ Produit non trouvé: \(donationType.rawValue)")
                return false
            }
            
            // Effectuer l'achat
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                // Vérifier la transaction
                switch verification {
                case .verified(let transaction):
                    // Transaction vérifiée, terminer la transaction
                    await transaction.finish()
                    print("✅ Don effectué avec succès: \(donationType.rawValue)")
                    return true
                case .unverified:
                    print("⚠️ Transaction non vérifiée")
                    return false
                }
            case .userCancelled:
                print("ℹ️ Achat annulé par l'utilisateur")
                return false
            case .pending:
                print("⏳ Achat en attente")
                return false
            @unknown default:
                return false
            }
        } catch {
            print("❌ Erreur d'achat: \(error)")
            return false
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
        .environmentObject(ZmanimService())
        .environmentObject(NotificationManager())
}
