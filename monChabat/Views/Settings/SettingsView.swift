//
//  SettingsView.swift
//  monChabat
//
//  Vue des paramètres de l'application
//

import SwiftUI
import StoreKit

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

#Preview {
    SettingsView()
        .environmentObject(AppState())
        .environmentObject(ZmanimService())
        .environmentObject(NotificationManager())
}
