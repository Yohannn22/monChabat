//
//  SpiritualView.swift
//  monChabat
//
//  Module "Spirituel & Contenu"
//  Zmanim, Dvar Torah, Bibliothèque de prières, Générateur PDF
//

import SwiftUI

struct SpiritualView: View {
    @EnvironmentObject var zmanimService: ZmanimService
    @EnvironmentObject var notificationManager: NotificationManager
    
    @State private var selectedSection: SpiritualSection = .zmanim
    @State private var showingParashaDetail = false
    @State private var showingPDFGenerator = false
    @State private var selectedNusach: Nusach = .ashkenaz
    @State private var showQuiz = false
    
    enum SpiritualSection: String, CaseIterable {
        case zmanim = "Horaires"
        case parasha = "Paracha"
        case prayers = "Prières"
    }
    
    enum Nusach: String, CaseIterable {
        case ashkenaz = "Achkénaze"
        case sefarad = "Séfarade"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Animated background
                backgroundView
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Candle Animation Header
                        candleHeader
                        
                        // Section Picker
                        sectionPicker
                        
                        // Content
                        switch selectedSection {
                        case .zmanim:
                            zmanimSection
                        case .parasha:
                            parashaSection
                        case .prayers:
                            prayersSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Spirituel")
                        .font(.headline)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingPDFGenerator = true
                    } label: {
                        Image(systemName: "doc.badge.plus")
                            .font(.title3)
                            .foregroundStyle(Color.shabGold)
                    }
                }
            }
            .sheet(isPresented: $showingPDFGenerator) {
                PDFGeneratorSheet()
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
    
    // MARK: - Candle Header
    private var candleHeader: some View {
        VStack(spacing: 20) {
            HStack(spacing: 30) {
                AnimatedCandleView()
                AnimatedCandleView()
            }
            
            if let parasha = zmanimService.currentParasha {
                VStack(spacing: 4) {
                    Text("Paracha")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(parasha.hebrewName)
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundStyle(Color.shabGold)
                    Text(parasha.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("שבת שלום")
                .font(.system(size: 24, weight: .medium, design: .serif))
                .foregroundStyle(Color.shabGold.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .liquidGlassCard()
    }
    
    // MARK: - Section Picker
    private var sectionPicker: some View {
        HStack(spacing: 8) {
            ForEach(SpiritualSection.allCases, id: \.self) { section in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedSection = section
                    }
                } label: {
                    Text(section.rawValue)
                        .font(.system(size: 14, weight: selectedSection == section ? .semibold : .regular))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background {
                            if selectedSection == section {
                                Capsule()
                                    .fill(Color.shabGold.opacity(0.2))
                            }
                        }
                        .foregroundStyle(selectedSection == section ? Color.shabGold : .secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background {
            Capsule()
                .fill(.ultraThinMaterial)
        }
    }
    
    // MARK: - Zmanim Section
    private var zmanimSection: some View {
        VStack(spacing: 16) {
            // Main times
            if let zmanim = zmanimService.currentZmanim {
                VStack(spacing: 0) {
                    ZmanRow(
                        icon: "flame.fill",
                        iconColor: .shabCandleOrange,
                        title: "Allumage des bougies",
                        time: zmanim.candleLightingFormatted,
                        subtitle: zmanim.dateFormatted
                    )
                    
                    Divider().padding(.horizontal)
                    
                    ZmanRow(
                        icon: "moon.stars.fill",
                        iconColor: .shabSoftPurple,
                        title: "Havdalah",
                        time: zmanim.havdalahFormatted,
                        subtitle: nil
                    )
                }
                .padding(.vertical, 8)
                .liquidGlassCard(cornerRadius: 20)
            }
            
            // Countdown
            countdownCard
            
            // Notification Settings
            notificationSettingsCard
            
            // Additional Zmanim (placeholders)
            additionalZmanimCard
        }
    }
    
    private var countdownCard: some View {
        VStack(spacing: 16) {
            if let remaining = zmanimService.timeUntilCandleLighting(), remaining > 0 {
                GlassSectionHeader(title: "Compte à rebours", icon: "timer", action: nil, actionLabel: nil)
                
                HStack(spacing: 20) {
                    CountdownUnit(value: Int(remaining) / 86400, unit: "jours")
                    CountdownUnit(value: (Int(remaining) % 86400) / 3600, unit: "heures")
                    CountdownUnit(value: (Int(remaining) % 3600) / 60, unit: "min")
                }
            } else if zmanimService.isShabbat() {
                VStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.largeTitle)
                        .foregroundStyle(Color.shabGold)
                    Text("Chabat Chalom!")
                        .font(.title2.bold())
                    Text("Le Chabat est en cours")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .liquidGlassCard()
    }
    
    private var notificationSettingsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            GlassSectionHeader(title: "Rappels", icon: "bell.fill", action: nil, actionLabel: nil)
            
            Toggle(isOn: $notificationManager.reminder1HourEnabled) {
                Label("1 heure avant", systemImage: "clock")
            }
            .tint(Color.shabGold)
            
            Toggle(isOn: $notificationManager.reminder15MinEnabled) {
                Label("15 minutes avant", systemImage: "clock.badge.exclamationmark")
            }
            .tint(Color.shabGold)
            
            Toggle(isOn: $notificationManager.candleLightingReminderEnabled) {
                Label("À l'allumage", systemImage: "flame")
            }
            .tint(Color.shabGold)
        }
        .padding(20)
        .liquidGlassCard()
        .onChange(of: notificationManager.reminder1HourEnabled) { _, _ in
            scheduleNotifications()
        }
        .onChange(of: notificationManager.reminder15MinEnabled) { _, _ in
            scheduleNotifications()
        }
    }
    
    private func scheduleNotifications() {
        if let zmanim = zmanimService.currentZmanim {
            Task {
                await notificationManager.scheduleCandleLightingReminders(for: zmanim.candleLighting)
            }
        }
    }
    
    private var additionalZmanimCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            GlassSectionHeader(title: "Autres horaires", icon: "clock.fill", action: nil, actionLabel: nil)
            
            // These would be fetched from the API in a full implementation
            AdditionalZmanRow(title: "Fin du Shema", time: "09:45", note: "Magen Avraham")
            AdditionalZmanRow(title: "Plag HaMincha", time: "16:30", note: nil)
            AdditionalZmanRow(title: "Mincha Guedola", time: "12:35", note: nil)
        }
        .padding(20)
        .liquidGlassCard()
    }
    
    // MARK: - Parasha Section
    private var parashaSection: some View {
        VStack(spacing: 16) {
            // Résumé de la Paracha
            parashaSummaryCard
            
            // Dvar Torah Flash
            dvarTorahCard
            
            // Quiz for kids
            quizCard
            
            // Full parasha link
            parashaLinkCard
        }
    }
    
    // MARK: - Parasha Summary Card
    private var parashaSummaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header avec nom de la Paracha
            if let parasha = zmanimService.currentParasha {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Paracha de la semaine")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 8) {
                            Text(parasha.hebrewName)
                                .font(.system(size: 28, weight: .bold, design: .serif))
                                .foregroundStyle(Color.shabGold)
                            
                            Text("•")
                                .foregroundStyle(.secondary)
                            
                            Text(parasha.name)
                                .font(.title3.weight(.medium))
                                .foregroundStyle(.primary)
                        }
                        
                        if let summary = parasha.summary {
                            Text(summary.book.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(Color.shabGold.opacity(0.15)))
                                .foregroundStyle(Color.shabGold)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.shabGold.opacity(0.3))
                }
                
                Divider()
                
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
                    // Fallback si pas de résumé
                    Text("Résumé non disponible pour cette Paracha.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            } else {
                // Chargement
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
    
    private var dvarTorahCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "text.book.closed.fill")
                    .font(.title2)
                    .foregroundStyle(Color.shabGold)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Dvar Torah Flash")
                        .font(.headline)
                    Text("3 points clés pour la table")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "doc.on.doc")
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                DvarTorahPoint(
                    number: 1,
                    title: "Le message principal",
                    content: "Cette semaine, la Torah nous enseigne l'importance de..."
                )
                
                DvarTorahPoint(
                    number: 2,
                    title: "Application pratique",
                    content: "Comment appliquer cela dans notre vie quotidienne..."
                )
                
                DvarTorahPoint(
                    number: 3,
                    title: "Question pour la table",
                    content: "Demandez à vos convives : Qu'est-ce qui vous a marqué cette semaine ?"
                )
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
    
    private var parashaLinkCard: some View {
        NavigationLink {
            ParashaDetailView()
        } label: {
            HStack {
                Image(systemName: "book.fill")
                    .foregroundStyle(Color.shabGold)
                Text("Lire la Paracha complète")
                    .font(.subheadline.bold())
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .liquidGlassCard(cornerRadius: 14)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Prayers Section
    private var prayersSection: some View {
        VStack(spacing: 16) {
            // Nusach picker
            nusachPicker
            
            // Kiddush
            PrayerCard(
                title: "Kiddouch",
                hebrewTitle: "קידוש",
                icon: "wineglass.fill",
                nusach: selectedNusach
            )
            
            // Birkat Hamazon
            PrayerCard(
                title: "Birkat Hamazon",
                hebrewTitle: "ברכת המזון",
                icon: "fork.knife",
                nusach: selectedNusach
            )
            
            // Zemirot
            ZemirotSection()
            
            // Havdalah
            PrayerCard(
                title: "Havdalah",
                hebrewTitle: "הבדלה",
                icon: "flame.fill",
                nusach: selectedNusach
            )
        }
    }
    
    private var nusachPicker: some View {
        HStack {
            Text("Nousach")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Picker("Nusach", selection: $selectedNusach) {
                ForEach(Nusach.allCases, id: \.self) { nusach in
                    Text(nusach.rawValue).tag(nusach)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
        }
        .padding(16)
        .liquidGlassCard(cornerRadius: 14)
    }
}

// MARK: - Supporting Views

struct ZmanRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let time: String
    let subtitle: String?
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Text(time)
                .font(.system(size: 28, weight: .bold, design: .rounded))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

struct CountdownUnit: View {
    let value: Int
    let unit: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color.shabGold)
            Text(unit)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct AdditionalZmanRow: View {
    let title: String
    let time: String
    let note: String?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
            if let note = note {
                Text("(\(note))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(time)
                .font(.system(.subheadline, design: .monospaced))
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

struct DvarTorahPoint: View {
    let number: Int
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.shabGold.opacity(0.2))
                    .frame(width: 28, height: 28)
                Text("\(number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.shabGold)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                Text(content)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct PrayerCard: View {
    let title: String
    let hebrewTitle: String
    let icon: String
    let nusach: SpiritualView.Nusach
    
    var body: some View {
        NavigationLink {
            PrayerDetailView(title: title, hebrewTitle: hebrewTitle, nusach: nusach)
        } label: {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(Color.shabGold)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    Text(hebrewTitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .liquidGlassCard(cornerRadius: 16)
        }
        .buttonStyle(.plain)
    }
}

struct ZemirotSection: View {
    let zemirot = [
        ("Shalom Aleichem", "שלום עליכם"),
        ("Eshet Chayil", "אשת חיל"),
        ("Tzur Mishelo", "צור משלו"),
        ("Yah Ribon", "יה רבון"),
        ("Dror Yikra", "דרור יקרא")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GlassSectionHeader(title: "Zemirot", icon: "music.note", action: nil, actionLabel: nil)
            
            ForEach(zemirot, id: \.0) { name, hebrew in
                NavigationLink {
                    ZemiraDetailView(name: name, hebrew: hebrew)
                } label: {
                    HStack {
                        Text(name)
                            .font(.subheadline)
                        Spacer()
                        Text(hebrew)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
        .liquidGlassCard()
    }
}

// MARK: - Detail Views

struct ParashaDetailView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Contenu complet de la Paracha")
                    .font(.headline)
                
                Text("Le contenu détaillé de la Paracha sera affiché ici avec le texte hébreu et la traduction française.")
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Paracha")
    }
}

struct ParashaQuizView: View {
    @Environment(\.dismiss) private var dismiss
    let parashaName: String
    
    @State private var currentQuestion = 0
    @State private var score = 0
    @State private var selectedAnswer: Int? = nil
    @State private var hasAnswered = false
    @State private var showResult = false
    
    private var quiz: ParashaQuiz? {
        ParashaQuizDatabase.getQuiz(for: parashaName)
    }
    
    private var questions: [QuizQuestion] {
        quiz?.questions ?? []
    }
    
    init(parashaName: String = "Bereshit") {
        self.parashaName = parashaName
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Drag indicator custom
            Capsule()
                .fill(Color(UIColor.tertiaryLabel))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 12)
            
            // Contenu principal
            if questions.isEmpty {
                emptyQuizView
            } else if !showResult {
                questionView
            } else {
                resultView
            }
        }
        .presentationDetents([.height(520)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(24)
        .presentationBackground(Color(UIColor.systemBackground))
    }
    
    // MARK: - Empty Quiz View
    private var emptyQuizView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "questionmark.circle")
                .font(.system(size: 50))
                .foregroundStyle(Color.shabGold.opacity(0.5))
            
            Text("Quiz non disponible")
                .font(.headline)
            
            Text("Le quiz pour cette Paracha n'est pas encore disponible.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Fermer")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(UIColor.secondarySystemBackground))
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Question View
    private var questionView: some View {
        VStack(spacing: 0) {
            // Header avec score et progression
            HStack {
                // Nom de la paracha
                HStack(spacing: 6) {
                    Text("📖")
                    Text(quiz?.hebrewName ?? parashaName)
                        .font(.subheadline.bold())
                }
                
                Spacer()
                
                // Score
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(Color.shabGold)
                    Text("\(score)")
                        .font(.subheadline.bold())
                        .foregroundStyle(Color.shabGold)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.shabGold.opacity(0.15))
                .clipShape(Capsule())
                
                // Progression
                Text("\(currentQuestion + 1)/\(questions.count)")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(UIColor.tertiarySystemFill))
                    .clipShape(Capsule())
                
                // Close button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .padding(8)
                        .background(Color(UIColor.tertiarySystemFill))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            // Barre de progression
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(UIColor.tertiarySystemFill))
                    
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.shabGold.gradient)
                        .frame(width: geo.size.width * CGFloat(currentQuestion + 1) / CGFloat(questions.count))
                }
            }
            .frame(height: 4)
            .padding(.horizontal, 20)
            
            // Question
            Text(questions[currentQuestion].question)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            
            // Options
            VStack(spacing: 8) {
                ForEach(0..<questions[currentQuestion].options.count, id: \.self) { index in
                    optionButton(for: index)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer(minLength: 12)
            
            // Zone feedback + bouton (hauteur fixe)
            VStack(spacing: 10) {
                if hasAnswered {
                    // Feedback
                    HStack(spacing: 10) {
                        Image(systemName: selectedAnswer == questions[currentQuestion].correctAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(selectedAnswer == questions[currentQuestion].correctAnswer ? .green : .red)
                            .font(.title3)
                        
                        if let explanation = questions[currentQuestion].explanation {
                            Text(explanation)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedAnswer == questions[currentQuestion].correctAnswer ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    )
                    .padding(.horizontal, 20)
                    
                    // Bouton suivant
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            if currentQuestion < questions.count - 1 {
                                currentQuestion += 1
                                selectedAnswer = nil
                                hasAnswered = false
                            } else {
                                showResult = true
                            }
                        }
                    } label: {
                        HStack {
                            Text(currentQuestion < questions.count - 1 ? "Suivant" : "Voir le résultat")
                                .font(.subheadline.bold())
                            Image(systemName: "arrow.right")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.shabGold.gradient)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 20)
                } else {
                    // Placeholder pour garder la même hauteur
                    Color.clear
                        .frame(height: 110)
                }
            }
            .frame(height: 130)
            .padding(.bottom, 16)
        }
    }
    
    private func optionButton(for index: Int) -> some View {
        Button {
            if !hasAnswered {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedAnswer = index
                    hasAnswered = true
                    
                    if index == questions[currentQuestion].correctAnswer {
                        score += 1
                    }
                }
            }
        } label: {
            HStack(spacing: 12) {
                Text(["A", "B", "C", "D"][index])
                    .font(.caption.bold())
                    .foregroundStyle(hasAnswered ? (index == questions[currentQuestion].correctAnswer ? .white : (selectedAnswer == index ? .white : .secondary)) : .white.opacity(0.9))
                    .frame(width: 24, height: 24)
                    .background(
                        Circle()
                            .fill(hasAnswered ? backgroundColor(for: index) : Color.shabGold.opacity(0.7))
                    )
                
                Text(questions[currentQuestion].options[index])
                    .font(.subheadline)
                    .foregroundStyle(hasAnswered ? textColor(for: index) : .primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Spacer()
                
                if hasAnswered {
                    if index == questions[currentQuestion].correctAnswer {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else if selectedAnswer == index {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(hasAnswered ? backgroundColor(for: index).opacity(0.12) : Color(UIColor.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(hasAnswered ? borderColor(for: index) : Color.clear, lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(hasAnswered)
    }
    
    // MARK: - Result View
    private var resultView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Emoji
            Text(scoreEmoji)
                .font(.system(size: 60))
            
            // Titre
            Text(scoreTitle)
                .font(.title2.bold())
                .foregroundStyle(scoreColor)
                .padding(.top, 8)
            
            // Score
            HStack(spacing: 0) {
                Text("\(score)")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(scoreColor)
                Text("/\(questions.count)")
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 4)
            
            // Message
            Text(resultMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 8)
            
            // Barre de score
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(UIColor.tertiarySystemFill))
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(scoreColor.gradient)
                        .frame(width: geo.size.width * CGFloat(score) / CGFloat(max(questions.count, 1)))
                }
            }
            .frame(height: 10)
            .padding(.horizontal, 50)
            .padding(.top, 20)
            
            Spacer()
            
            // Boutons
            VStack(spacing: 10) {
                Button {
                    withAnimation {
                        currentQuestion = 0
                        score = 0
                        selectedAnswer = nil
                        hasAnswered = false
                        showResult = false
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Rejouer")
                    }
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.shabGold.gradient)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("Fermer")
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(UIColor.secondarySystemBackground))
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Styling Helpers
    
    private func backgroundColor(for index: Int) -> Color {
        if !hasAnswered { return Color(UIColor.secondarySystemBackground) }
        if index == questions[currentQuestion].correctAnswer { return .green }
        else if selectedAnswer == index { return .red }
        return Color(UIColor.secondarySystemBackground)
    }
    
    private func borderColor(for index: Int) -> Color {
        if !hasAnswered { return .clear }
        if index == questions[currentQuestion].correctAnswer { return .green }
        else if selectedAnswer == index { return .red }
        return .clear
    }
    
    private func textColor(for index: Int) -> Color {
        if !hasAnswered { return .primary }
        if index == questions[currentQuestion].correctAnswer { return .green }
        else if selectedAnswer == index { return .red }
        return .secondary
    }
    
    private var scoreEmoji: String {
        if score == questions.count { return "🏆" }
        else if Double(score) >= Double(questions.count) * 0.75 { return "🌟" }
        else if Double(score) >= Double(questions.count) * 0.5 { return "👍" }
        else if score > 0 { return "📚" }
        else { return "💪" }
    }
    
    private var scoreTitle: String {
        if score == questions.count { return "Parfait !" }
        else if Double(score) >= Double(questions.count) * 0.75 { return "Excellent !" }
        else if Double(score) >= Double(questions.count) * 0.5 { return "Bien joué !" }
        else if score > 0 { return "Continue !" }
        else { return "Réessaie !" }
    }
    
    private var resultMessage: String {
        if score == questions.count { return "Mazal Tov ! Tu as tout bon ! 🎉" }
        else if Double(score) >= Double(questions.count) * 0.75 { return "Très bonne connaissance de la Paracha !" }
        else if Double(score) >= Double(questions.count) * 0.5 { return "Pas mal ! Tu connais bien la Paracha." }
        else if score > 0 { return "Relis la Paracha et réessaie !" }
        else { return "N'abandonne pas !" }
    }
    
    private var scoreColor: Color {
        if Double(score) >= Double(questions.count) * 0.75 { return .green }
        else if Double(score) >= Double(questions.count) * 0.5 { return Color.shabGold }
        else if score > 0 { return .orange }
        else { return .red }
    }
}

struct PrayerDetailView: View {
    let title: String
    let hebrewTitle: String
    let nusach: SpiritualView.Nusach
    
    @State private var fontSize: CGFloat = 18
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Hebrew text
                Text(sampleHebrewText)
                    .font(.system(size: fontSize, design: .serif))
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
                    .liquidGlassCard()
                
                // Transliteration
                VStack(alignment: .leading, spacing: 8) {
                    Text("Translittération")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(sampleTransliteration)
                        .font(.system(size: fontSize - 2))
                        .italic()
                }
                .padding()
                .liquidGlassCard()
            }
            .padding()
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        fontSize = max(14, fontSize - 2)
                    } label: {
                        Label("Réduire", systemImage: "textformat.size.smaller")
                    }
                    
                    Button {
                        fontSize = min(28, fontSize + 2)
                    } label: {
                        Label("Agrandir", systemImage: "textformat.size.larger")
                    }
                } label: {
                    Image(systemName: "textformat.size")
                }
            }
        }
    }
    
    private var sampleHebrewText: String {
        """
        בָּרוּךְ אַתָּה יְיָ אֱלֹהֵינוּ מֶלֶךְ הָעוֹלָם
        בּוֹרֵא פְּרִי הַגָּפֶן
        """
    }
    
    private var sampleTransliteration: String {
        "Baroukh Ata Adonaï Elohénou Melekh Haolam, boré peri hagafen."
    }
}

struct ZemiraDetailView: View {
    let name: String
    let hebrew: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Paroles de \(name)")
                    .font(.headline)
                
                Text("Les paroles complètes seront affichées ici...")
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle(name)
    }
}

// MARK: - PDF Generator Sheet

struct PDFGeneratorSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var includeKiddush = true
    @State private var includeBirkatHamazon = true
    @State private var includeDvarTorah = true
    @State private var selectedZemirot: Set<String> = []
    
    let zemirot = ["Shalom Aleichem", "Eshet Chayil", "Tzur Mishelo", "Yah Ribon", "Dror Yikra"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Contenu à inclure") {
                    Toggle("Kiddouch", isOn: $includeKiddush)
                    Toggle("Birkat Hamazon", isOn: $includeBirkatHamazon)
                    Toggle("Dvar Torah", isOn: $includeDvarTorah)
                }
                
                Section("Zemirot") {
                    ForEach(zemirot, id: \.self) { zemira in
                        Toggle(zemira, isOn: Binding(
                            get: { selectedZemirot.contains(zemira) },
                            set: { isOn in
                                if isOn {
                                    selectedZemirot.insert(zemira)
                                } else {
                                    selectedZemirot.remove(zemira)
                                }
                            }
                        ))
                    }
                }
                
                Section {
                    Button {
                        generatePDF()
                    } label: {
                        Label("Générer le PDF", systemImage: "doc.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(LiquidGlassButtonStyle(isAccent: true))
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Feuillet Chabat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
            }
        }
    }
    
    private func generatePDF() {
        // PDF generation logic would go here
        // For now, just dismiss
        dismiss()
    }
}

// MARK: - Content View (sans NavigationStack pour MainTabView)
struct SpiritualContentView: View {
    var body: some View {
        SpiritualView()
            .navigationBarHidden(true)
    }
}

#Preview {
    SpiritualView()
        .environmentObject(ZmanimService())
        .environmentObject(NotificationManager())
}
