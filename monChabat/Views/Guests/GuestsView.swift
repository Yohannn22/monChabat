//
//  GuestsView.swift
//  monChabat
//
//  Module "Invités & Hospitalité"
//  Gestion des invités et Plan de table
//

import SwiftUI
import SwiftData

struct GuestsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Guest.firstName) private var guests: [Guest]
    
    @State private var selectedSection: GuestSection = .guests
    @State private var showingAddGuest = false
    @State private var selectedMealFilter: MealType? = nil
    
    enum GuestSection: String, CaseIterable {
        case guests = "Invités"
        case table = "Plan de Table"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Add person button (compact, en haut à droite)
                        addPersonButton
                            .padding(.top, 8)
                        
                        // Stats Header
                        statsHeader
                        
                        // Section Picker
                        sectionPicker
                        
                        // Content
                        switch selectedSection {
                        case .guests:
                            guestListSection
                        case .table:
                            tableSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddGuest) {
                AddGuestSheet()
            }
        }
    }
    
    // MARK: - Add Person Button
    private var addPersonButton: some View {
        HStack {
            Spacer()
            
            Button {
                showingAddGuest = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 14, weight: .medium))
                    Text("Ajouter")
                        .font(.system(size: 14, weight: .semibold))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.shabGold)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .shadow(color: Color.shabGold.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Stats Header
    private var statsHeader: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "person.2.fill",
                value: "\(guests.count)",
                label: "Personnes",
                color: .shabGold
            )
            
            StatCard(
                icon: "house.fill",
                value: "\(guests.filter { $0.isFamily }.count)",
                label: "Famille",
                color: .shabBlue
            )
            
            StatCard(
                icon: "chair.fill",
                value: "\(guests.filter { $0.tablePosition != nil }.count)",
                label: "Placés",
                color: .shabSoftPurple
            )
        }
    }
    
    // MARK: - Section Picker
    private var sectionPicker: some View {
        HStack(spacing: 8) {
            ForEach(GuestSection.allCases, id: \.self) { section in
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
    
    // MARK: - Guest List Section
    private var guestListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Meal Filter
            mealFilterPicker
            
            // Guest Cards
            let filteredGuests = filterGuests()
            
            if filteredGuests.isEmpty {
                emptyGuestState
            } else {
                ForEach(filteredGuests) { guest in
                    GuestCard(guest: guest)
                }
            }
        }
    }
    
    private var mealFilterPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "Tous",
                    isSelected: selectedMealFilter == nil
                ) {
                    selectedMealFilter = nil
                }
                
                ForEach(MealType.allCases, id: \.self) { meal in
                    FilterChip(
                        title: meal.rawValue,
                        icon: meal.icon,
                        isSelected: selectedMealFilter == meal
                    ) {
                        selectedMealFilter = meal
                    }
                }
            }
        }
    }
    
    private func filterGuests() -> [Guest] {
        guard let mealFilter = selectedMealFilter else { return guests }
        return guests.filter { $0.invitedMeals.contains(mealFilter.rawValue) }
    }
    
    private var emptyGuestState: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)
            
            Text("Aucun invité")
                .font(.headline)
            
            Text("Ajoutez vos premiers invités pour ce Chabat")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                showingAddGuest = true
            } label: {
                Label("Ajouter un invité", systemImage: "person.badge.plus")
            }
            .buttonStyle(LiquidGlassButtonStyle(isAccent: true))
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .liquidGlassCard()
    }
    
    // MARK: - Table Section
    private var tableSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            GlassSectionHeader(
                title: "Plan de Table",
                icon: "rectangle.split.3x3",
                action: nil,
                actionLabel: nil
            )
            
            // Interactive Table Planner
            TablePlannerView(guests: guests)
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .liquidGlassCard(cornerRadius: 16)
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(title)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background {
                Capsule()
                    .fill(isSelected ? Color.shabGold.opacity(0.2) : Color(UIColor.secondarySystemBackground))
            }
            .foregroundStyle(isSelected ? Color.shabGold : .primary)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Guest Card
struct GuestCard: View {
    @Bindable var guest: Guest
    @State private var showingDetail = false
    
