//
//  MainTabView.swift
//  monChabat
//
//  Navigation principale avec Tab Bar style Liquid Glass
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingSettings = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Global Header fixe
            GlobalHeader(showingSettings: $showingSettings)
            
            // Content
            TabView(selection: $appState.selectedTab) {
                Tab("Accueil", systemImage: "flame.fill", value: AppState.Tab.accueil) {
                    AccueilContentView()
                }
                
                Tab("Invités", systemImage: "person.2.fill", value: AppState.Tab.guests) {
                    GuestsContentView()
                }
                
                Tab("Maison", systemImage: "house.fill", value: AppState.Tab.maison) {
                    MaisonContentView()
                }
                
                Tab("Recettes", systemImage: "book.fill", value: AppState.Tab.recipes) {
                    RecipesContentView()
                }
            }
            .tint(Color.shabGold)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

// MARK: - Global Header
struct GlobalHeader: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var zmanimService: ZmanimService
    @Binding var showingSettings: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Safe area filler
            Color.clear
                .frame(height: 0)
            
            HStack {
                // Titre avec dégradé
                Text("monChabat")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.shabGold, Color.shabCandleOrange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
                
                // Bouton Réglages (ouvre popup)
                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.body)
                        .foregroundStyle(Color.primary.opacity(0.7))
                        .padding(8)
                        .background {
                            Circle()
                                .fill(Color(UIColor.secondarySystemBackground))
                                .shadow(color: Color.black.opacity(0.08), radius: 2, y: 1)
                        }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .background(Color.shabGold.opacity(0.25))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.shabGold.opacity(0.6))
                .frame(height: 1.5)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
        .environmentObject(ZmanimService())
        .environmentObject(NotificationManager())
}
