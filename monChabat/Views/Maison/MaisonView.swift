//
//  MaisonView.swift
//  monChabat
//
//  Module "Logistique & Maison"
//  Check-list, Mode Panique, Liste de courses, Meal Planner
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct MaisonView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \ChecklistItem.order) private var checklistItems: [ChecklistItem]
    @Query private var shoppingItems: [ShoppingItem]
    
    @State private var showingAddItem = false
    @State private var showingShoppingList = false
    @State private var showingMealPlanner = false
    @State private var selectedSection: MaisonSection = .checklist
    @State private var isEditMode = false
    @State private var showingAddNewItem = false
    @State private var itemToEdit: ChecklistItem?
    @State private var draggingItem: ChecklistItem?
    
    enum MaisonSection: String, CaseIterable {
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
                        // Espace pour décoller du header
                        Spacer()
                            .frame(height: 8)
                        
                        // Section Picker
                        sectionPicker
                        
                        // Panic Mode Toggle - Only show on checklist tab
                        if selectedSection == .checklist && !appState.isPanicMode {
                            panicModeCard
                        }
                        
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
                AddItemSheet(section: convertToHomeSection(selectedSection))
            }
            .onAppear {
                initializeDefaultItems()
            }
        }
    }
    
    private func convertToHomeSection(_ section: MaisonSection) -> HomeView.HomeSection {
        switch section {
        case .checklist: return .checklist
        case .shopping: return .shopping
        case .meals: return .meals
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
    
    // MARK: - Panic Mode Card
    private var panicModeCard: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                appState.isPanicMode = true
            }
        } label: {
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.red)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Mode Panique")
                        .font(.headline)
                    Text("5 tâches essentielles si vous êtes en retard")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.red.opacity(0.1))
            }
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Section Picker
    private var sectionPicker: some View {
        HStack(spacing: 8) {
            ForEach(MaisonSection.allCases, id: \.self) { section in
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
            
            // Items with drag & drop
            let itemsToShow = appState.isPanicMode 
                ? checklistItems.filter { $0.isVital }
                : checklistItems
            
            ForEach(itemsToShow.sorted { $0.order < $1.order }) { item in
                ChecklistEditableRow(
                    item: item,
                    isEditMode: isEditMode,
                    isDragging: draggingItem?.id == item.id,
                    onDelete: { deleteItem(item) },
                    onEdit: { itemToEdit = item }
                )
                .zIndex(draggingItem?.id == item.id ? 100 : 0)
                .onDrag {
                    draggingItem = item
                    return NSItemProvider(object: item.id.uuidString as NSString)
                } preview: {
                    // Preview pendant le drag
                    Text(item.title)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                }
                .onDrop(of: [.text], delegate: ChecklistDropDelegate(
                    item: item,
                    items: itemsToShow,
                    draggingItem: $draggingItem,
                    isEditMode: isEditMode
                ))
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: itemsToShow.map { $0.order })
            .onChange(of: isEditMode) { _, newValue in
                // Reset dragging state when exiting edit mode
                if !newValue {
                    draggingItem = nil
                }
            }
            
            if itemsToShow.isEmpty {
                emptyStateView(
                    icon: "checklist",
                    title: "Aucune tâche",
                    subtitle: "Ajoutez des tâches pour préparer votre Chabat"
                )
            }
            
            // Boutons d'action
            HStack(spacing: 12) {
                // Bouton Modifier/Terminer
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        isEditMode.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: isEditMode ? "checkmark.circle.fill" : "pencil.circle.fill")
                            .font(.title3)
                        Text(isEditMode ? "Terminer" : "Modifier")
                            .font(.subheadline.weight(.medium))
                    }
                    .foregroundStyle(isEditMode ? .green : Color.shabGold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isEditMode ? Color.green.opacity(0.3) : Color.shabGold.opacity(0.3), lineWidth: 1.5)
                            .background(RoundedRectangle(cornerRadius: 12).fill(isEditMode ? Color.green.opacity(0.08) : Color.shabGold.opacity(0.08)))
                    }
                }
                .buttonStyle(.plain)
                
                // Bouton Ajouter (visible en mode édition)
                if isEditMode {
                    Button {
                        showingAddNewItem = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text("Ajouter")
                                .font(.subheadline.weight(.medium))
                        }
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1.5)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.08)))
                        }
                    }
                    .buttonStyle(.plain)
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .sheet(isPresented: $showingAddNewItem) {
            EditChecklistItemSheet(modelContext: modelContext, existingCount: checklistItems.count, item: nil)
        }
        .sheet(item: $itemToEdit) { item in
            EditChecklistItemSheet(modelContext: modelContext, existingCount: checklistItems.count, item: item)
        }
    }
    
    private func deleteItem(_ item: ChecklistItem) {
        withAnimation(.spring(response: 0.3)) {
            modelContext.delete(item)
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
            
            // Bouton Modifier la liste
            Button {
                showingAddItem = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                    Text("Ajouter un article")
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
    
    // MARK: - Meal Planner Section
    private var mealPlannerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            GlassSectionHeader(
                title: "Planificateur de Repas",
                icon: "fork.knife",
                action: { showingMealPlanner = true },
                actionLabel: "Éditer"
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
                .foregroundStyle(Color.shabGold.opacity(0.5))
            
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
        
        let defaultItems: [(String, String, Bool)] = [
            ("Mettre la plata", "flame.fill", true),
            ("Préparer les hallot", "takeoutbag.and.cup.and.straw.fill", true),
            ("Régler la minuterie des lumières", "clock.badge.checkmark.fill", true),
            ("Préparer les vêtements de Chabat", "tshirt.fill", false),
            ("Nettoyer la maison", "house.and.flag.fill", false),
            ("Préparer la table", "tablecells.fill", false),
            ("Douche & préparation", "shower.fill", true),
            ("Vérifier le frigo", "refrigerator.fill", false),
            ("Préparer les bougies", "flame.fill", true),
            ("Couper le papier toilette", "scissors", false),
            ("Ranger les téléphones", "iphone.slash", false),
            ("Mettre de l'eau à chauffer", "mug.fill", false)
        ]
        
        for (index, (name, icon, isVital)) in defaultItems.enumerated() {
            let item = ChecklistItem(title: name, isVital: isVital, order: index, icon: icon)
            modelContext.insert(item)
        }
    }
}

// MARK: - Content View (sans NavigationStack pour MainTabView)
struct MaisonContentView: View {
    var body: some View {
        MaisonView()
            .navigationBarHidden(true)
    }
}

#Preview {
    MaisonView()
        .environmentObject(AppState())
        .modelContainer(for: [ChecklistItem.self, ShoppingItem.self], inMemory: true)
}

// MARK: - Drop Delegate for Drag & Drop Reordering
struct ChecklistDropDelegate: DropDelegate {
    let item: ChecklistItem
    let items: [ChecklistItem]
    @Binding var draggingItem: ChecklistItem?
    let isEditMode: Bool
    
    func performDrop(info: DropInfo) -> Bool {
        // Reset dragging state
        DispatchQueue.main.async {
            draggingItem = nil
        }
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard isEditMode,
              let draggedItem = draggingItem,
              draggedItem.id != item.id else { return }
        
        let sortedItems = items.sorted { $0.order < $1.order }
        guard let fromIndex = sortedItems.firstIndex(where: { $0.id == draggedItem.id }),
              let toIndex = sortedItems.firstIndex(where: { $0.id == item.id }),
              fromIndex != toIndex else { return }
        
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.1)) {
            // Move item and shift others
            if fromIndex < toIndex {
                // Moving down: shift items up
                for i in (fromIndex + 1)...toIndex {
                    sortedItems[i].order -= 1
                }
            } else {
                // Moving up: shift items down
                for i in toIndex..<fromIndex {
                    sortedItems[i].order += 1
                }
            }
            draggedItem.order = toIndex
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: isEditMode ? .move : .cancel)
    }
    
    func dropExited(info: DropInfo) {
        // Reset if exited without completing
    }
    
    func validateDrop(info: DropInfo) -> Bool {
        // Reset dragging if drop is cancelled
        if !isEditMode {
            DispatchQueue.main.async {
                draggingItem = nil
            }
        }
        return isEditMode
    }
}

