//
//  AccueilView.swift
//  monChabat
//
//  Vue d'accueil principale avec Zmanim, bougies et Paracha
//

import SwiftUI

struct AccueilView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var zmanimService: ZmanimService
    @EnvironmentObject var notificationManager: NotificationManager
    
    @State private var showQuiz = false

    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                backgroundView
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Espace pour décoller du header
                        Spacer()
                            .frame(height: 8)
                        
                        // Header avec bougies et Zmanim
                        mainHeaderCard
                        
                        // Événements à venir (Yom Tov / Jeûnes)
                        if !zmanimService.upcomingEvents.isEmpty {
                            upcomingEventsSection
                        }
                        
                        // Contenu Paracha directement (pas de picker)
                        parashaSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                // Charger les données au démarrage
                await zmanimService.loadDataIfNeeded()
            }
        }
    }
    
    // MARK: - Upcoming Events Section
    private var upcomingEventsSection: some View {
        VStack(spacing: 12) {
            ForEach(zmanimService.upcomingEvents.prefix(3)) { event in
                UpcomingEventCard(event: event)
            }
        }
    }
    
    // MARK: - Background
    private var backgroundView: some View {
        ZStack {
            Color(UIColor.systemBackground)
            
            // Subtle gradient overlay
            RadialGradient(
                colors: [
                    Color.shabCandleOrange.opacity(0.08),
                    Color.clear
                ],
                center: .top,
                startRadius: 0,
                endRadius: 400
            )
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Main Header Card (Bougies + Zmanim)
    private var mainHeaderCard: some View {
        VStack(spacing: 20) {
            // Bougies animées avec Paracha/Yom Tov au milieu
            HStack(spacing: 0) {
                AnimatedCandleView()
                    .frame(width: 60)
                
                // Paracha ou Yom Tov au centre
                if let parasha = zmanimService.currentParasha {
                    VStack(spacing: 4) {
                        // Nom hébreu
                        Text(parasha.hebrewName.replacingOccurrences(of: "פרשת ", with: ""))
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.shabGold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        // Nom phonétique
                        if let summary = parasha.summary {
                            // C'est une vraie parasha
                            Text(summary.name)
                                .font(.subheadline)
                                .foregroundStyle(Color.shabSoftPurple)
                        } else {
                            // C'est un Yom Tov - afficher le nom traduit
                            Text(parasha.name)
                                .font(.subheadline)
                                .foregroundStyle(Color.shabSoftPurple)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 8)
                }
                
                AnimatedCandleView()
                    .frame(width: 60)
            }
            
            // Horaires Allumage et Havdalah
            if let zmanim = zmanimService.currentZmanim {
                HStack(spacing: 0) {
                    // Candle lighting
                    VStack(spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .foregroundStyle(Color.shabCandleOrange)
                            Text("Allumage")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text(zmanim.candleLightingFormatted)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                        .frame(height: 50)
                    
                    // Havdalah
                    VStack(spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "moon.stars.fill")
                                .foregroundStyle(Color.shabSoftPurple)
                            Text("Havdalah")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text(zmanim.havdalahFormatted)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Temps restant avant allumage
                if let remaining = zmanimService.timeUntilCandleLighting(), remaining > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                        Text("Allumage dans")
                            .font(.caption)
                        Text(zmanimService.formattedTimeRemaining(remaining))
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(remaining < 3600 ? Color.red : Color.shabGold)
                    }
                    .foregroundStyle(.secondary)
                }
                
                // Location & Date
                HStack {
                    Image(systemName: "location.fill")
                        .font(.caption)
                    Text(zmanim.location)
                        .font(.caption)
                    Text("•")
                    Text(zmanim.dateFormatted)
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
                
            } else {
                ProgressView()
                    .padding()
                Text("Chargement des horaires...")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Chabat Chalom
            Text("שבת שלום")
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .foregroundStyle(Color.shabGold.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .liquidGlassCard()
    }
    

    
    // MARK: - Paracha Section
    private var parashaSection: some View {
        VStack(spacing: 16) {
            // Résumé de la Paracha
            parashaSummaryCard
            
            // Quiz for kids
            quizCard
        }
    }
    
    // MARK: - Parasha Summary Card
    private var parashaSummaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            if let parasha = zmanimService.currentParasha {
                HStack {
                    Text("Résumé de la paracha")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    if let summary = parasha.summary {
                        Text(summary.book.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(Color.shabGold.opacity(0.15)))
                            .foregroundStyle(Color.shabGold)
                    }
                }
                
                // Résumé
                if let summary = parasha.summary {
                    VStack(alignment: .leading, spacing: 12) {
                        // Résumé principal
                        Text(summary.summary)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .lineSpacing(4)
                        
                        // Thèmes
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Thèmes principaux")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                            
                            FlowLayout(spacing: 6) {
                                ForEach(summary.themes, id: \.self) { theme in
                                    Text(theme)
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Capsule().fill(Color.shabSoftPurple.opacity(0.15)))
                                        .foregroundStyle(Color.shabSoftPurple)
                                }
                            }
                        }
                        
                        // Versets clés
                        if !summary.keyVerses.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Versets clés")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                
                                ForEach(summary.keyVerses, id: \.self) { verse in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "quote.opening")
                                            .font(.caption2)
                                            .foregroundStyle(Color.shabGold)
                                        
                                        Text(verse)
                                            .font(.subheadline)
                                            .italic()
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Text("Résumé non disponible pour cette Paracha.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            } else {
                HStack {
                    ProgressView()
                    Text("Chargement de la Paracha...")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(20)
        .liquidGlassCard()
    }
    
    private var quizCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "questionmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color.shabSoftPurple)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Quiz Enfants")
                        .font(.headline)
                    Text("Sur la Paracha de la semaine")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    showQuiz = true
                } label: {
                    Text("Jouer")
                        .font(.subheadline.bold())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.shabSoftPurple.opacity(0.2)))
                        .foregroundStyle(Color.shabSoftPurple)
                }
            }
        }
        .padding(20)
        .liquidGlassCard()
        .sheet(isPresented: $showQuiz) {
            ParashaQuizView(parashaName: zmanimService.currentParasha?.name ?? "Bereshit")
        }
    }
}

// MARK: - Upcoming Event Card
struct UpcomingEventCard: View {
    let event: JewishEvent
    
    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                Circle()
                    .fill(event.type.color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: event.type.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(event.type.color)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(event.type == .fast ? "Jeûne \(event.name)" : event.name)
                        .font(.system(size: 15, weight: .semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Spacer()
                    
                    Text(event.daysUntilText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color(UIColor.tertiarySystemBackground)))
                }
                
                Text(event.dateFormatted)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if !event.timeFormatted.isEmpty {
                    Text(event.timeFormatted)
                        .font(.caption)
                        .foregroundStyle(event.type.color)
                }
            }
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(event.type == .yomTov 
                      ? Color.shabGold.opacity(0.08)
                      : Color.shabDeepBlue.opacity(0.08))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(event.type.color.opacity(0.2), lineWidth: 1)
        }
    }
}

// MARK: - Content View (sans NavigationStack pour MainTabView)
struct AccueilContentView: View {
    var body: some View {
        AccueilView()
            .navigationBarHidden(true)
    }
}

#Preview {
    AccueilView()
        .environmentObject(AppState())
        .environmentObject(ZmanimService())
        .environmentObject(NotificationManager())
}
