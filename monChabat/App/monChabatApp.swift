//
//  monChabatApp.swift
//  monChabat
//
//  Application principale pour la gestion du Shabbat
//  Design inspiré du style "Liquid Glass" d'iOS 26
//

import SwiftUI
import SwiftData
import Combine

@main
struct monChabatApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var zmanimService = ZmanimService()
    @StateObject private var notificationManager = NotificationManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ChecklistItem.self,
            ShoppingItem.self,
            MealPlan.self,
            Guest.self,
            Recipe.self,
            TableSeat.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appState)
                .environmentObject(zmanimService)
                .environmentObject(notificationManager)
                .preferredColorScheme(appState.appearanceMode.colorScheme)
        }
        .modelContainer(sharedModelContainer)
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var appearanceMode: AppearanceMode {
        didSet {
            UserDefaults.standard.set(appearanceMode.rawValue, forKey: "appearanceMode")
        }
    }
    @Published var defaultServings: Int {
        didSet {
            UserDefaults.standard.set(defaultServings, forKey: "defaultServings")
        }
    }
    @Published var isPanicMode: Bool = false
    @Published var selectedTab: Tab = .accueil
    @Published var showOnboarding: Bool = false
    
    enum Tab: Int, CaseIterable {
        case accueil = 0
        case guests
        case maison
        case recipes
        case settings
    }
    
    enum AppearanceMode: String, CaseIterable {
        case system = "Automatique"
        case light = "Clair"
        case dark = "Sombre"
        
        var colorScheme: ColorScheme? {
            switch self {
            case .system: return nil
            case .light: return .light
            case .dark: return .dark
            }
        }
    }
    
    init() {
        let savedMode = UserDefaults.standard.string(forKey: "appearanceMode") ?? AppearanceMode.system.rawValue
        self.appearanceMode = AppearanceMode(rawValue: savedMode) ?? .system
        self.defaultServings = UserDefaults.standard.object(forKey: "defaultServings") as? Int ?? 4
    }
}