    var body: some View {
        Button {
            showingDetail = true
        } label: {
            HStack(spacing: 14) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(guest.isFamily ? Color.shabBlue.opacity(0.2) : Color.shabGold.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Text(guest.firstName.prefix(1) + guest.lastName.prefix(1))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(guest.isFamily ? Color.shabBlue : Color.shabGold)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(guest.fullName)
                            .font(.system(size: 16, weight: .semibold))
                        
                        if guest.isFamily {
                            Image(systemName: "house.fill")
                                .font(.caption)
                                .foregroundStyle(Color.shabBlue)
                        }
                        
                        if guest.isConfirmed {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }
                    }
                    
                    HStack(spacing: 8) {
                        // Dietary info
                        if guest.dietaryRestrictions != .none {
                            Label(guest.dietaryRestrictions.rawValue, systemImage: "leaf")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(Color.parveGreen.opacity(0.15)))
                                .foregroundStyle(Color.parveGreen)
                        }
                        
                        // Kashrout level
                        if guest.kashroutLevel != .standard {
                            Text(guest.kashroutLevel.rawValue)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(Color.shabSoftPurple.opacity(0.15)))
                                .foregroundStyle(Color.shabSoftPurple)
                        }
                    }
                }
                
                Spacer()
                
                // Meals badges
                VStack(alignment: .trailing, spacing: 2) {
                    ForEach(MealType.allCases, id: \.self) { meal in
                        if guest.invitedMeals.contains(meal.rawValue) {
                            Image(systemName: meal.icon)
                                .font(.caption)
                                .foregroundStyle(Color.shabGold)
                        }
                    }
                }
            }
            .padding(14)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(UIColor.secondarySystemBackground))
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingDetail) {
            GuestDetailSheet(guest: guest)
        }
    }
}

// MARK: - Table Planner View
struct TablePlannerView: View {
    let guests: [Guest]
    @Environment(\.modelContext) private var modelContext
    
    @AppStorage("numberOfSeats") private var numberOfSeats: Int = 10
    @State private var selectedSeat: Int? = nil
    @State private var showingSeatPicker = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Nombre de places
            HStack {
                Text("Nombre de places")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Stepper("\(numberOfSeats)", value: $numberOfSeats, in: 4...20)
                    .labelsHidden()
                
                Text("\(numberOfSeats)")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .frame(width: 30)
            }
            .padding(.horizontal)
            
            // Table Representation
            ZStack {
                // Table shape
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.3))
                    .frame(width: 200, height: 120)
                    .overlay {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.5), lineWidth: 3)
                    }
                
                // Seats around table
                ForEach(0..<numberOfSeats, id: \.self) { index in
                    let position = seatPosition(index: index)
                    let guestAtSeat = guests.first { $0.tablePosition == index }
                    
                    SeatView(
                        seatNumber: index + 1,
                        guest: guestAtSeat,
                        isSelected: selectedSeat == index
                    )
                    .offset(x: position.x, y: position.y)
                    .onTapGesture {
                        if selectedSeat == index {
                            // Deselect and remove guest from seat
                            if let guest = guestAtSeat {
                                guest.tablePosition = nil
                            }
                            selectedSeat = nil
                        } else {
                            selectedSeat = index
                        }
                    }
                }
            }
            .frame(height: 280)
            
            // Unassigned guests
            if !unassignedGuests.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Invités à placer")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(unassignedGuests) { guest in
                                Button {
                                    assignGuestToSeat(guest)
                                } label: {
                                    Text(guest.firstName)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Capsule().fill(
                                            selectedSeat != nil ? Color.shabGold.opacity(0.3) : Color.shabGold.opacity(0.15)
                                        ))
                                        .foregroundStyle(Color.shabGold)
                                }
                                .disabled(selectedSeat == nil)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
            }
            
            // Instructions
            if selectedSeat != nil {
                Text("Sélectionnez un invité pour le placer au siège \(selectedSeat! + 1)")
                    .font(.caption)
                    .foregroundStyle(Color.shabGold)
            } else {
                Text("Touchez un siège pour le sélectionner, puis un invité pour le placer")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .liquidGlassCard()
    }
    
    private var unassignedGuests: [Guest] {
        return guests.filter { $0.tablePosition == nil }
    }
    
    private func assignGuestToSeat(_ guest: Guest) {
        guard let seat = selectedSeat else { return }
        
        // Remove any guest currently at this seat
        if let existingGuest = guests.first(where: { $0.tablePosition == seat }) {
            existingGuest.tablePosition = nil
        }
        
        // Assign the new guest
        guest.tablePosition = seat
        selectedSeat = nil
    }
    
    private func seatPosition(index: Int) -> CGPoint {
        let totalSeats = numberOfSeats
        
        // Disposition ovale naturelle : répartir les sièges uniformément autour de la table
        let angle = (2 * .pi / Double(totalSeats)) * Double(index) - .pi / 2
        
        // Rayons de l'ellipse (plus large que haut pour table rectangulaire)
        let radiusX: CGFloat = 130
        let radiusY: CGFloat = 90
        
        let x = CGFloat(cos(angle)) * radiusX
        let y = CGFloat(sin(angle)) * radiusY
        
        return CGPoint(x: x, y: y)
    }
}

