//
//  HomeView.swift
//  monChabat
//
//  Module "Logistique & Maison" - Le cœur de l'app
//  Check-list, Mode Panique, Liste de courses, Meal Planner
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var zmanimService: ZmanimService
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \ChecklistItem.order) private var checklistItems: [ChecklistItem]
    @Query private var shoppingItems: [ShoppingItem]
    
    @State private var showingAddItem = false
    @State private var showingShoppingList = false
    @State private var showingMealPlanner = false
    @State private var selectedSection: HomeSection = .checklist
    
    enum HomeSection: String, CaseIterable {
        case checklist = "Check-list"
        case shopping = "Courses"
        case meals = "Menus"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                backgroundGradient
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with Zmanim
                        zmanimHeader
                        
                        // Panic Mode Toggle
                        if !appState.isPanicMode {
                            panicModeCard
                        }
                        
                        // Section Picker
                        sectionPicker
                        
                        // Content based on section
                        switch selectedSection {
                        case .checklist:
                            checklistSection
                        case .shopping:
                            shoppingSection
                        case .meals:
                            mealPlannerSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if appState.isPanicMode {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Sortir") {
                            withAnimation {
                                appState.isPanicMode = false
                            }
                        }
                        .foregroundStyle(.red)
                    }
                }
                
                if appState.isPanicMode {
                    ToolbarItem(placement: .principal) {
                        Text("🚨 Mode Panique")
                            .font(.headline)
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddItemSheet(section: selectedSection)
            }
            .onAppear {
                initializeDefaultItems()
                Task {
                    zmanimService.requestLocation()
                }
            }
        }
    }
    
    // MARK: - Background
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(UIColor.systemBackground),
                appState.isPanicMode ? Color.red.opacity(0.05) : Color.shabGold.opacity(0.05)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Zmanim Header
    private var zmanimHeader: some View {
        VStack(spacing: 16) {
            // Paracha de la semaine
            if let parasha = zmanimService.currentParasha {
                VStack(spacing: 4) {
                    Text("Paracha")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(parasha.hebrewName)
                        .font(.custom("Heebo-Bold", size: 24))
                        .foregroundStyle(Color.shabGold)
                }
                .padding(.bottom, 8)
            }
            
            if let zmanim = zmanimService.currentZmanim {
                // Horaires Allumage et Havdalah
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
                            .font(.system(size: 32, weight: .bold, design: .rounded))
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
                            .font(.system(size: 32, weight: .bold, design: .rounded))
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
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .liquidGlassCard()
    }
    
    // MARK: - Panic Mode Card
    private var panicModeCard: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                appState.isPanicMode = true
            }
            HapticManager.notification(.warning)
        } label: {
            HStack {
                Image(systemName: "bolt.fill")
                    .font(.title2)
                    .foregroundStyle(.red)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Mode Panique")
                        .font(.system(size: 16, weight: .semibold))
                    Text("5 tâches essentielles si vous êtes en retard")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.red.opacity(0.08))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.red.opacity(0.2), lineWidth: 1)
                    }
            }
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Section Picker
    private var sectionPicker: some View {
        HStack(spacing: 8) {
            ForEach(HomeSection.allCases, id: \.self) { section in
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
    
    // MARK: - Checklist Section
    private var checklistSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Progress Header
            checklistProgressHeader
            
            // Items
            let itemsToShow = appState.isPanicMode 
                ? checklistItems.filter { $0.isVital }
                : checklistItems
            
            ForEach(itemsToShow) { item in
                ChecklistItemRow(item: item)
            }
            
            if itemsToShow.isEmpty {
                emptyStateView(
                    icon: "checklist",
                    title: "Aucune tâche",
                    subtitle: "Ajoutez des tâches pour préparer votre Chabat"
                )
            }
            
            // Bouton Modifier la liste
            Button {
                showingAddItem = true
            } label: {
                HStack {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                    Text("Modifier la liste")
                        .font(.subheadline.weight(.medium))
                }
                .foregroundStyle(Color.shabGold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.shabGold.opacity(0.3), lineWidth: 1.5)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.shabGold.opacity(0.08)))
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    private var checklistProgressHeader: some View {
        let completed = checklistItems.filter { $0.isCompleted }.count
        let total = checklistItems.count
        let progress = total > 0 ? Double(completed) / Double(total) : 0
        
        return HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Progression")
                    .font(.headline)
                Text("\(completed)/\(total) tâches complétées")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            GlassProgressRing(progress: progress, lineWidth: 6, size: 60)
        }
        .padding(16)
        .liquidGlassCard(cornerRadius: 16)
    }
    
    // MARK: - Shopping Section
    private var shoppingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            GlassSectionHeader(
                title: "Liste de Courses",
                icon: "cart.fill",
                action: { showingShoppingList = true },
                actionLabel: "Voir tout"
            )
            
            // Group by category
            ForEach(ShoppingCategory.allCases, id: \.self) { category in
                let items = shoppingItems.filter { $0.category == category && !$0.isChecked }
                
                if !items.isEmpty {
                    ShoppingCategoryCard(category: category, items: items)
                }
            }
            
            if shoppingItems.isEmpty {
                emptyStateView(
                    icon: "cart",
                    title: "Liste vide",
                    subtitle: "Ajoutez des articles ou générez depuis vos recettes"
                )
            }
        }
    }
    
    // MARK: - Meal Planner Section
    private var mealPlannerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            GlassSectionHeader(
                title: "Planning des Repas",
                icon: "calendar",
                action: { showingMealPlanner = true },
                actionLabel: "Modifier"
            )
            
            ForEach(MealType.allCases, id: \.self) { mealType in
                MealPlanCard(mealType: mealType)
            }
        }
    }
    
    // MARK: - Empty State
    private func emptyStateView(icon: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .liquidGlassCard(cornerRadius: 16)
    }
    
    // MARK: - Initialize Default Items
    private func initializeDefaultItems() {
        guard checklistItems.isEmpty else { return }
        
        for (index, item) in DefaultData.checklistItems.enumerated() {
            let newItem = ChecklistItem(
                title: item.0,
                category: item.1,
                isVital: item.2,
                order: index
            )
            modelContext.insert(newItem)
        }
    }
}