// MARK: - Checklist Editable Row with Jiggle Effect
struct ChecklistEditableRow: View {
    @Bindable var item: ChecklistItem
    let isEditMode: Bool
    let isDragging: Bool
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    @State private var jiggleAmount: Double = 0
    @State private var jiggleDirection: Double = 1
    
    var body: some View {
        HStack(spacing: 12) {
            // Delete button (edit mode)
            if isEditMode {
                Button {
                    onDelete()
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.red)
                }
                .transition(.scale.combined(with: .opacity))
            }
            
            // Main content
            Button {
                if isEditMode {
                    onEdit()
                } else {
                    withAnimation(.spring(response: 0.3)) {
                        item.isCompleted.toggle()
                    }
                }
            } label: {
                HStack(spacing: 12) {
                    // Icon or Checkbox
                    if isEditMode {
                        Image(systemName: item.displayIcon)
                            .font(.title3)
                            .foregroundStyle(Color.shabGold)
                            .frame(width: 28, height: 28)
                    } else {
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title2)
                            .foregroundStyle(item.isCompleted ? Color.green : Color.shabGold.opacity(0.5))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.subheadline.weight(.medium))
                            .strikethrough(item.isCompleted && !isEditMode)
                            .foregroundStyle(item.isCompleted && !isEditMode ? .secondary : .primary)
                        
                        if item.isVital {
                            Text("Essentiel")
                                .font(.caption2)
                                .foregroundStyle(.red)
                        }
                    }
                    
                    Spacer()
                    
                    // Drag handle (edit mode)
                    if isEditMode {
                        Image(systemName: "line.3.horizontal")
                            .font(.body)
                            .foregroundStyle(.tertiary)
                            .padding(.trailing, 4)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.secondarySystemBackground))
                }
            }
            .buttonStyle(.plain)
            .rotationEffect(.degrees(isEditMode && !isDragging ? jiggleAmount : 0))
        }
        .opacity(isDragging ? 0.5 : 1.0)
        .scaleEffect(isDragging ? 0.95 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isDragging)
        .onChange(of: isEditMode) { _, newValue in
            if newValue {
                startJiggle()
            } else {
                withAnimation(.easeOut(duration: 0.1)) {
                    jiggleAmount = 0
                }
            }
        }
        .onAppear {
            if isEditMode {
                startJiggle()
            }
        }
    }
    
    private func startJiggle() {
        // Random initial values for natural effect
        let randomDelay = Double.random(in: 0...0.15)
        let randomAmount = Double.random(in: 0.7...1.0)
        jiggleDirection = Bool.random() ? 1 : -1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
            withAnimation(
                Animation.easeInOut(duration: 0.12)
                    .repeatForever(autoreverses: true)
            ) {
                jiggleAmount = 0.8 * randomAmount * jiggleDirection
            }
        }
    }
}