// MARK: - Seat View
struct SeatView: View {
    let seatNumber: Int
    let guest: Guest?
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(guest != nil ? Color.shabGold.opacity(0.3) : Color(UIColor.tertiarySystemBackground))
                .frame(width: 44, height: 44)
            
            if isSelected {
                Circle()
                    .stroke(Color.shabGold, lineWidth: 3)
                    .frame(width: 50, height: 50)
            }
            
            if let guest = guest {
                Text(String(guest.firstName.prefix(1)))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.shabGold)
            } else {
                Text("\(seatNumber)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Add Guest Sheet
struct AddGuestSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var dietaryRestriction: DietaryRestriction = .none
    @State private var kashroutLevel: KashroutLevel = .standard
    @State private var selectedMeals: Set<MealType> = Set(MealType.allCases) // Tous les repas par défaut
    @State private var allergies = ""
    @State private var isFamily = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Informations") {
                    TextField("Prénom", text: $firstName)
                    TextField("Nom", text: $lastName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                    TextField("Téléphone", text: $phone)
                        .keyboardType(.phonePad)
                }
                
                Section("Type") {
                    Toggle(isOn: $isFamily) {
                        Label("Membre de la famille", systemImage: "house.fill")
                    }
                    
                    if isFamily {
                        Text("Présent automatiquement chaque Chabbat")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section("Repas") {
                    ForEach(MealType.allCases, id: \.self) { meal in
                        Toggle(isOn: Binding(
                            get: { selectedMeals.contains(meal) },
                            set: { isOn in
                                if isOn {
                                    selectedMeals.insert(meal)
                                } else {
                                    selectedMeals.remove(meal)
                                }
                            }
                        )) {
                            Label(meal.rawValue, systemImage: meal.icon)
                        }
                    }
                }
                
                Section("Régime alimentaire") {
                    Picker("Régime", selection: $dietaryRestriction) {
                        ForEach(DietaryRestriction.allCases, id: \.self) { restriction in
                            Text(restriction.rawValue).tag(restriction)
                        }
                    }
                    
                    Picker("Niveau de Cacheroute", selection: $kashroutLevel) {
                        ForEach(KashroutLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    
                    TextField("Allergies (séparées par des virgules)", text: $allergies)
                }
            }
            .navigationTitle("Nouvelle personne")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        addGuest()
                        dismiss()
                    }
                    .disabled(firstName.isEmpty)
                }
            }
        }
    }
    
    private func addGuest() {
        let guest = Guest(
            firstName: firstName,
            lastName: lastName,
            email: email.isEmpty ? nil : email,
            phone: phone.isEmpty ? nil : phone,
            dietaryRestrictions: dietaryRestriction,
            kashroutLevel: kashroutLevel
        )
        guest.invitedMeals = selectedMeals.map { $0.rawValue }
        guest.allergies = allergies.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        guest.isFamily = isFamily
        guest.isConfirmed = isFamily // Famille auto-confirmée
        
        modelContext.insert(guest)
    }
}

