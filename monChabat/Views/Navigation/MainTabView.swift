//
//  MainTabView.swift
//  monChabat
//
//  Navigation principale avec Tab Bar style Liquid Glass
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @Namespace private var tabAnimation
    @State private var showingSettings = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Global Header fixe
            GlobalHeader(showingSettings: $showingSettings)
            
            // Content
            ZStack(alignment: .bottom) {
                TabView(selection: $appState.selectedTab) {
                    AccueilContentView()
                        .tag(AppState.Tab.accueil)
                        .toolbar(.hidden, for: .tabBar)
                    
                    GuestsContentView()
                        .tag(AppState.Tab.guests)
                        .toolbar(.hidden, for: .tabBar)
                    
                    MaisonContentView()
                        .tag(AppState.Tab.maison)
                        .toolbar(.hidden, for: .tabBar)
                    
                    RecipesContentView()
                        .tag(AppState.Tab.recipes)
                        .toolbar(.hidden, for: .tabBar)
                }
                
                // Custom Glass Tab Bar
                GlassTabBar(selectedTab: $appState.selectedTab, namespace: tabAnimation)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
            }
        }
        .ignoresSafeArea(edges: .bottom)
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
                // Logo et titre
                HStack(spacing: 10) {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundStyle(Color.shabGold)
                    
                    Text("monChabat")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }
                
                Spacer()
                
                // Bouton Réglages (ouvre popup)
                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title3)
                        .foregroundStyle(Color.primary.opacity(0.7))
                        .padding(10)
                        .background {
                            Circle()
                                .fill(Color(UIColor.secondarySystemBackground))
                                .shadow(color: Color.black.opacity(0.08), radius: 2, y: 1)
                        }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(Color.shabGold.opacity(0.25))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.shabGold.opacity(0.6))
                .frame(height: 1.5)
        }
    }
}

// MARK: - Glass Tab Bar
struct GlassTabBar: View {
    @Binding var selectedTab: AppState.Tab
    var namespace: Namespace.ID
    
    private let tabs: [(AppState.Tab, String, String)] = [
        (.accueil, "flame.fill", "Accueil"),
        (.guests, "person.2.fill", "Invités"),
        (.maison, "house.fill", "Maison"),
        (.recipes, "book.fill", "Recettes")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.0) { tab, icon, title in
                TabBarButton(
                    icon: icon,
                    title: title,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                    HapticManager.selection()
                }
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 6)
        .background {
            Capsule()
                .fill(.regularMaterial)
                .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
        }
    }
}

// MARK: - Tab Bar Button
struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundStyle(isSelected ? .white : Color.primary.opacity(0.5))
            .frame(width: 75, height: 52)
            .background {
                if isSelected {
                    Capsule()
                        .fill(Color.shabGold.opacity(0.9))
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
        .environmentObject(ZmanimService())
        .environmentObject(NotificationManager())
}