// MARK: - Checklist Item Row
struct ChecklistItemRow: View {
    @Bindable var item: ChecklistItem
    
    var body: some View {
        HStack(spacing: 14) {
            // Checkbox
            Button {
                withAnimation(.spring(response: 0.3)) {
                    item.isCompleted.toggle()
                }
                HapticManager.impact(.light)
            } label: {
                ZStack {
                    Circle()
                        .stroke(item.isCompleted ? Color.shabGold : Color.secondary.opacity(0.3), lineWidth: 2)
                        .frame(width: 26, height: 26)
                    
                    if item.isCompleted {
                        Circle()
                            .fill(Color.shabGold)
                            .frame(width: 20, height: 20)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.plain)
            
            // Category Icon
            Image(systemName: item.category.icon)
                .font(.system(size: 14))
                .foregroundStyle(item.category.color)
                .frame(width: 24)
            
            // Title
            Text(item.title)
                .font(.system(size: 15))
                .strikethrough(item.isCompleted)
                .foregroundStyle(item.isCompleted ? .secondary : .primary)
            
            Spacer()
            
            // Vital Badge
            if item.isVital {
                Image(systemName: "bolt.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(item.isCompleted ? Color.shabGold.opacity(0.05) : Color(UIColor.secondarySystemBackground))
        }
    }
}

// MARK: - Shopping Category Card
struct ShoppingCategoryCard: View {
    let category: ShoppingCategory
    let items: [ShoppingItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: category.icon)
                    .foregroundStyle(category.color)
                Text(category.rawValue)
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("\(items.count)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(category.color.opacity(0.15)))
                    .foregroundStyle(category.color)
            }
            
            ForEach(items) { item in
                ShoppingItemRow(item: item)
            }
        }
        .padding(14)
        .liquidGlassCard(cornerRadius: 16)
    }
}

// MARK: - Shopping Item Row
struct ShoppingItemRow: View {
    @Bindable var item: ShoppingItem
    
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    item.isChecked.toggle()
                }
            } label: {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.isChecked ? Color.shabGold : .secondary)
            }
            .buttonStyle(.plain)
            
            Text(item.name)
                .strikethrough(item.isChecked)
                .foregroundStyle(item.isChecked ? .secondary : .primary)
            
            if !item.quantity.isEmpty {
                Text("(\(item.quantity))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Meal Plan Card
struct MealPlanCard: View {
    let mealType: MealType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: mealType.icon)
                    .foregroundStyle(Color.shabGold)
                Text(mealType.rawValue)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Button {
                    // Add recipe
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(Color.shabGold)
                }
            }
            
            // Placeholder for recipes
            Text("Glissez des recettes ici")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundStyle(.secondary.opacity(0.3))
                )
        }
        .padding(16)
        .liquidGlassCard(cornerRadius: 16)
    }
}

// MARK: - Add Item Sheet
struct AddItemSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    let section: HomeView.HomeSection
    
    @State private var title = ""
    @State private var selectedCategory: ChecklistCategory = .preparation
    @State private var selectedShoppingCategory: ShoppingCategory = .epicerie
    @State private var quantity = ""
    @State private var isVital = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nom", text: $title)
                    
                    if section == .checklist {
                        Picker("Catégorie", selection: $selectedCategory) {
                            ForEach(ChecklistCategory.allCases, id: \.self) { cat in
                                Label(cat.rawValue, systemImage: cat.icon)
                                    .tag(cat)
                            }
                        }
                        
                        Toggle("Tâche vitale (Mode Panique)", isOn: $isVital)
                    }
                    
                    if section == .shopping {
                        Picker("Catégorie", selection: $selectedShoppingCategory) {
                            ForEach(ShoppingCategory.allCases, id: \.self) { cat in
                                Label(cat.rawValue, systemImage: cat.icon)
                                    .tag(cat)
                            }
                        }
                        
                        TextField("Quantité", text: $quantity)
                    }
                }
            }
            .navigationTitle("Ajouter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        addItem()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private func addItem() {
        switch section {
        case .checklist:
            let item = ChecklistItem(
                title: title,
                category: selectedCategory,
                isVital: isVital
            )
            modelContext.insert(item)
        case .shopping:
            let item = ShoppingItem(
                name: title,
                quantity: quantity,
                category: selectedShoppingCategory
            )
            modelContext.insert(item)
        case .meals:
            break
        }
    }
}

// MARK: - Content View (sans NavigationStack pour MainTabView)
struct HomeContentView: View {
    var body: some View {
        HomeView()
            .navigationBarHidden(true)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
        .environmentObject(ZmanimService())
        .environmentObject(NotificationManager())
        .modelContainer(for: [ChecklistItem.self, ShoppingItem.self], inMemory: true)
}