// MARK: - Guest Detail Sheet (Éditable)
struct GuestDetailSheet: View {
    @Bindable var guest: Guest
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var showingDeleteConfirmation = false
    @State private var allergiesText: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                // Avatar Section
                Section {
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(guest.isFamily ? Color.shabBlue.opacity(0.2) : Color.shabGold.opacity(0.2))
                                .frame(width: 80, height: 80)
                            
                            Text(guest.firstName.prefix(1) + guest.lastName.prefix(1))
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(guest.isFamily ? Color.shabBlue : Color.shabGold)
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
                
                // Informations
                Section("Informations") {
                    TextField("Prénom", text: $guest.firstName)
                    TextField("Nom", text: $guest.lastName)
                    TextField("Email", text: Binding(
                        get: { guest.email ?? "" },
                        set: { guest.email = $0.isEmpty ? nil : $0 }
                    ))
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    
                    TextField("Téléphone", text: Binding(
                        get: { guest.phone ?? "" },
                        set: { guest.phone = $0.isEmpty ? nil : $0 }
                    ))
                    .keyboardType(.phonePad)
                }
                
                // Type (Famille ou Invité)
                Section("Type") {
                    Toggle(isOn: $guest.isFamily) {
                        Label("Membre de la famille", systemImage: "house.fill")
                    }
                    
                    if guest.isFamily {
                        Text("Présent automatiquement chaque Chabbat")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Toggle("Présence confirmée", isOn: $guest.isConfirmed)
                }
                
                // Repas
                Section("Repas") {
                    ForEach(MealType.allCases, id: \.self) { meal in
                        Toggle(isOn: Binding(
                            get: { guest.invitedMeals.contains(meal.rawValue) },
                            set: { isOn in
                                if isOn {
                                    if !guest.invitedMeals.contains(meal.rawValue) {
                                        guest.invitedMeals.append(meal.rawValue)
                                    }
                                } else {
                                    guest.invitedMeals.removeAll { $0 == meal.rawValue }
                                }
                            }
                        )) {
                            Label(meal.rawValue, systemImage: meal.icon)
                        }
                    }
                }
                
                // Régime alimentaire
                Section("Régime alimentaire") {
                    Picker("Régime", selection: $guest.dietaryRestrictions) {
                        ForEach(DietaryRestriction.allCases, id: \.self) { restriction in
                            Text(restriction.rawValue).tag(restriction)
                        }
                    }
                    
                    Picker("Niveau de Cacheroute", selection: $guest.kashroutLevel) {
                        ForEach(KashroutLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    
                    TextField("Allergies (séparées par virgules)", text: $allergiesText)
                        .onChange(of: allergiesText) { _, newValue in
                            guest.allergies = newValue.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
                        }
                }
                
                // Notes
                Section("Notes") {
                    TextField("Notes", text: Binding(
                        get: { guest.notes ?? "" },
                        set: { guest.notes = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .lineLimit(3...6)
                }
                
                // Suppression
                Section {
                    Button(role: .destructive) {
                        showingDeleteConfirmation = true
                    } label: {
                        HStack {
                            Spacer()
                            Label("Supprimer cette personne", systemImage: "trash")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(guest.firstName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("OK") { dismiss() }
                }
            }
            .onAppear {
                allergiesText = guest.allergies.joined(separator: ", ")
            }
            .confirmationDialog(
                "Supprimer \(guest.fullName) ?",
                isPresented: $showingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Supprimer", role: .destructive) {
                    deleteGuest()
                }
                Button("Annuler", role: .cancel) {}
            } message: {
                Text("Cette action est irréversible.")
            }
        }
    }
    
    private func deleteGuest() {
        modelContext.delete(guest)
        dismiss()
    }
}

// MARK: - Content View (sans NavigationStack pour MainTabView)
struct GuestsContentView: View {
    var body: some View {
        GuestsView()
            .navigationBarHidden(true)
    }
}

#Preview {
    GuestsView()
        .environmentObject(AppState())
        .modelContainer(for: [Guest.self], inMemory: true)
}