// MARK: - SF Symbols for Checklist
struct ChecklistIconPicker: View {
    @Binding var selectedIcon: String
    
    private let icons: [(String, String)] = [
        ("flame.fill", "Plata"),
        ("takeoutbag.and.cup.and.straw.fill", "Hallot"),
        ("clock.badge.checkmark.fill", "Minuterie"),
        ("tshirt.fill", "Vêtements"),
        ("house.and.flag.fill", "Ménage"),
        ("tablecells.fill", "Table"),
        ("shower.fill", "Douche"),
        ("refrigerator.fill", "Frigo"),
        ("flame.fill", "Bougies"),
        ("scissors", "Découper"),
        ("iphone.slash", "Téléphone"),
        ("mug.fill", "Boissons"),
        ("cart.fill", "Courses"),
        ("fork.knife", "Cuisine"),
        ("book.fill", "Lecture"),
        ("gift.fill", "Cadeau"),
        ("car.fill", "Voiture"),
        ("lightbulb.fill", "Lumières"),
        ("leaf.fill", "Fleurs"),
        ("heart.fill", "Important"),
        ("star.fill", "Favori"),
        ("sparkles", "Nettoyage"),
        ("person.2.fill", "Invités"),
        ("music.note", "Musique")
    ]
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 6)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Icône")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(icons, id: \.0) { icon, _ in
                    Button {
                        selectedIcon = icon
                    } label: {
                        Image(systemName: icon)
                            .font(.title3)
                            .foregroundStyle(selectedIcon == icon ? .white : Color.shabGold)
                            .frame(width: 44, height: 44)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedIcon == icon ? Color.shabGold : Color.shabGold.opacity(0.15))
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Edit/Add Checklist Item Sheet
struct EditChecklistItemSheet: View {
    @Environment(\.dismiss) private var dismiss
    let modelContext: ModelContext
    let existingCount: Int
    let item: ChecklistItem?
    
    @State private var title: String = ""
    @State private var isVital: Bool = false
    @State private var selectedIcon: String = "checklist"
    
    private var isEditing: Bool { item != nil }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Titre
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nom de la tâche")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        TextField("Ex: Préparer les hallot", text: $title)
                            .padding(12)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(UIColor.secondarySystemBackground))
                            }
                    }
                    
                    // Icon picker
                    ChecklistIconPicker(selectedIcon: $selectedIcon)
                    
                    // Toggle essentiel
                    Toggle(isOn: $isVital) {
                        HStack {
                            Image(systemName: "bolt.fill")
                                .foregroundStyle(.red)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Tâche essentielle")
                                    .font(.subheadline)
                                Text("Apparaît en Mode Panique")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(12)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.secondarySystemBackground))
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle(isEditing ? "Modifier la tâche" : "Nouvelle tâche")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Enregistrer" : "Ajouter") {
                        saveItem()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let item = item {
                    title = item.title
                    isVital = item.isVital
                    selectedIcon = item.displayIcon
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private func saveItem() {
        if let item = item {
            // Edit existing
            item.title = title.trimmingCharacters(in: .whitespaces)
            item.isVital = isVital
            item.icon = selectedIcon
        } else {
            // Add new
            let newItem = ChecklistItem(
                title: title.trimmingCharacters(in: .whitespaces),
                isVital: isVital,
                order: existingCount,
                icon: selectedIcon
            )
            modelContext.insert(newItem)
        }
        dismiss()
    }
}
