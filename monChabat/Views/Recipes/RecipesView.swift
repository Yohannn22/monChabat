//
//  RecipesView.swift
//  monChabat
//
//  Module "Recettes & Tradition"
//  Base de données de recettes, Timer Halla, Convertisseur de quantités
//

import SwiftUI
import SwiftData

struct RecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appState: AppState
    @Query(sort: \Recipe.name) private var recipes: [Recipe]
    
    @State private var searchText = ""
    @State private var selectedCategory: RecipeCategory? = nil
    @State private var selectedKashrout: KashroutType? = nil
    @State private var showFavoritesOnly = false
    @State private var showingAddRecipe = false
    @State private var showingHallaTimer = false
    @FocusState private var isSearchFocused: Bool
    
    var filteredRecipes: [Recipe] {
        var result = recipes
        
        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        if let kashrout = selectedKashrout {
            result = result.filter { $0.kashroutType == kashrout }
        }
        
        return result
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Espace pour décoller du header
                        Spacer()
                            .frame(height: 8)
                        
                        // Search Bar with integrated actions
                        headerSection
                        
                        // Category Chips
                        categoryChips
                        
                        // Kashrout Filter
                        kashroutFilter
                        
                        // Recipes count
                        recipesCountView
                        
                        // Recipes Grid
                        recipesGrid
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
                .onTapGesture {
                    isSearchFocused = false
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddRecipe) {
                AddRecipeSheet()
            }
            .sheet(isPresented: $showingHallaTimer) {
                HallaTimerSheet()
            }
            .onAppear {
                initializeDefaultRecipes()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Rechercher une recette", text: $searchText)
                        .focused($isSearchFocused)
                }
                .padding(12)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Add Recipe Button
                Button {
                    showingAddRecipe = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.shabGold)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            
            // Timer Halla - Compact button
            Button {
                showingHallaTimer = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "timer")
                        .font(.subheadline)
                        .foregroundStyle(Color.shabGold)
                    Text("Timer Halla")
                        .font(.subheadline.weight(.medium))
                    
                    Spacer()
                    
                    Text("Levée & Hafrachat Halla")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.shabGold.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Recipes Count View
    private var recipesCountView: some View {
        HStack {
            if selectedCategory != nil || selectedKashrout != nil {
                Button {
                    withAnimation {
                        selectedCategory = nil
                        selectedKashrout = nil
                    }
                } label: {
                    Label("Réinitialiser", systemImage: "xmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Text("\(filteredRecipes.count) recette\(filteredRecipes.count > 1 ? "s" : "")")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Category Chips
    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryChip(
                    title: "Toutes",
                    icon: nil,
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                ForEach(RecipeCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
    
    // MARK: - Kashrout Filter
    private var kashroutFilter: some View {
        HStack(spacing: 10) {
            // Bouton Favoris
            Button {
                withAnimation {
                    showFavoritesOnly.toggle()
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                        .font(.caption)
                    Text("Favoris")
                        .font(.caption)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(showFavoritesOnly ? Color.red.opacity(0.2) : Color(UIColor.secondarySystemBackground))
                }
                .foregroundStyle(showFavoritesOnly ? .red : .primary)
            }
            .buttonStyle(.plain)
            
            ForEach(KashroutType.allCases, id: \.self) { type in
                Button {
                    withAnimation {
                        if selectedKashrout == type {
                            selectedKashrout = nil
                        } else {
                            selectedKashrout = type
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(type.color)
                            .frame(width: 8, height: 8)
                        Text(type.rawValue)
                            .font(.caption)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background {
                        Capsule()
                            .fill(selectedKashrout == type ? type.color.opacity(0.2) : Color(UIColor.secondarySystemBackground))
                    }
                    .foregroundStyle(selectedKashrout == type ? type.color : .primary)
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Recipes Grid
    private var recipesGrid: some View {
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
        
        return LazyVGrid(columns: columns, spacing: 16) {
            ForEach(filteredRecipes) { recipe in
                NavigationLink {
                    RecipeDetailView(recipe: recipe)
                } label: {
                    RecipeCard(recipe: recipe)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Initialize Default Recipes
    private func initializeDefaultRecipes() {
        // Version des recettes - incrémenter pour forcer la mise à jour
        let currentRecipeVersion = 6
        let savedVersion = UserDefaults.standard.integer(forKey: "defaultRecipesVersion")
        
        guard recipes.isEmpty || savedVersion < currentRecipeVersion else { return }
        
        // Supprimer les anciennes recettes par défaut si mise à jour
        if savedVersion < currentRecipeVersion && !recipes.isEmpty {
            for recipe in recipes {
                modelContext.delete(recipe)
            }
        }
        
        UserDefaults.standard.set(currentRecipeVersion, forKey: "defaultRecipesVersion")
        
        // Dafina
        let dafina = Recipe(
            name: "Dafina Marocaine",
            description: "Le plat traditionnel du Chabat marocain, mijoté toute la nuit sur la plata",
            category: .plat,
            kashroutType: .viande,
            prepTime: 45,
            cookTime: 720,
            servings: 4
        )
        dafina.ingredients = [
            Ingredient(name: "Viande de bœuf", quantity: 1, unit: "kg"),
            Ingredient(name: "Pois chiches", quantity: 400, unit: "g"),
            Ingredient(name: "Pommes de terre", quantity: 6, unit: "pièces"),
            Ingredient(name: "Œufs", quantity: 6, unit: "pièces"),
            Ingredient(name: "Riz", quantity: 300, unit: "g"),
            Ingredient(name: "Blé", quantity: 200, unit: "g"),
            Ingredient(name: "Oignons", quantity: 2, unit: "pièces"),
            Ingredient(name: "Huile", quantity: 4, unit: "c. à soupe"),
            Ingredient(name: "Paprika", quantity: 2, unit: "c. à café"),
            Ingredient(name: "Cumin", quantity: 1, unit: "c. à café")
        ]
        dafina.instructions = [
            "Faire tremper les pois chiches et le blé la veille",
            "Faire revenir la viande avec les oignons et les épices",
            "Disposer tous les ingrédients dans une grande marmite",
            "Ajouter les œufs entiers avec leur coquille",
            "Couvrir d'eau et porter à ébullition",
            "Réduire le feu et laisser mijoter sur la plata toute la nuit"
        ]
        
        // Cholent
        let cholent = Recipe(
            name: "Cholent Ashkénaze",
            description: "Ragoût traditionnel ashkénaze avec haricots, orge et viande",
            category: .plat,
            kashroutType: .viande,
            prepTime: 30,
            cookTime: 600,
            servings: 4
        )
        cholent.ingredients = [
            Ingredient(name: "Viande de bœuf", quantity: 800, unit: "g"),
            Ingredient(name: "Haricots blancs", quantity: 400, unit: "g"),
            Ingredient(name: "Orge perlé", quantity: 200, unit: "g"),
            Ingredient(name: "Pommes de terre", quantity: 6, unit: "pièces"),
            Ingredient(name: "Oignons", quantity: 2, unit: "pièces"),
            Ingredient(name: "Kishke (facultatif)", quantity: 1, unit: "pièce"),
            Ingredient(name: "Paprika", quantity: 2, unit: "c. à café"),
            Ingredient(name: "Miel", quantity: 2, unit: "c. à soupe")
        ]
        cholent.instructions = [
            "Faire tremper les haricots la veille",
            "Disposer les oignons au fond de la marmite",
            "Ajouter la viande, les haricots et l'orge",
            "Disposer les pommes de terre sur le dessus",
            "Assaisonner et ajouter le miel",
            "Couvrir d'eau et cuire sur la plata toute la nuit"
        ]
        
        // Hallot
        let hallot = Recipe(
            name: "Hallot Tressées",
            description: "Pains tressés traditionnels pour le Chabat",
            category: .pain,
            kashroutType: .parve,
            prepTime: 30,
            cookTime: 35,
            servings: 4
        )
        hallot.ingredients = [
            Ingredient(name: "Farine", quantity: 1, unit: "kg"),
            Ingredient(name: "Eau tiède", quantity: 400, unit: "ml"),
            Ingredient(name: "Levure sèche", quantity: 11, unit: "g"),
            Ingredient(name: "Sucre", quantity: 100, unit: "g"),
            Ingredient(name: "Huile", quantity: 100, unit: "ml"),
            Ingredient(name: "Œufs", quantity: 3, unit: "pièces"),
            Ingredient(name: "Sel", quantity: 2, unit: "c. à café"),
            Ingredient(name: "Jaune d'œuf (dorure)", quantity: 1, unit: "pièce"),
            Ingredient(name: "Graines de sésame", quantity: 2, unit: "c. à soupe")
        ]
        hallot.instructions = [
            "Dissoudre la levure dans l'eau tiède avec 1 c. à café de sucre",
            "Mélanger la farine, le sel et le reste du sucre",
            "Ajouter les œufs, l'huile et le mélange de levure",
            "Pétrir jusqu'à obtenir une pâte lisse",
            "Laisser lever 1h30 dans un endroit tiède",
            "Dégazer et diviser en 6 boules, former des boudins",
            "Tresser 3 boudins ensemble pour chaque halla",
            "Laisser lever 30 minutes",
            "Badigeonner de jaune d'œuf et parsemer de graines",
            "Cuire à 180°C pendant 30-35 minutes"
        ]
        
        // Pkaila
        let pkaila = Recipe(
            name: "Pkaila Tunisienne",
            description: "Plat tunisien traditionnel aux épinards et haricots blancs",
            category: .plat,
            kashroutType: .viande,
            prepTime: 40,
            cookTime: 180,
            servings: 4
        )
        pkaila.ingredients = [
            Ingredient(name: "Épinards frais", quantity: 1, unit: "kg"),
            Ingredient(name: "Haricots blancs secs", quantity: 300, unit: "g"),
            Ingredient(name: "Viande de bœuf", quantity: 500, unit: "g"),
            Ingredient(name: "Huile d'olive", quantity: 100, unit: "ml"),
            Ingredient(name: "Ail", quantity: 6, unit: "gousses"),
            Ingredient(name: "Harissa", quantity: 2, unit: "c. à café")
        ]
        
        dafina.imageURL = "dafina"
        cholent.imageURL = "cholent"
        hallot.imageURL = "hallot"
        pkaila.imageURL = "pkaila"
        
        modelContext.insert(dafina)
        modelContext.insert(cholent)
        modelContext.insert(hallot)
        modelContext.insert(pkaila)
        
        // ========================================
        // ENTRÉES FROIDES - Salades Cuites
        // ========================================
        
        let matboucha = Recipe(
            name: "Matboucha",
            description: "Salade cuite de tomates et poivrons à la marocaine",
            category: .entree,
            kashroutType: .parve,
            prepTime: 20,
            cookTime: 60,
            servings: 4
        )
        matboucha.ingredients = [
            Ingredient(name: "Tomates", quantity: 1, unit: "kg"),
            Ingredient(name: "Poivrons rouges", quantity: 4, unit: "pièces"),
            Ingredient(name: "Ail", quantity: 4, unit: "gousses"),
            Ingredient(name: "Huile d'olive", quantity: 80, unit: "ml"),
            Ingredient(name: "Paprika doux", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Piment (facultatif)", quantity: 1, unit: "pièce"),
            Ingredient(name: "Sucre", quantity: 1, unit: "c. à café")
        ]
        matboucha.instructions = [
            "Griller les poivrons au four jusqu'à ce que la peau noircisse",
            "Peler les poivrons et les couper en lanières",
            "Éplucher et concasser les tomates",
            "Faire revenir l'ail dans l'huile d'olive",
            "Ajouter les tomates et cuire 30 min à feu doux",
            "Ajouter les poivrons, paprika et sucre",
            "Laisser mijoter jusqu'à évaporation de l'eau",
            "Servir froid avec du pain"
        ]
        matboucha.imageURL = "matboucha"
        modelContext.insert(matboucha)
        
        let zaalouk = Recipe(
            name: "Zaalouk",
            description: "Caviar d'aubergines à la marocaine",
            category: .entree,
            kashroutType: .parve,
            prepTime: 15,
            cookTime: 45,
            servings: 4
        )
        zaalouk.ingredients = [
            Ingredient(name: "Aubergines", quantity: 3, unit: "pièces"),
            Ingredient(name: "Tomates", quantity: 4, unit: "pièces"),
            Ingredient(name: "Ail", quantity: 4, unit: "gousses"),
            Ingredient(name: "Huile d'olive", quantity: 60, unit: "ml"),
            Ingredient(name: "Paprika", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Cumin", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Persil frais", quantity: 1, unit: "bouquet"),
            Ingredient(name: "Coriandre fraîche", quantity: 1, unit: "bouquet")
        ]
        zaalouk.instructions = [
            "Griller les aubergines au four ou à la flamme",
            "Éplucher et écraser la chair à la fourchette",
            "Éplucher et concasser les tomates",
            "Faire revenir l'ail dans l'huile",
            "Ajouter les tomates et cuire 15 min",
            "Incorporer les aubergines et les épices",
            "Cuire 20 min en écrasant régulièrement",
            "Ajouter les herbes hachées et servir froid"
        ]
        zaalouk.imageURL = "zaalouk"
        modelContext.insert(zaalouk)
        
        let mechouia = Recipe(
            name: "Mechouia",
            description: "Salade de poivrons grillés tunisienne",
            category: .entree,
            kashroutType: .parve,
            prepTime: 15,
            cookTime: 30,
            servings: 4
        )
        mechouia.ingredients = [
            Ingredient(name: "Poivrons rouges", quantity: 3, unit: "pièces"),
            Ingredient(name: "Poivrons verts", quantity: 2, unit: "pièces"),
            Ingredient(name: "Tomates", quantity: 3, unit: "pièces"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Ail", quantity: 2, unit: "gousses"),
            Ingredient(name: "Huile d'olive", quantity: 60, unit: "ml"),
            Ingredient(name: "Carvi", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Harissa", quantity: 1, unit: "c. à café")
        ]
        mechouia.instructions = [
            "Griller tous les légumes au four à 220°C",
            "Retirer la peau des poivrons et tomates",
            "Hacher finement tous les légumes",
            "Ajouter l'ail écrasé et les épices",
            "Arroser d'huile d'olive",
            "Bien mélanger et réfrigérer avant de servir"
        ]
        mechouia.imageURL = "salade-mechouia"
        modelContext.insert(mechouia)
        
        let saladeCarottes = Recipe(
            name: "Salade de Carottes au Cumin",
            description: "Carottes cuites à la marocaine avec ail et harissa",
            category: .entree,
            kashroutType: .parve,
            prepTime: 10,
            cookTime: 20,
            servings: 4
        )
        saladeCarottes.ingredients = [
            Ingredient(name: "Carottes", quantity: 800, unit: "g"),
            Ingredient(name: "Ail", quantity: 3, unit: "gousses"),
            Ingredient(name: "Huile d'olive", quantity: 50, unit: "ml"),
            Ingredient(name: "Cumin", quantity: 2, unit: "c. à café"),
            Ingredient(name: "Paprika", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Harissa", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Vinaigre", quantity: 2, unit: "c. à soupe"),
            Ingredient(name: "Persil", quantity: 1, unit: "bouquet")
        ]
        saladeCarottes.instructions = [
            "Éplucher et couper les carottes en rondelles",
            "Cuire à l'eau salée jusqu'à tendreté",
            "Égoutter et réserver",
            "Faire revenir l'ail dans l'huile",
            "Ajouter les épices et mélanger",
            "Verser sur les carottes chaudes",
            "Ajouter le vinaigre et le persil",
            "Servir tiède ou froid"
        ]
        saladeCarottes.imageURL = "salade-carottes"
        modelContext.insert(saladeCarottes)
        
        let babaGanoush = Recipe(
            name: "Baba Ganoush",
            description: "Aubergines brûlées et tehina",
            category: .entree,
            kashroutType: .parve,
            prepTime: 15,
            cookTime: 40,
            servings: 4
        )
        babaGanoush.ingredients = [
            Ingredient(name: "Aubergines", quantity: 3, unit: "pièces"),
            Ingredient(name: "Tehina", quantity: 100, unit: "g"),
            Ingredient(name: "Citron", quantity: 1, unit: "pièce"),
            Ingredient(name: "Ail", quantity: 2, unit: "gousses"),
            Ingredient(name: "Huile d'olive", quantity: 30, unit: "ml"),
            Ingredient(name: "Persil", quantity: 1, unit: "bouquet")
        ]
        babaGanoush.instructions = [
            "Piquer les aubergines à la fourchette",
            "Griller sur flamme directe ou au four jusqu'à carbonisation",
            "Laisser refroidir et retirer la peau",
            "Écraser la chair à la fourchette",
            "Mélanger avec la tehina, le jus de citron et l'ail",
            "Arroser d'huile d'olive et parsemer de persil"
        ]
        babaGanoush.imageURL = "baba-ganoush"
        modelContext.insert(babaGanoush)
        
        let saladeBetteraves = Recipe(
            name: "Salade de Betteraves au Cumin",
            description: "Betteraves cuites assaisonnées au cumin",
            category: .entree,
            kashroutType: .parve,
            prepTime: 10,
            cookTime: 60,
            servings: 4
        )
        saladeBetteraves.ingredients = [
            Ingredient(name: "Betteraves", quantity: 4, unit: "pièces"),
            Ingredient(name: "Cumin", quantity: 2, unit: "c. à café"),
            Ingredient(name: "Huile d'olive", quantity: 40, unit: "ml"),
            Ingredient(name: "Vinaigre de vin", quantity: 2, unit: "c. à soupe"),
            Ingredient(name: "Coriandre fraîche", quantity: 1, unit: "bouquet")
        ]
        saladeBetteraves.instructions = [
            "Cuire les betteraves à l'eau ou au four avec leur peau",
            "Peler et couper en cubes",
            "Assaisonner avec cumin, huile et vinaigre",
            "Parsemer de coriandre ciselée",
            "Servir froid"
        ]
        saladeBetteraves.imageURL = "salade-betteraves"
        modelContext.insert(saladeBetteraves)
        
        // ========================================
        // ENTRÉES FROIDES - Fraîcheurs & Classiques
        // ========================================
        
        let saladeOeufs = Recipe(
            name: "Salade d'Œufs aux Oignons",
            description: "Classique ashkénaze pour le Chabat",
            category: .entree,
            kashroutType: .parve,
            prepTime: 15,
            cookTime: 12,
            servings: 4
        )
        saladeOeufs.ingredients = [
            Ingredient(name: "Œufs", quantity: 8, unit: "pièces"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Mayonnaise", quantity: 100, unit: "g"),
            Ingredient(name: "Moutarde", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Sel et poivre", quantity: 1, unit: "pincée")
        ]
        saladeOeufs.instructions = [
            "Cuire les œufs durs 10-12 minutes",
            "Refroidir et écaler",
            "Émincer finement l'oignon",
            "Écraser les œufs à la fourchette",
            "Mélanger avec mayonnaise, moutarde et oignon",
            "Assaisonner et réfrigérer"
        ]
        saladeOeufs.imageURL = "salade-oeufs"
        modelContext.insert(saladeOeufs)
        
        let saladePDT = Recipe(
            name: "Salade de Pommes de Terre",
            description: "Salade crémeuse à la mayonnaise et aneth",
            category: .entree,
            kashroutType: .parve,
            prepTime: 15,
            cookTime: 25,
            servings: 4
        )
        saladePDT.ingredients = [
            Ingredient(name: "Pommes de terre", quantity: 1, unit: "kg"),
            Ingredient(name: "Mayonnaise", quantity: 150, unit: "g"),
            Ingredient(name: "Oignon rouge", quantity: 1, unit: "pièce"),
            Ingredient(name: "Aneth frais", quantity: 1, unit: "bouquet"),
            Ingredient(name: "Cornichons", quantity: 4, unit: "pièces"),
            Ingredient(name: "Moutarde", quantity: 1, unit: "c. à soupe")
        ]
        saladePDT.instructions = [
            "Cuire les pommes de terre à l'eau salée",
            "Laisser refroidir et couper en cubes",
            "Émincer l'oignon et les cornichons",
            "Mélanger mayonnaise et moutarde",
            "Incorporer tous les ingrédients",
            "Parsemer d'aneth et réfrigérer 2h"
        ]
        saladePDT.imageURL = "salade-pdt"
        modelContext.insert(saladePDT)
        
        let coleslaw = Recipe(
            name: "Coleslaw",
            description: "Salade de chou blanc crémeuse",
            category: .entree,
            kashroutType: .parve,
            prepTime: 15,
            cookTime: 0,
            servings: 4
        )
        coleslaw.ingredients = [
            Ingredient(name: "Chou blanc", quantity: 500, unit: "g"),
            Ingredient(name: "Carottes", quantity: 2, unit: "pièces"),
            Ingredient(name: "Mayonnaise", quantity: 150, unit: "g"),
            Ingredient(name: "Vinaigre de cidre", quantity: 2, unit: "c. à soupe"),
            Ingredient(name: "Sucre", quantity: 1, unit: "c. à soupe")
        ]
        coleslaw.instructions = [
            "Émincer finement le chou",
            "Râper les carottes",
            "Mélanger mayonnaise, vinaigre et sucre",
            "Incorporer les légumes à la sauce",
            "Réfrigérer au moins 1h avant de servir"
        ]
        coleslaw.imageURL = "coleslaw"
        modelContext.insert(coleslaw)
        
        let taboule = Recipe(
            name: "Taboulé Oriental",
            description: "Salade de semoule aux légumes frais",
            category: .entree,
            kashroutType: .parve,
            prepTime: 20,
            cookTime: 0,
            servings: 4
        )
        taboule.ingredients = [
            Ingredient(name: "Semoule fine", quantity: 250, unit: "g"),
            Ingredient(name: "Tomates", quantity: 4, unit: "pièces"),
            Ingredient(name: "Concombre", quantity: 1, unit: "pièce"),
            Ingredient(name: "Oignons verts", quantity: 4, unit: "pièces"),
            Ingredient(name: "Menthe fraîche", quantity: 1, unit: "bouquet"),
            Ingredient(name: "Persil", quantity: 2, unit: "bouquets"),
            Ingredient(name: "Huile d'olive", quantity: 80, unit: "ml"),
            Ingredient(name: "Citron", quantity: 2, unit: "pièces")
        ]
        taboule.instructions = [
            "Verser de l'eau bouillante sur la semoule et couvrir 5 min",
            "Égrener à la fourchette et laisser refroidir",
            "Couper les légumes en petits dés",
            "Hacher finement les herbes",
            "Mélanger tous les ingrédients",
            "Assaisonner avec huile, citron, sel et poivre",
            "Réfrigérer au moins 1h"
        ]
        taboule.imageURL = "taboule"
        modelContext.insert(taboule)
        
        let foieHache = Recipe(
            name: "Foie Haché (Chopped Liver)",
            description: "Pâté de foie de volaille ashkénaze",
            category: .entree,
            kashroutType: .viande,
            prepTime: 20,
            cookTime: 15,
            servings: 4
        )
        foieHache.ingredients = [
            Ingredient(name: "Foies de volaille", quantity: 500, unit: "g"),
            Ingredient(name: "Oignons", quantity: 3, unit: "pièces"),
            Ingredient(name: "Œufs durs", quantity: 3, unit: "pièces"),
            Ingredient(name: "Huile ou schmaltz", quantity: 60, unit: "ml"),
            Ingredient(name: "Sel et poivre", quantity: 1, unit: "pincée")
        ]
        foieHache.instructions = [
            "Griller les foies kashérisés à la flamme ou au four",
            "Faire revenir les oignons dans l'huile jusqu'à caramélisation",
            "Hacher finement les foies, oignons et œufs durs",
            "Mélanger le tout avec un peu d'huile de cuisson",
            "Assaisonner et servir avec du pain"
        ]
        foieHache.imageURL = "foie-hache"
        modelContext.insert(foieHache)
        
        let hummus = Recipe(
            name: "Hummus Maison",
            description: "Purée de pois chiches crémeuse",
            category: .entree,
            kashroutType: .parve,
            prepTime: 15,
            cookTime: 90,
            servings: 4
        )
        hummus.ingredients = [
            Ingredient(name: "Pois chiches secs", quantity: 250, unit: "g"),
            Ingredient(name: "Tehina", quantity: 100, unit: "g"),
            Ingredient(name: "Citron", quantity: 2, unit: "pièces"),
            Ingredient(name: "Ail", quantity: 2, unit: "gousses"),
            Ingredient(name: "Cumin", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Huile d'olive", quantity: 50, unit: "ml"),
            Ingredient(name: "Paprika", quantity: 1, unit: "c. à café")
        ]
        hummus.instructions = [
            "Faire tremper les pois chiches toute la nuit",
            "Cuire jusqu'à très tendres (1h30 environ)",
            "Mixer avec tehina, ail, citron et cumin",
            "Ajouter de l'eau de cuisson pour la consistance",
            "Servir avec huile d'olive et paprika"
        ]
        hummus.imageURL = "hummus"
        modelContext.insert(hummus)
        
        let tehina = Recipe(
            name: "Tehina",
            description: "Sauce au sésame crémeuse",
            category: .entree,
            kashroutType: .parve,
            prepTime: 5,
            cookTime: 0,
            servings: 4
        )
        tehina.ingredients = [
            Ingredient(name: "Pâte de sésame (tahini)", quantity: 200, unit: "g"),
            Ingredient(name: "Citron", quantity: 2, unit: "pièces"),
            Ingredient(name: "Ail", quantity: 1, unit: "gousse"),
            Ingredient(name: "Eau froide", quantity: 100, unit: "ml"),
            Ingredient(name: "Persil", quantity: 1, unit: "bouquet")
        ]
        tehina.instructions = [
            "Mélanger la pâte de sésame avec le jus de citron",
            "Ajouter l'ail écrasé",
            "Incorporer l'eau petit à petit jusqu'à consistance crémeuse",
            "Saler et parsemer de persil"
        ]
        tehina.imageURL = "tehina"
        modelContext.insert(tehina)
        
        // ========================================
        // ENTRÉES CHAUDES - Feuilletés & Fritures
        // ========================================
        
        let bourekas = Recipe(
            name: "Bourekas",
            description: "Feuilletés traditionnels aux pommes de terre",
            category: .entree,
            kashroutType: .parve,
            prepTime: 40,
            cookTime: 25,
            servings: 4
        )
        bourekas.ingredients = [
            Ingredient(name: "Pâte feuilletée", quantity: 500, unit: "g"),
            Ingredient(name: "Pommes de terre", quantity: 500, unit: "g"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Huile", quantity: 30, unit: "ml"),
            Ingredient(name: "Œuf (dorure)", quantity: 1, unit: "pièce"),
            Ingredient(name: "Graines de sésame", quantity: 2, unit: "c. à soupe")
        ]
        bourekas.instructions = [
            "Cuire et écraser les pommes de terre en purée",
            "Faire revenir l'oignon émincé",
            "Mélanger avec la purée, saler et poivrer",
            "Découper des cercles de pâte feuilletée",
            "Garnir et refermer en demi-lune",
            "Badigeonner d'œuf et parsemer de sésame",
            "Cuire à 180°C pendant 25 minutes"
        ]
        bourekas.imageURL = "bourekas"
        modelContext.insert(bourekas)
        
        let cigares = Recipe(
            name: "Cigares à la Viande",
            description: "Cigares marocains croustillants",
            category: .entree,
            kashroutType: .viande,
            prepTime: 45,
            cookTime: 15,
            servings: 4
        )
        cigares.ingredients = [
            Ingredient(name: "Feuilles de brick", quantity: 10, unit: "pièces"),
            Ingredient(name: "Viande hachée", quantity: 400, unit: "g"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Persil", quantity: 1, unit: "bouquet"),
            Ingredient(name: "Coriandre", quantity: 1, unit: "bouquet"),
            Ingredient(name: "Cumin", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Huile pour friture", quantity: 500, unit: "ml")
        ]
        cigares.instructions = [
            "Faire revenir la viande avec l'oignon haché",
            "Ajouter les épices et les herbes ciselées",
            "Laisser refroidir la farce",
            "Couper les feuilles de brick en deux",
            "Garnir et rouler en forme de cigares",
            "Frire dans l'huile chaude jusqu'à dorure"
        ]
        cigares.imageURL = "cigares"
        modelContext.insert(cigares)
        
        let pastels = Recipe(
            name: "Pastels",
            description: "Petits chaussons frits à la pomme de terre",
            category: .entree,
            kashroutType: .parve,
            prepTime: 50,
            cookTime: 20,
            servings: 4
        )
        pastels.ingredients = [
            Ingredient(name: "Farine", quantity: 400, unit: "g"),
            Ingredient(name: "Eau tiède", quantity: 200, unit: "ml"),
            Ingredient(name: "Huile", quantity: 50, unit: "ml"),
            Ingredient(name: "Pommes de terre", quantity: 500, unit: "g"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Huile pour friture", quantity: 500, unit: "ml")
        ]
        pastels.instructions = [
            "Préparer la pâte avec farine, eau et huile",
            "Laisser reposer 30 min",
            "Préparer une purée avec pommes de terre et oignon",
            "Étaler la pâte finement et découper des cercles",
            "Garnir et refermer en chausson",
            "Frire dans l'huile chaude"
        ]
        pastels.imageURL = "pastels"
        modelContext.insert(pastels)
        
        let briks = Recipe(
            name: "Briks à l'Œuf",
            description: "Feuilletés tunisiens croustillants",
            category: .entree,
            kashroutType: .parve,
            prepTime: 15,
            cookTime: 10,
            servings: 4
        )
        briks.ingredients = [
            Ingredient(name: "Feuilles de brick", quantity: 6, unit: "pièces"),
            Ingredient(name: "Œufs", quantity: 6, unit: "pièces"),
            Ingredient(name: "Thon (facultatif)", quantity: 150, unit: "g"),
            Ingredient(name: "Persil", quantity: 1, unit: "bouquet"),
            Ingredient(name: "Câpres", quantity: 2, unit: "c. à soupe"),
            Ingredient(name: "Huile pour friture", quantity: 300, unit: "ml")
        ]
        briks.instructions = [
            "Poser une feuille de brick à plat",
            "Ajouter le thon émietté et le persil",
            "Casser un œuf au centre",
            "Replier en triangle rapidement",
            "Frire immédiatement dans l'huile chaude",
            "L'œuf doit rester coulant à l'intérieur"
        ]
        briks.imageURL = "briks"
        modelContext.insert(briks)
        
        let banatages = Recipe(
            name: "Banatages",
            description: "Boulettes de pomme de terre farcies à la viande",
            category: .entree,
            kashroutType: .viande,
            prepTime: 60,
            cookTime: 20,
            servings: 4
        )
        banatages.ingredients = [
            Ingredient(name: "Pommes de terre", quantity: 1, unit: "kg"),
            Ingredient(name: "Viande hachée", quantity: 300, unit: "g"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Œufs", quantity: 2, unit: "pièces"),
            Ingredient(name: "Farine", quantity: 100, unit: "g"),
            Ingredient(name: "Chapelure", quantity: 150, unit: "g"),
            Ingredient(name: "Huile pour friture", quantity: 500, unit: "ml")
        ]
        banatages.instructions = [
            "Cuire et écraser les pommes de terre",
            "Faire revenir la viande avec l'oignon",
            "Assaisonner la farce avec sel, poivre et cumin",
            "Former des boules de purée, creuser et farcir",
            "Refermer et façonner en boulettes ovales",
            "Paner: farine, œuf battu, chapelure",
            "Frire jusqu'à dorure"
        ]
        banatages.imageURL = "banatages"
        modelContext.insert(banatages)
        
        let volAuVent = Recipe(
            name: "Vol-au-vent aux Champignons",
            description: "Feuilletés croustillants garnis de champignons à la crème",
            category: .entree,
            kashroutType: .lait,
            prepTime: 25,
            cookTime: 30,
            servings: 4
        )
        volAuVent.ingredients = [
            Ingredient(name: "Pâte feuilletée", quantity: 1, unit: "rouleau"),
            Ingredient(name: "Champignons de Paris", quantity: 500, unit: "g"),
            Ingredient(name: "Crème fraîche", quantity: 300, unit: "ml"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Beurre", quantity: 40, unit: "g"),
            Ingredient(name: "Farine", quantity: 2, unit: "c. à soupe"),
            Ingredient(name: "Vin blanc", quantity: 50, unit: "ml"),
            Ingredient(name: "Persil", quantity: 1, unit: "bouquet"),
            Ingredient(name: "Jaune d'œuf", quantity: 1, unit: "pièce")
        ]
        volAuVent.instructions = [
            "Découper 6 cercles de pâte feuilletée",
            "Inciser un cercle intérieur sans trancher complètement",
            "Badigeonner de jaune d'œuf",
            "Cuire 20 min à 200°C jusqu'à gonflement et dorure",
            "Émincer les champignons et l'oignon",
            "Faire revenir l'oignon dans le beurre",
            "Ajouter les champignons et cuire 10 min",
            "Saupoudrer de farine et mélanger",
            "Déglacer au vin blanc, puis ajouter la crème",
            "Laisser épaissir 5 min, saler, poivrer",
            "Retirer les chapeaux des vol-au-vent cuits",
            "Garnir de préparation aux champignons",
            "Parsemer de persil et replacer les chapeaux"
        ]
        volAuVent.imageURL = "vol-au-vent"
        modelContext.insert(volAuVent)
        
        // ========================================
        // POISSONS
        // ========================================
        
        let poissonMarocain = Recipe(
            name: "Poisson à la Marocaine",
            description: "Poisson en sauce rouge pimentée avec poivrons",
            category: .plat,
            kashroutType: .parve,
            prepTime: 20,
            cookTime: 40,
            servings: 4
        )
        poissonMarocain.ingredients = [
            Ingredient(name: "Filets de poisson blanc", quantity: 800, unit: "g"),
            Ingredient(name: "Poivrons rouges", quantity: 3, unit: "pièces"),
            Ingredient(name: "Tomates", quantity: 4, unit: "pièces"),
            Ingredient(name: "Ail", quantity: 6, unit: "gousses"),
            Ingredient(name: "Paprika doux", quantity: 2, unit: "c. à soupe"),
            Ingredient(name: "Piment", quantity: 1, unit: "pièce"),
            Ingredient(name: "Huile d'olive", quantity: 80, unit: "ml"),
            Ingredient(name: "Coriandre", quantity: 1, unit: "bouquet")
        ]
        poissonMarocain.instructions = [
            "Couper les poivrons en lanières",
            "Préparer la sauce tomate avec ail et épices",
            "Disposer les poivrons dans un plat",
            "Poser les filets de poisson dessus",
            "Verser la sauce et arroser d'huile",
            "Cuire au four à 180°C pendant 35-40 min",
            "Parsemer de coriandre avant de servir"
        ]
        poissonMarocain.imageURL = "poisson-marocain"
        modelContext.insert(poissonMarocain)
        
        let gefilteFish = Recipe(
            name: "Gefilte Fish",
            description: "Quenelles de carpe farcie, servies froides",
            category: .entree,
            kashroutType: .parve,
            prepTime: 60,
            cookTime: 90,
            servings: 4
        )
        gefilteFish.ingredients = [
            Ingredient(name: "Carpe fraîche", quantity: 1, unit: "kg"),
            Ingredient(name: "Oignons", quantity: 3, unit: "pièces"),
            Ingredient(name: "Œufs", quantity: 2, unit: "pièces"),
            Ingredient(name: "Matza meal", quantity: 100, unit: "g"),
            Ingredient(name: "Sucre", quantity: 2, unit: "c. à soupe"),
            Ingredient(name: "Carottes", quantity: 3, unit: "pièces"),
            Ingredient(name: "Raifort (chrain)", quantity: 1, unit: "pot")
        ]
        gefilteFish.instructions = [
            "Hacher finement le poisson avec les oignons",
            "Ajouter œufs, matza meal, sel, poivre et sucre",
            "Former des quenelles ovales",
            "Préparer un bouillon avec têtes et arêtes",
            "Pocher les quenelles 1h30 à feu doux",
            "Ajouter les carottes en rondelles",
            "Laisser refroidir dans le bouillon",
            "Servir froid avec le raifort"
        ]
        gefilteFish.imageURL = "gefilte-fish"
        modelContext.insert(gefilteFish)
        
        let saumonOriental = Recipe(
            name: "Saumon à l'Orientale",
            description: "Saumon mariné coriandre, ail et citron",
            category: .plat,
            kashroutType: .parve,
            prepTime: 15,
            cookTime: 25,
            servings: 4
        )
        saumonOriental.ingredients = [
            Ingredient(name: "Pavés de saumon", quantity: 6, unit: "pièces"),
            Ingredient(name: "Coriandre fraîche", quantity: 2, unit: "bouquets"),
            Ingredient(name: "Ail", quantity: 6, unit: "gousses"),
            Ingredient(name: "Citron", quantity: 2, unit: "pièces"),
            Ingredient(name: "Huile d'olive", quantity: 60, unit: "ml"),
            Ingredient(name: "Cumin", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Paprika", quantity: 1, unit: "c. à café")
        ]
        saumonOriental.instructions = [
            "Mixer coriandre, ail, huile et épices en pâte",
            "Enduire les pavés de cette marinade",
            "Laisser mariner 30 min au frais",
            "Cuire au four à 200°C pendant 20-25 min",
            "Arroser de jus de citron avant de servir"
        ]
        saumonOriental.imageURL = "saumon-oriental"
        modelContext.insert(saumonOriental)
        
        let chraime = Recipe(
            name: "Chraïme",
            description: "Poisson en sauce très épicée style libyen",
            category: .plat,
            kashroutType: .parve,
            prepTime: 20,
            cookTime: 45,
            servings: 4
        )
        chraime.ingredients = [
            Ingredient(name: "Darnes de poisson", quantity: 6, unit: "pièces"),
            Ingredient(name: "Tomates concassées", quantity: 400, unit: "g"),
            Ingredient(name: "Pâte de tomate", quantity: 3, unit: "c. à soupe"),
            Ingredient(name: "Ail", quantity: 8, unit: "gousses"),
            Ingredient(name: "Piment fort", quantity: 2, unit: "pièces"),
            Ingredient(name: "Carvi", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Paprika", quantity: 2, unit: "c. à soupe"),
            Ingredient(name: "Huile", quantity: 60, unit: "ml")
        ]
        chraime.instructions = [
            "Faire revenir l'ail et le piment dans l'huile",
            "Ajouter tomates, pâte de tomate et épices",
            "Laisser mijoter 15 min",
            "Disposer les darnes de poisson dans la sauce",
            "Couvrir et cuire 25-30 min",
            "La sauce doit être épaisse et relevée"
        ]
        chraime.imageURL = "chraime"
        modelContext.insert(chraime)
        
        let saumonCitronCapres = Recipe(
            name: "Saumon Citron et Câpres",
            description: "Saumon rôti au citron et câpres",
            category: .plat,
            kashroutType: .parve,
            prepTime: 10,
            cookTime: 20,
            servings: 4
        )
        saumonCitronCapres.ingredients = [
            Ingredient(name: "Pavés de saumon", quantity: 4, unit: "pièces"),
            Ingredient(name: "Citron", quantity: 2, unit: "pièces"),
            Ingredient(name: "Câpres", quantity: 3, unit: "c. à soupe"),
            Ingredient(name: "Beurre ou margarine", quantity: 50, unit: "g"),
            Ingredient(name: "Aneth", quantity: 1, unit: "bouquet"),
            Ingredient(name: "Vin blanc (facultatif)", quantity: 50, unit: "ml")
        ]
        saumonCitronCapres.instructions = [
            "Disposer le saumon dans un plat allant au four",
            "Arroser de jus de citron et vin blanc",
            "Parsemer de câpres et rondelles de citron",
            "Ajouter des noisettes de beurre",
            "Cuire à 200°C pendant 18-20 min",
            "Garnir d'aneth frais"
        ]
        saumonCitronCapres.imageURL = "saumon-citron-capres"
        modelContext.insert(saumonCitronCapres)
        
        // ========================================
        // PLATS VENDREDI SOIR - Volailles
        // ========================================
        
        let pouletRoti = Recipe(
            name: "Poulet Rôti aux Pommes de Terre",
            description: "Le grand classique du vendredi soir",
            category: .plat,
            kashroutType: .viande,
            prepTime: 20,
            cookTime: 90,
            servings: 4
        )
        pouletRoti.ingredients = [
            Ingredient(name: "Poulet entier", quantity: 1.5, unit: "kg"),
            Ingredient(name: "Pommes de terre", quantity: 1, unit: "kg"),
            Ingredient(name: "Oignons", quantity: 2, unit: "pièces"),
            Ingredient(name: "Ail", quantity: 6, unit: "gousses"),
            Ingredient(name: "Huile d'olive", quantity: 60, unit: "ml"),
            Ingredient(name: "Paprika", quantity: 2, unit: "c. à soupe"),
            Ingredient(name: "Herbes de Provence", quantity: 1, unit: "c. à soupe"),
            Ingredient(name: "Citron", quantity: 1, unit: "pièce")
        ]
        pouletRoti.instructions = [
            "Préchauffer le four à 200°C",
            "Couper les pommes de terre en quartiers",
            "Assaisonner le poulet avec huile, paprika et herbes",
            "Placer le citron coupé et l'ail dans la cavité",
            "Disposer les pommes de terre autour",
            "Enfourner et cuire 1h30 en arrosant régulièrement"
        ]
        pouletRoti.imageURL = "poulet-roti"
        modelContext.insert(pouletRoti)
        
        let pouletOlivesCitron = Recipe(
            name: "Poulet aux Olives et Citron Confit",
            description: "Tajine de poulet à la marocaine",
            category: .plat,
            kashroutType: .viande,
            prepTime: 25,
            cookTime: 60,
            servings: 4
        )
        pouletOlivesCitron.ingredients = [
            Ingredient(name: "Cuisses de poulet", quantity: 8, unit: "pièces"),
            Ingredient(name: "Citrons confits", quantity: 2, unit: "pièces"),
            Ingredient(name: "Olives vertes", quantity: 200, unit: "g"),
            Ingredient(name: "Oignons", quantity: 2, unit: "pièces"),
            Ingredient(name: "Gingembre", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Curcuma", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Coriandre", quantity: 1, unit: "bouquet"),
            Ingredient(name: "Huile d'olive", quantity: 60, unit: "ml")
        ]
        pouletOlivesCitron.instructions = [
            "Faire revenir les oignons émincés",
            "Ajouter le poulet et dorer tous les côtés",
            "Incorporer les épices et couvrir d'eau",
            "Laisser mijoter 40 min à couvert",
            "Ajouter les olives et le citron confit en lamelles",
            "Poursuivre la cuisson 15 min",
            "Servir parsemé de coriandre"
        ]
        pouletOlivesCitron.imageURL = "poulet-olives-citron"
        modelContext.insert(pouletOlivesCitron)
        
        let schnitzel = Recipe(
            name: "Schnitzel de Poulet",
            description: "Escalopes panées croustillantes",
            category: .plat,
            kashroutType: .viande,
            prepTime: 20,
            cookTime: 15,
            servings: 4
        )
        schnitzel.ingredients = [
            Ingredient(name: "Blancs de poulet", quantity: 6, unit: "pièces"),
            Ingredient(name: "Œufs", quantity: 3, unit: "pièces"),
            Ingredient(name: "Farine", quantity: 100, unit: "g"),
            Ingredient(name: "Chapelure", quantity: 200, unit: "g"),
            Ingredient(name: "Paprika", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Huile pour friture", quantity: 200, unit: "ml")
        ]
        schnitzel.instructions = [
            "Aplatir les blancs de poulet entre 2 feuilles de film",
            "Préparer 3 assiettes: farine, œufs battus, chapelure",
            "Ajouter le paprika à la chapelure",
            "Paner chaque escalope: farine, œuf, chapelure",
            "Frire dans l'huile chaude 3-4 min par côté",
            "Égoutter sur papier absorbant"
        ]
        schnitzel.imageURL = "schnitzel"
        modelContext.insert(schnitzel)
        
        let pouletFruitsSecs = Recipe(
            name: "Poulet aux Fruits Secs",
            description: "Poulet sucré-salé aux abricots et pruneaux",
            category: .plat,
            kashroutType: .viande,
            prepTime: 20,
            cookTime: 75,
            servings: 4
        )
        pouletFruitsSecs.ingredients = [
            Ingredient(name: "Cuisses de poulet", quantity: 6, unit: "pièces"),
            Ingredient(name: "Abricots secs", quantity: 150, unit: "g"),
            Ingredient(name: "Pruneaux", quantity: 150, unit: "g"),
            Ingredient(name: "Miel", quantity: 60, unit: "ml"),
            Ingredient(name: "Cannelle", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Amandes effilées", quantity: 50, unit: "g")
        ]
        pouletFruitsSecs.instructions = [
            "Faire dorer le poulet dans une cocotte",
            "Ajouter l'oignon émincé et faire revenir",
            "Incorporer le miel et la cannelle",
            "Ajouter les fruits secs et couvrir d'eau",
            "Laisser mijoter 1h à couvert",
            "Parsemer d'amandes grillées avant de servir"
        ]
        pouletFruitsSecs.imageURL = "poulet-fruits-secs"
        modelContext.insert(pouletFruitsSecs)
        
        let pouletSojaMiel = Recipe(
            name: "Poulet Soja-Miel",
            description: "Poulet caramélisé style asiatique",
            category: .plat,
            kashroutType: .viande,
            prepTime: 15,
            cookTime: 45,
            servings: 4
        )
        pouletSojaMiel.ingredients = [
            Ingredient(name: "Pilons de poulet", quantity: 12, unit: "pièces"),
            Ingredient(name: "Sauce soja", quantity: 80, unit: "ml"),
            Ingredient(name: "Miel", quantity: 60, unit: "ml"),
            Ingredient(name: "Ail", quantity: 4, unit: "gousses"),
            Ingredient(name: "Gingembre frais", quantity: 1, unit: "c. à soupe"),
            Ingredient(name: "Graines de sésame", quantity: 2, unit: "c. à soupe")
        ]
        pouletSojaMiel.instructions = [
            "Mélanger soja, miel, ail et gingembre râpé",
            "Mariner le poulet au moins 2h (ou toute la nuit)",
            "Disposer dans un plat à four",
            "Cuire à 200°C pendant 40-45 min",
            "Retourner et arroser de marinade régulièrement",
            "Parsemer de graines de sésame"
        ]
        pouletSojaMiel.imageURL = "poulet-soja-miel"
        modelContext.insert(pouletSojaMiel)
        
        // ========================================
        // PLATS VENDREDI SOIR - Viandes
        // ========================================
        
        let boulettesSauce = Recipe(
            name: "Boulettes de Viande à la Tomate",
            description: "Boulettes moelleuses en sauce tomate épicée",
            category: .plat,
            kashroutType: .viande,
            prepTime: 30,
            cookTime: 45,
            servings: 4
        )
        boulettesSauce.ingredients = [
            Ingredient(name: "Viande hachée", quantity: 600, unit: "g"),
            Ingredient(name: "Coulis de tomates", quantity: 500, unit: "ml"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Œuf", quantity: 1, unit: "pièce"),
            Ingredient(name: "Chapelure", quantity: 50, unit: "g"),
            Ingredient(name: "Cumin", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Paprika", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Persil", quantity: 1, unit: "bouquet")
        ]
        boulettesSauce.instructions = [
            "Mélanger viande, œuf, chapelure, persil haché",
            "Former des boulettes de taille moyenne",
            "Faire revenir l'oignon émincé dans une cocotte",
            "Ajouter le coulis et les épices",
            "Déposer les boulettes dans la sauce",
            "Couvrir et laisser mijoter 40 min"
        ]
        boulettesSauce.imageURL = "boulettes-sauce"
        modelContext.insert(boulettesSauce)
        
        let rotiBoeuf = Recipe(
            name: "Rôti de Bœuf aux Oignons",
            description: "Rôti fondant aux oignons caramélisés",
            category: .plat,
            kashroutType: .viande,
            prepTime: 20,
            cookTime: 180,
            servings: 4
        )
        rotiBoeuf.ingredients = [
            Ingredient(name: "Rôti de bœuf", quantity: 1.5, unit: "kg"),
            Ingredient(name: "Oignons", quantity: 6, unit: "pièces"),
            Ingredient(name: "Ail", quantity: 6, unit: "gousses"),
            Ingredient(name: "Huile d'olive", quantity: 60, unit: "ml"),
            Ingredient(name: "Thym", quantity: 4, unit: "branches"),
            Ingredient(name: "Vin rouge (optionnel)", quantity: 200, unit: "ml")
        ]
        rotiBoeuf.instructions = [
            "Saisir le rôti de tous côtés dans une cocotte",
            "Réserver et faire revenir les oignons émincés",
            "Ajouter l'ail et le thym",
            "Remettre la viande et déglacer au vin",
            "Couvrir et cuire à 160°C pendant 3h",
            "Trancher et servir avec les oignons"
        ]
        rotiBoeuf.imageURL = "roti-boeuf"
        modelContext.insert(rotiBoeuf)
        
        let tajineVeauPruneaux = Recipe(
            name: "Tajine de Veau aux Pruneaux",
            description: "Veau fondant sucré-salé",
            category: .plat,
            kashroutType: .viande,
            prepTime: 25,
            cookTime: 120,
            servings: 4
        )
        tajineVeauPruneaux.ingredients = [
            Ingredient(name: "Épaule de veau", quantity: 1, unit: "kg"),
            Ingredient(name: "Pruneaux", quantity: 250, unit: "g"),
            Ingredient(name: "Miel", quantity: 3, unit: "c. à soupe"),
            Ingredient(name: "Cannelle", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Oignons", quantity: 2, unit: "pièces"),
            Ingredient(name: "Amandes", quantity: 100, unit: "g"),
            Ingredient(name: "Graines de sésame", quantity: 2, unit: "c. à soupe")
        ]
        tajineVeauPruneaux.instructions = [
            "Faire dorer la viande coupée en morceaux",
            "Ajouter les oignons et faire revenir",
            "Incorporer la cannelle et couvrir d'eau",
            "Laisser mijoter 1h30 à feu doux",
            "Ajouter les pruneaux et le miel",
            "Poursuivre 30 min puis garnir d'amandes et sésame"
        ]
        tajineVeauPruneaux.imageURL = "tajine-veau-pruneaux"
        modelContext.insert(tajineVeauPruneaux)
        
        let kebab = Recipe(
            name: "Kefta (Brochettes de Viande)",
            description: "Brochettes de viande épicée grillée",
            category: .plat,
            kashroutType: .viande,
            prepTime: 25,
            cookTime: 15,
            servings: 4
        )
        kebab.ingredients = [
            Ingredient(name: "Viande hachée", quantity: 600, unit: "g"),
            Ingredient(name: "Oignon râpé", quantity: 1, unit: "pièce"),
            Ingredient(name: "Persil", quantity: 1, unit: "bouquet"),
            Ingredient(name: "Cumin", quantity: 2, unit: "c. à café"),
            Ingredient(name: "Paprika", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Piment doux", quantity: 1, unit: "c. à café")
        ]
        kebab.instructions = [
            "Mélanger tous les ingrédients",
            "Laisser reposer 1h au frais",
            "Former des saucisses autour de brochettes",
            "Griller au four ou au barbecue 12-15 min",
            "Servir avec du riz ou dans du pain pita"
        ]
        kebab.imageURL = "kefta"
        modelContext.insert(kebab)
        
        let langueSauce = Recipe(
            name: "Langue de Bœuf en Sauce",
            description: "Langue fondante sauce aux câpres",
            category: .plat,
            kashroutType: .viande,
            prepTime: 30,
            cookTime: 180,
            servings: 4
        )
        langueSauce.ingredients = [
            Ingredient(name: "Langue de bœuf", quantity: 1.5, unit: "kg"),
            Ingredient(name: "Carottes", quantity: 3, unit: "pièces"),
            Ingredient(name: "Oignons", quantity: 2, unit: "pièces"),
            Ingredient(name: "Câpres", quantity: 50, unit: "g"),
            Ingredient(name: "Cornichons", quantity: 4, unit: "pièces"),
            Ingredient(name: "Bouillon", quantity: 1, unit: "L")
        ]
        langueSauce.instructions = [
            "Faire bouillir la langue 2h30 avec légumes",
            "Retirer la peau et trancher",
            "Préparer une sauce avec le bouillon filtré",
            "Ajouter câpres et cornichons hachés",
            "Napper la langue de sauce"
        ]
        langueSauce.imageURL = "langue-sauce"
        modelContext.insert(langueSauce)
        
        let moussakaViande = Recipe(
            name: "Moussaka",
            description: "Gratin d'aubergines à la viande",
            category: .plat,
            kashroutType: .viande,
            prepTime: 45,
            cookTime: 60,
            servings: 4
        )
        moussakaViande.ingredients = [
            Ingredient(name: "Aubergines", quantity: 4, unit: "pièces"),
            Ingredient(name: "Viande hachée", quantity: 500, unit: "g"),
            Ingredient(name: "Coulis de tomates", quantity: 400, unit: "ml"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Ail", quantity: 3, unit: "gousses"),
            Ingredient(name: "Cannelle", quantity: 0.5, unit: "c. à café"),
            Ingredient(name: "Pommes de terre", quantity: 4, unit: "pièces")
        ]
        moussakaViande.instructions = [
            "Trancher et griller les aubergines au four",
            "Faire revenir la viande avec oignon et ail",
            "Ajouter le coulis et la cannelle",
            "Couper les pommes de terre en rondelles et précuire",
            "Alterner les couches: PDT, viande, aubergines",
            "Cuire au four 45 min à 180°C"
        ]
        moussakaViande.imageURL = "moussaka"
        modelContext.insert(moussakaViande)
        
        // ========================================
        // PLATS SAMEDI MIDI - Mijotés
        // ========================================
        
        let tbit = Recipe(
            name: "T'bit (Hamin Irakien)",
            description: "Poulet farci au riz cuit toute la nuit",
            category: .plat,
            kashroutType: .viande,
            prepTime: 45,
            cookTime: 720,
            servings: 4
        )
        tbit.ingredients = [
            Ingredient(name: "Poulet entier", quantity: 1.5, unit: "kg"),
            Ingredient(name: "Riz basmati", quantity: 400, unit: "g"),
            Ingredient(name: "Tomates", quantity: 2, unit: "pièces"),
            Ingredient(name: "Cardamome", quantity: 4, unit: "gousses"),
            Ingredient(name: "Curcuma", quantity: 2, unit: "c. à café"),
            Ingredient(name: "Baharat", quantity: 1, unit: "c. à soupe"),
            Ingredient(name: "Huile", quantity: 80, unit: "ml")
        ]
        tbit.instructions = [
            "Farcir le poulet avec du riz assaisonné",
            "Coudre l'ouverture pour fermer",
            "Disposer dans une grande cocotte avec le reste du riz",
            "Ajouter tomates, épices et eau à niveau",
            "Porter à ébullition puis mettre sur plata",
            "Laisser cuire toute la nuit (12h)"
        ]
        tbit.imageURL = "tbit"
        modelContext.insert(tbit)
        
        let ossoBuco = Recipe(
            name: "Osso Buco",
            description: "Jarrets de veau braisés aux légumes",
            category: .plat,
            kashroutType: .viande,
            prepTime: 30,
            cookTime: 150,
            servings: 4
        )
        ossoBuco.ingredients = [
            Ingredient(name: "Jarrets de veau", quantity: 6, unit: "tranches"),
            Ingredient(name: "Carottes", quantity: 3, unit: "pièces"),
            Ingredient(name: "Céleri", quantity: 2, unit: "branches"),
            Ingredient(name: "Tomates pelées", quantity: 400, unit: "g"),
            Ingredient(name: "Vin blanc", quantity: 200, unit: "ml"),
            Ingredient(name: "Bouillon", quantity: 500, unit: "ml"),
            Ingredient(name: "Zeste de citron", quantity: 1, unit: "pièce")
        ]
        ossoBuco.instructions = [
            "Fariner et saisir les jarrets des deux côtés",
            "Réserver et faire revenir les légumes en dés",
            "Remettre la viande, ajouter tomates et vin",
            "Verser le bouillon et porter à ébullition",
            "Cuire au four à 160°C pendant 2h30",
            "Servir avec zeste de citron (gremolata)"
        ]
        ossoBuco.imageURL = "osso-buco"
        modelContext.insert(ossoBuco)
        
        let ganaouia = Recipe(
            name: "Ganaouia (Gombos à la Viande)",
            description: "Ragoût de gombos à la tunisienne",
            category: .plat,
            kashroutType: .viande,
            prepTime: 25,
            cookTime: 90,
            servings: 4
        )
        ganaouia.ingredients = [
            Ingredient(name: "Viande de bœuf", quantity: 500, unit: "g"),
            Ingredient(name: "Gombos frais ou surgelés", quantity: 500, unit: "g"),
            Ingredient(name: "Coulis de tomates", quantity: 400, unit: "ml"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Ail", quantity: 4, unit: "gousses"),
            Ingredient(name: "Concentré de tomates", quantity: 2, unit: "c. à soupe"),
            Ingredient(name: "Cumin", quantity: 1, unit: "c. à café")
        ]
        ganaouia.instructions = [
            "Faire dorer la viande coupée en morceaux",
            "Ajouter l'oignon et l'ail, faire revenir",
            "Incorporer le concentré et le coulis de tomates",
            "Couvrir d'eau et laisser mijoter 1h",
            "Ajouter les gombos et le cumin",
            "Poursuivre la cuisson 30 min"
        ]
        ganaouia.imageURL = "ganaouia"
        modelContext.insert(ganaouia)
        
        let loubia = Recipe(
            name: "Loubia (Haricots Blancs à la Viande)",
            description: "Ragoût de haricots blancs",
            category: .plat,
            kashroutType: .viande,
            prepTime: 20,
            cookTime: 120,
            servings: 4
        )
        loubia.ingredients = [
            Ingredient(name: "Haricots blancs secs", quantity: 400, unit: "g"),
            Ingredient(name: "Viande de bœuf", quantity: 400, unit: "g"),
            Ingredient(name: "Coulis de tomates", quantity: 500, unit: "ml"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Paprika", quantity: 2, unit: "c. à café"),
            Ingredient(name: "Cumin", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Harissa", quantity: 1, unit: "c. à café")
        ]
        loubia.instructions = [
            "Faire tremper les haricots la veille",
            "Faire dorer la viande en morceaux",
            "Ajouter l'oignon et les épices",
            "Incorporer les haricots égouttés et le coulis",
            "Couvrir d'eau généreusement",
            "Laisser mijoter 2h à feu doux"
        ]
        loubia.imageURL = "loubia"
        modelContext.insert(loubia)
        
        // ========================================
        // ACCOMPAGNEMENTS
        // ========================================
        
        let rizOriental = Recipe(
            name: "Riz Oriental aux Vermicelles",
            description: "Riz parfumé aux vermicelles dorés",
            category: .accompagnement,
            kashroutType: .parve,
            prepTime: 10,
            cookTime: 25,
            servings: 4
        )
        rizOriental.ingredients = [
            Ingredient(name: "Riz basmati", quantity: 400, unit: "g"),
            Ingredient(name: "Vermicelles", quantity: 80, unit: "g"),
            Ingredient(name: "Huile", quantity: 3, unit: "c. à soupe"),
            Ingredient(name: "Curcuma", quantity: 0.5, unit: "c. à café"),
            Ingredient(name: "Eau", quantity: 600, unit: "ml")
        ]
        rizOriental.instructions = [
            "Faire dorer les vermicelles cassés dans l'huile",
            "Ajouter le riz rincé et mélanger",
            "Incorporer le curcuma et verser l'eau",
            "Porter à ébullition puis couvrir",
            "Cuire 20 min à feu très doux",
            "Laisser reposer 5 min avant de servir"
        ]
        rizOriental.imageURL = "riz-oriental"
        modelContext.insert(rizOriental)
        
        let couscousFin = Recipe(
            name: "Couscous Fin",
            description: "Couscous traditionnel bien aéré",
            category: .accompagnement,
            kashroutType: .parve,
            prepTime: 15,
            cookTime: 20,
            servings: 4
        )
        couscousFin.ingredients = [
            Ingredient(name: "Couscous fin", quantity: 400, unit: "g"),
            Ingredient(name: "Eau bouillante", quantity: 400, unit: "ml"),
            Ingredient(name: "Huile d'olive", quantity: 2, unit: "c. à soupe"),
            Ingredient(name: "Sel", quantity: 1, unit: "c. à café")
        ]
        couscousFin.instructions = [
            "Verser le couscous dans un grand plat",
            "Ajouter l'huile et mélanger",
            "Verser l'eau bouillante salée",
            "Couvrir et laisser gonfler 10 min",
            "Égrener à la fourchette",
            "Servir ou passer à la vapeur pour plus de légèreté"
        ]
        couscousFin.imageURL = "couscous-fin"
        modelContext.insert(couscousFin)
        
        let kugelPDT = Recipe(
            name: "Kugel de Pommes de Terre",
            description: "Gratin de pommes de terre ashkénaze",
            category: .accompagnement,
            kashroutType: .parve,
            prepTime: 25,
            cookTime: 60,
            servings: 4
        )
        kugelPDT.ingredients = [
            Ingredient(name: "Pommes de terre", quantity: 1, unit: "kg"),
            Ingredient(name: "Oignons", quantity: 2, unit: "pièces"),
            Ingredient(name: "Œufs", quantity: 3, unit: "pièces"),
            Ingredient(name: "Farine ou fécule", quantity: 50, unit: "g"),
            Ingredient(name: "Huile", quantity: 100, unit: "ml"),
            Ingredient(name: "Poivre", quantity: 1, unit: "c. à café")
        ]
        kugelPDT.instructions = [
            "Râper les pommes de terre et les oignons",
            "Presser pour retirer l'excès d'eau",
            "Mélanger avec œufs, farine et assaisonnement",
            "Verser l'huile chaude dans le plat",
            "Ajouter le mélange et lisser",
            "Cuire à 200°C pendant 1h jusqu'<à doré"
        ]
        kugelPDT.imageURL = "kugel-pdt"
        modelContext.insert(kugelPDT)
        
        let haricotsVerts = Recipe(
            name: "Haricots Verts Sautés",
            description: "Haricots verts à l'ail et citron",
            category: .accompagnement,
            kashroutType: .parve,
            prepTime: 10,
            cookTime: 15,
            servings: 4
        )
        haricotsVerts.ingredients = [
            Ingredient(name: "Haricots verts", quantity: 500, unit: "g"),
            Ingredient(name: "Ail", quantity: 3, unit: "gousses"),
            Ingredient(name: "Huile d'olive", quantity: 2, unit: "c. à soupe"),
            Ingredient(name: "Jus de citron", quantity: 1, unit: "c. à soupe"),
            Ingredient(name: "Amandes effilées", quantity: 30, unit: "g")
        ]
        haricotsVerts.instructions = [
            "Blanchir les haricots 5 min à l'eau bouillante",
            "Plonger dans l'eau glacée pour stopper la cuisson",
            "Faire revenir l'ail dans l'huile",
            "Ajouter les haricots et sauter 3-4 min",
            "Assaisonner de citron et garnir d'amandes"
        ]
        haricotsVerts.imageURL = "haricots-verts"
        modelContext.insert(haricotsVerts)
        
        let pdtRoties = Recipe(
            name: "Pommes de Terre Rôties",
            description: "Pommes de terre croustillantes au four",
            category: .accompagnement,
            kashroutType: .parve,
            prepTime: 10,
            cookTime: 45,
            servings: 4
        )
        pdtRoties.ingredients = [
            Ingredient(name: "Pommes de terre", quantity: 1, unit: "kg"),
            Ingredient(name: "Huile d'olive", quantity: 60, unit: "ml"),
            Ingredient(name: "Paprika", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Ail en poudre", quantity: 1, unit: "c. à café"),
            Ingredient(name: "Romarin", quantity: 2, unit: "branches")
        ]
        pdtRoties.instructions = [
            "Couper les pommes de terre en quartiers",
            "Mélanger avec huile et épices",
            "Étaler sur une plaque de cuisson",
            "Ajouter le romarin",
            "Cuire à 200°C pendant 40-45 min",
            "Retourner à mi-cuisson"
        ]
        pdtRoties.imageURL = "pdt-roties"
        modelContext.insert(pdtRoties)
        
        let ratatouille = Recipe(
            name: "Ratatouille",
            description: "Légumes du soleil mijotés",
            category: .accompagnement,
            kashroutType: .parve,
            prepTime: 25,
            cookTime: 45,
            servings: 4
        )
        ratatouille.ingredients = [
            Ingredient(name: "Courgettes", quantity: 2, unit: "pièces"),
            Ingredient(name: "Aubergines", quantity: 2, unit: "pièces"),
            Ingredient(name: "Poivrons", quantity: 2, unit: "pièces"),
            Ingredient(name: "Tomates", quantity: 4, unit: "pièces"),
            Ingredient(name: "Oignon", quantity: 1, unit: "pièce"),
            Ingredient(name: "Ail", quantity: 3, unit: "gousses"),
            Ingredient(name: "Herbes de Provence", quantity: 1, unit: "c. à soupe")
        ]
        ratatouille.instructions = [
            "Couper tous les légumes en cubes",
            "Faire revenir l'oignon et l'ail",
            "Ajouter les aubergines et les poivrons",
            "Après 10 min, ajouter courgettes et tomates",
            "Assaisonner avec les herbes",
            "Laisser mijoter 30 min à couvert"
        ]
        ratatouille.imageURL = "ratatouille"
        modelContext.insert(ratatouille)
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    let icon: String?
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
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background {
                Capsule()
                    .fill(isSelected ? Color.shabGold.opacity(0.2) : Color(UIColor.secondarySystemBackground))
            }
            .foregroundStyle(isSelected ? Color.shabGold : .primary)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Recipe Card
struct RecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(spacing: 0) {
            // Image avec padding et coins arrondis
            GeometryReader { geo in
                Group {
                    if let imageData = recipe.imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: 130)
                            .clipped()
                    } else if let imageName = recipe.imageURL,
                              !imageName.isEmpty,
                              let uiImage = UIImage(named: imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: 130)
                            .clipped()
                    } else {
                        // Placeholder élégant
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        recipe.kashroutType.color.opacity(0.15),
                                        recipe.kashroutType.color.opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay {
                                Image(systemName: recipe.category.icon)
                                    .font(.system(size: 36, weight: .ultraLight))
                                    .foregroundStyle(recipe.kashroutType.color.opacity(0.4))
                            }
                    }
                }
            }
            .frame(height: 130)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 10)
            .padding(.top, 10)
            
            // Contenu texte
            VStack(alignment: .leading, spacing: 8) {
                // Titre
                Text(recipe.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, minHeight: 38, maxHeight: 38, alignment: .topLeading)
                
                // Tags: Kashrout + Temps
                HStack(spacing: 8) {
                    Text(recipe.kashroutType.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(recipe.kashroutType.color)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(recipe.kashroutType.color.opacity(0.12))
                        )
                    
                    if recipe.prepTime + recipe.cookTime > 0 {
                        Label(formatTime(recipe.prepTime + recipe.cookTime), systemImage: "clock")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Footer: Personnes + Favori
                HStack {
                    Label("\(recipe.servings) pers.", systemImage: "person.2")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 14))
                        .foregroundStyle(recipe.isFavorite ? .red : Color.secondary.opacity(0.5))
                }
            }
            .padding(.horizontal, 14)
            .padding(.top, 4)
            .padding(.bottom, 12)
        }
        .frame(height: 275)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.shabGold.opacity(0.6),
                            Color.shabGold.opacity(0.3),
                            Color.shabGold.opacity(0.15),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
    
    private func formatTime(_ minutes: Int) -> String {
        if minutes >= 60 {
            let hours = minutes / 60
            let mins = minutes % 60
            return mins == 0 ? "\(hours)h" : "\(hours)h\(mins)"
        }
        return "\(minutes)min"
    }
}

// MARK: - Recipe Detail View
struct RecipeDetailView: View {
    @Bindable var recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    @State private var servingsMultiplier: Int
    @State private var showingConverter = false
    @State private var showingEditSheet = false
    @State private var showingShareSheet = false
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self._servingsMultiplier = State(initialValue: recipe.servings)
    }
    
    // MARK: - Generate Shareable Text
    private func generateShareText() -> String {
        var text = "🍽️ \(recipe.name)\n"
        text += "━━━━━━━━━━━━━━━━━━\n\n"
        
        if !recipe.descriptionText.isEmpty {
            text += "📝 \(recipe.descriptionText)\n\n"
        }
        
        text += "⏱️ Préparation: \(recipe.prepTime) min\n"
        if recipe.cookTime >= 60 {
            text += "🔥 Cuisson: \(recipe.cookTime / 60)h\(recipe.cookTime % 60 > 0 ? String(format: "%02d", recipe.cookTime % 60) : "")\n"
        } else {
            text += "🔥 Cuisson: \(recipe.cookTime) min\n"
        }
        text += "👥 Pour \(recipe.servings) personnes\n"
        text += "🏷️ \(recipe.kashroutType.rawValue) • \(recipe.category.rawValue)\n\n"
        
        text += "📋 INGRÉDIENTS\n"
        text += "─────────────────\n"
        for ingredient in recipe.ingredients {
            let quantityStr: String
            if ingredient.quantity.truncatingRemainder(dividingBy: 1) == 0 {
                quantityStr = "\(Int(ingredient.quantity))"
            } else {
                quantityStr = String(format: "%.1f", ingredient.quantity)
            }
            text += "• \(ingredient.name): \(quantityStr) \(ingredient.unit)\n"
        }
        
        if !recipe.instructions.isEmpty {
            text += "\n📖 INSTRUCTIONS\n"
            text += "─────────────────\n"
            for (index, instruction) in recipe.instructions.enumerated() {
                text += "\(index + 1). \(instruction)\n"
            }
        }
        
        text += "\n✨ Recette partagée depuis monChabat"
        
        return text
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Custom Header with back button, title, and actions
                customHeader
                
                // Image de la recette
                recipeImage
                
                // Kashrout & Category badges
                badgesRow
                
                // Quick info
                quickInfo
                
                // Servings converter
                servingsConverter
                
                // Ingredients
                ingredientsSection
                
                // Instructions
                instructionsSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .background(SwipeBackGestureEnabler())
        .sheet(isPresented: $showingEditSheet) {
            EditRecipeSheet(recipe: recipe)
        }
        .sheet(isPresented: $showingShareSheet) {
            RecipeShareSheet(text: generateShareText(), recipeName: recipe.name)
        }
    }
    
    // MARK: - Custom Header
    private var customHeader: some View {
        HStack(alignment: .top, spacing: 12) {
            // Back button
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color(UIColor.secondarySystemBackground)))
            }
            .buttonStyle(.plain)
            
            // Title and description
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .lineLimit(2)
                
                if !recipe.descriptionText.isEmpty {
                    Text(recipe.descriptionText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer(minLength: 0)
            
            // Action buttons
            HStack(spacing: 8) {
                // Share button
                Button {
                    showingShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.shabGold)
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Color(UIColor.secondarySystemBackground)))
                }
                .buttonStyle(.plain)
                
                // Edit button
                Button {
                    showingEditSheet = true
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.shabGold)
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Color(UIColor.secondarySystemBackground)))
                }
                .buttonStyle(.plain)
                
                // Favorite button
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        recipe.isFavorite.toggle()
                    }
                    HapticManager.impact(.light)
                } label: {
                    Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(recipe.isFavorite ? .red : .secondary)
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Color(UIColor.secondarySystemBackground)))
                        .scaleEffect(recipe.isFavorite ? 1.1 : 1.0)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Recipe Image
    private var recipeImage: some View {
        Group {
            if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else if let imageName = recipe.imageURL, !imageName.isEmpty,
               let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
    
    // MARK: - Badges Row
    private var badgesRow: some View {
        HStack {
            Text(recipe.kashroutType.rawValue)
                .font(.subheadline.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(recipe.kashroutType.color.opacity(0.2)))
                .foregroundStyle(recipe.kashroutType.color)
            
            Text(recipe.category.rawValue)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color(UIColor.secondarySystemBackground)))
                .foregroundStyle(.secondary)
            
            Spacer()
        }
    }
    

    
    private var quickInfo: some View {
        HStack(spacing: 20) {
            InfoPill(icon: "clock", value: "\(recipe.prepTime)min", label: "Prépa")
            InfoPill(icon: "flame", value: formatCookTime(), label: "Cuisson")
            InfoPill(icon: "person.2", value: "\(recipe.servings)", label: "Portions")
        }
        .padding(16)
        .liquidGlassCard(cornerRadius: 16)
    }
    
    private func formatCookTime() -> String {
        if recipe.cookTime >= 60 {
            return "\(recipe.cookTime / 60)h"
        }
        return "\(recipe.cookTime)min"
    }
    
    private var servingsConverter: some View {
        VStack(alignment: .leading, spacing: 12) {
            GlassSectionHeader(title: "Ajuster les quantités", icon: "slider.horizontal.3", action: nil, actionLabel: nil)
            
            HStack {
                Text("Pour combien de personnes ?")
                    .font(.subheadline)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button {
                        if servingsMultiplier > 1 {
                            servingsMultiplier -= 1
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.shabGold)
                    }
                    
                    Text("\(servingsMultiplier)")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .frame(width: 40)
                    
                    Button {
                        servingsMultiplier += 1
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.shabGold)
                    }
                }
            }
        }
        .padding(16)
        .liquidGlassCard(cornerRadius: 16)
    }
    
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            GlassSectionHeader(title: "Ingrédients", icon: "list.bullet", action: nil, actionLabel: nil)
            
            ForEach(recipe.ingredients, id: \.name) { ingredient in
                let scaled = ingredient.scaled(for: servingsMultiplier, originalServings: recipe.servings)
                
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundStyle(Color.shabGold)
                    
                    Text(scaled.name)
                    
                    Spacer()
                    
                    Text(formatQuantity(scaled.quantity, unit: scaled.unit))
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(16)
        .liquidGlassCard(cornerRadius: 16)
    }
    
    private func formatQuantity(_ quantity: Double, unit: String) -> String {
        if quantity.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(quantity)) \(unit)"
        }
        return String(format: "%.1f %@", quantity, unit)
    }
    
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            GlassSectionHeader(title: "Instructions", icon: "text.alignleft", action: nil, actionLabel: nil)
            
            ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.shabGold.opacity(0.2))
                            .frame(width: 28, height: 28)
                        Text("\(index + 1)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.shabGold)
                    }
                    
                    Text(instruction)
                        .font(.subheadline)
                }
            }
        }
        .padding(16)
        .liquidGlassCard(cornerRadius: 16)
    }
}

// MARK: - Info Pill
struct InfoPill: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.shabGold)
            Text(value)
                .font(.system(size: 16, weight: .semibold))
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Add Recipe Sheet
struct AddRecipeSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var name = ""
    @State private var description = ""
    @State private var category: RecipeCategory = .plat
    @State private var kashroutType: KashroutType = .parve
    @State private var prepTime = 30
    @State private var cookTime = 60
    @State private var servings = 4
    
    // Photo
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingPhotoOptions = false
    
    // Ingredients
    @State private var ingredients: [EditableIngredient] = []
    @State private var showingAddIngredient = false
    
    // Instructions
    @State private var instructions: [String] = []
    @State private var newInstruction = ""
    
    struct EditableIngredient: Identifiable {
        let id = UUID()
        var name: String
        var quantity: Double
        var unit: String
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Photo Section
                Section {
                    Button {
                        showingPhotoOptions = true
                    } label: {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 180)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(alignment: .topTrailing) {
                                    Button {
                                        selectedImage = nil
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundStyle(.white)
                                            .shadow(radius: 2)
                                    }
                                    .padding(8)
                                }
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(Color.shabGold)
                                Text("Ajouter une photo")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .buttonStyle(.plain)
                } header: {
                    Text("Photo")
                }
                
                Section("Informations") {
                    TextField("Nom de la recette", text: $name)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Catégorie") {
                    Picker("Type", selection: $category) {
                        ForEach(RecipeCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                    
                    Picker("Cacheroute", selection: $kashroutType) {
                        ForEach(KashroutType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                Section("Temps") {
                    Stepper("Préparation: \(prepTime) min", value: $prepTime, in: 0...180, step: 5)
                    Stepper("Cuisson: \(cookTime) min", value: $cookTime, in: 0...1440, step: 15)
                }
                
                Section("Portions") {
                    Stepper("\(servings) personnes", value: $servings, in: 1...50)
                }
                
                // Ingredients Section
                Section {
                    ForEach(ingredients) { ingredient in
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            Text(formatIngredientQuantity(ingredient))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deleteIngredient)
                    
                    Button {
                        showingAddIngredient = true
                    } label: {
                        Label("Ajouter un ingrédient", systemImage: "plus.circle.fill")
                            .foregroundStyle(Color.shabGold)
                    }
                } header: {
                    Text("Ingrédients")
                }
                
                // Instructions Section
                Section {
                    ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .foregroundStyle(Color.shabGold)
                                .fontWeight(.semibold)
                            Text(instruction)
                        }
                    }
                    .onDelete(perform: deleteInstruction)
                    
                    HStack {
                        TextField("Nouvelle étape...", text: $newInstruction, axis: .vertical)
                            .lineLimit(1...3)
                        
                        Button {
                            if !newInstruction.isEmpty {
                                instructions.append(newInstruction)
                                newInstruction = ""
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(newInstruction.isEmpty ? .secondary : Color.shabGold)
                        }
                        .disabled(newInstruction.isEmpty)
                    }
                } header: {
                    Text("Instructions")
                }
            }
            .navigationTitle("Nouvelle Recette")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Créer") {
                        createRecipe()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddIngredient) {
                AddIngredientSheet { ingredient in
                    ingredients.append(ingredient)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $selectedImage, sourceType: .camera)
            }
            .confirmationDialog("Ajouter une photo", isPresented: $showingPhotoOptions) {
                Button("Prendre une photo") {
                    showingCamera = true
                }
                Button("Choisir dans la galerie") {
                    showingImagePicker = true
                }
                Button("Annuler", role: .cancel) {}
            }
        }
    }
    
    private func formatIngredientQuantity(_ ingredient: EditableIngredient) -> String {
        if ingredient.quantity.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(ingredient.quantity)) \(ingredient.unit)"
        }
        return String(format: "%.1f %@", ingredient.quantity, ingredient.unit)
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    private func deleteInstruction(at offsets: IndexSet) {
        instructions.remove(atOffsets: offsets)
    }
    
    private func createRecipe() {
        let recipe = Recipe(
            name: name,
            description: description,
            category: category,
            kashroutType: kashroutType,
            prepTime: prepTime,
            cookTime: cookTime,
            servings: servings
        )
        
        // Add photo
        if let image = selectedImage {
            recipe.imageData = image.jpegData(compressionQuality: 0.7)
        }
        
        // Add ingredients
        recipe.ingredients = ingredients.map { ing in
            Ingredient(name: ing.name, quantity: ing.quantity, unit: ing.unit)
        }
        
        // Add instructions
        recipe.instructions = instructions
        
        modelContext.insert(recipe)
        dismiss()
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.image = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.image = originalImage
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Edit Recipe Sheet
struct EditRecipeSheet: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var recipe: Recipe
    
    @State private var name: String
    @State private var description: String
    @State private var category: RecipeCategory
    @State private var kashroutType: KashroutType
    @State private var prepTime: Int
    @State private var cookTime: Int
    @State private var servings: Int
    
    // Photo
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingPhotoOptions = false
    
    // Ingredients
    @State private var ingredients: [EditableIngredient] = []
    @State private var showingAddIngredient = false
    
    // Instructions
    @State private var instructions: [String] = []
    @State private var newInstruction = ""
    
    struct EditableIngredient: Identifiable {
        let id = UUID()
        var name: String
        var quantity: Double
        var unit: String
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self._name = State(initialValue: recipe.name)
        self._description = State(initialValue: recipe.descriptionText)
        self._category = State(initialValue: recipe.category)
        self._kashroutType = State(initialValue: recipe.kashroutType)
        self._prepTime = State(initialValue: recipe.prepTime)
        self._cookTime = State(initialValue: recipe.cookTime)
        self._servings = State(initialValue: recipe.servings)
        self._ingredients = State(initialValue: recipe.ingredients.map { ing in
            EditableIngredient(name: ing.name, quantity: ing.quantity, unit: ing.unit)
        })
        self._instructions = State(initialValue: recipe.instructions)
        
        // Load existing image
        if let imageData = recipe.imageData, let uiImage = UIImage(data: imageData) {
            self._selectedImage = State(initialValue: uiImage)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Photo Section
                Section {
                    Button {
                        showingPhotoOptions = true
                    } label: {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 180)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(alignment: .topTrailing) {
                                    Button {
                                        selectedImage = nil
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundStyle(.white)
                                            .shadow(radius: 2)
                                    }
                                    .padding(8)
                                }
                        } else if let imageName = recipe.imageURL, !imageName.isEmpty,
                                  let uiImage = UIImage(named: imageName) {
                            // Show asset image with option to replace
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 180)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(alignment: .bottomTrailing) {
                                    Text("Appuyer pour modifier")
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Capsule())
                                        .padding(8)
                                }
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(Color.shabGold)
                                Text("Ajouter une photo")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .buttonStyle(.plain)
                } header: {
                    Text("Photo")
                }
                
                Section("Informations") {
                    TextField("Nom de la recette", text: $name)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Catégorie") {
                    Picker("Type", selection: $category) {
                        ForEach(RecipeCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                    
                    Picker("Cacheroute", selection: $kashroutType) {
                        ForEach(KashroutType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                Section("Temps") {
                    Stepper("Préparation: \(prepTime) min", value: $prepTime, in: 0...180, step: 5)
                    Stepper("Cuisson: \(cookTime) min", value: $cookTime, in: 0...1440, step: 15)
                }
                
                Section("Portions") {
                    Stepper("\(servings) personnes", value: $servings, in: 1...50)
                }
                
                // Ingredients Section
                Section {
                    ForEach(ingredients) { ingredient in
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            Text(formatIngredientQuantity(ingredient))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deleteIngredient)
                    
                    Button {
                        showingAddIngredient = true
                    } label: {
                        Label("Ajouter un ingrédient", systemImage: "plus.circle.fill")
                            .foregroundStyle(Color.shabGold)
                    }
                } header: {
                    Text("Ingrédients")
                }
                
                // Instructions Section
                Section {
                    ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .foregroundStyle(Color.shabGold)
                                .fontWeight(.semibold)
                            Text(instruction)
                        }
                    }
                    .onDelete(perform: deleteInstruction)
                    
                    HStack {
                        TextField("Nouvelle étape...", text: $newInstruction, axis: .vertical)
                            .lineLimit(1...3)
                        
                        Button {
                            if !newInstruction.isEmpty {
                                instructions.append(newInstruction)
                                newInstruction = ""
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(newInstruction.isEmpty ? .secondary : Color.shabGold)
                        }
                        .disabled(newInstruction.isEmpty)
                    }
                } header: {
                    Text("Instructions")
                }
            }
            .navigationTitle("Modifier la recette")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        saveRecipe()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddIngredient) {
                EditIngredientSheet { ingredient in
                    ingredients.append(EditableIngredient(
                        name: ingredient.name,
                        quantity: ingredient.quantity,
                        unit: ingredient.unit
                    ))
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $selectedImage, sourceType: .camera)
            }
            .confirmationDialog("Modifier la photo", isPresented: $showingPhotoOptions) {
                Button("Prendre une photo") {
                    showingCamera = true
                }
                Button("Choisir dans la galerie") {
                    showingImagePicker = true
                }
                if selectedImage != nil || recipe.imageData != nil {
                    Button("Supprimer la photo", role: .destructive) {
                        selectedImage = nil
                    }
                }
                Button("Annuler", role: .cancel) {}
            }
        }
    }
    
    private func formatIngredientQuantity(_ ingredient: EditableIngredient) -> String {
        if ingredient.quantity.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(ingredient.quantity)) \(ingredient.unit)"
        }
        return String(format: "%.1f %@", ingredient.quantity, ingredient.unit)
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    private func deleteInstruction(at offsets: IndexSet) {
        instructions.remove(atOffsets: offsets)
    }
    
    private func saveRecipe() {
        recipe.name = name
        recipe.descriptionText = description
        recipe.category = category
        recipe.kashroutType = kashroutType
        recipe.prepTime = prepTime
        recipe.cookTime = cookTime
        recipe.servings = servings
        
        // Update photo
        if let image = selectedImage {
            recipe.imageData = image.jpegData(compressionQuality: 0.7)
        } else if selectedImage == nil && recipe.imageData != nil {
            // User removed the photo
            recipe.imageData = nil
        }
        
        // Update ingredients
        recipe.ingredients = ingredients.map { ing in
            Ingredient(name: ing.name, quantity: ing.quantity, unit: ing.unit)
        }
        
        // Update instructions
        recipe.instructions = instructions
        
        dismiss()
    }
}

// MARK: - Edit Ingredient Sheet (for EditRecipeSheet)
struct EditIngredientSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var quantity: Double = 1
    @State private var unit = "pièces"
    
    let onAdd: (Ingredient) -> Void
    
    let commonUnits = ["pièces", "g", "kg", "ml", "L", "c. à soupe", "c. à café", "bouquet", "gousse"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Ingrédient") {
                    TextField("Nom de l'ingrédient", text: $name)
                }
                
                Section("Quantité") {
                    HStack {
                        TextField("Quantité", value: $quantity, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                        
                        Spacer()
                        
                        Picker("Unité", selection: $unit) {
                            ForEach(commonUnits, id: \.self) { unit in
                                Text(unit).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .navigationTitle("Nouvel ingrédient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let ingredient = Ingredient(
                            name: name,
                            quantity: quantity,
                            unit: unit
                        )
                        onAdd(ingredient)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Add Ingredient Sheet
struct AddIngredientSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var quantity: Double = 1
    @State private var unit = "pièces"
    
    let onAdd: (AddRecipeSheet.EditableIngredient) -> Void
    
    let commonUnits = ["pièces", "g", "kg", "ml", "L", "c. à soupe", "c. à café", "bouquet", "gousse"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Ingrédient") {
                    TextField("Nom de l'ingrédient", text: $name)
                }
                
                Section("Quantité") {
                    HStack {
                        TextField("Quantité", value: $quantity, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                        
                        Spacer()
                        
                        Picker("Unité", selection: $unit) {
                            ForEach(commonUnits, id: \.self) { unit in
                                Text(unit).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .navigationTitle("Nouvel ingrédient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let ingredient = AddRecipeSheet.EditableIngredient(
                            name: name,
                            quantity: quantity,
                            unit: unit
                        )
                        onAdd(ingredient)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Halla Timer Sheet
struct HallaTimerSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var notificationManager: NotificationManager
    
    @State private var selectedPhase: HallaPhase = .rising
    @State private var customMinutes = 90
    @State private var isTimerRunning = false
    @State private var remainingTime: TimeInterval = 0
    @State private var timer: Timer?
    
    enum HallaPhase: String, CaseIterable {
        case rising = "Première levée"
        case secondRise = "Deuxième levée"
        case hafrashatHalla = "Hafrachat Halla"
        case baking = "Cuisson"
        
        var defaultMinutes: Int {
            switch self {
            case .rising: return 90
            case .secondRise: return 30
            case .hafrashatHalla: return 5
            case .baking: return 35
            }
        }
        
        var icon: String {
            switch self {
            case .rising: return "arrow.up.circle"
            case .secondRise: return "arrow.up.circle.fill"
            case .hafrashatHalla: return "hands.sparkles"
            case .baking: return "flame"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "oval.portrait")
                        .font(.system(size: 50))
                        .foregroundStyle(Color.shabGold)
                    Text("Timer Halla")
                        .font(.title2.bold())
                }
                .padding(.top, 20)
                
                // Phase Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Étape")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(HallaPhase.allCases, id: \.self) { phase in
                                PhaseButton(
                                    phase: phase,
                                    isSelected: selectedPhase == phase
                                ) {
                                    selectedPhase = phase
                                    customMinutes = phase.defaultMinutes
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Timer Display
                if isTimerRunning {
                    VStack(spacing: 16) {
                        Text(formatTime(remainingTime))
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.shabGold)
                        
                        Text(selectedPhase.rawValue)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Button {
                            stopTimer()
                        } label: {
                            Label("Arrêter", systemImage: "stop.fill")
                        }
                        .buttonStyle(LiquidGlassButtonStyle())
                    }
                } else {
                    // Time Selector
                    VStack(spacing: 20) {
                        Text("Durée")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 20) {
                            Button {
                                if customMinutes > 5 {
                                    customMinutes -= 5
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(Color.shabGold)
                            }
                            
                            Text("\(customMinutes) min")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .frame(width: 150)
                            
                            Button {
                                customMinutes += 5
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(Color.shabGold)
                            }
                        }
                        
                        Button {
                            startTimer()
                        } label: {
                            Label("Démarrer", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(LiquidGlassButtonStyle(isAccent: true))
                        .padding(.horizontal, 40)
                    }
                }
                
                Spacer()
                
                // Tips
                VStack(alignment: .leading, spacing: 8) {
                    Label("Conseil", systemImage: "lightbulb.fill")
                        .font(.caption.bold())
                        .foregroundStyle(Color.shabGold)
                    
                    Text(tipForPhase(selectedPhase))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.shabGold.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fermer") { dismiss() }
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        remainingTime = TimeInterval(customMinutes * 60)
        isTimerRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                stopTimer()
                HapticManager.notification(.success)
            }
        }
        
        // Schedule notification
        let targetDate = Date().addingTimeInterval(TimeInterval(customMinutes * 60))
        Task {
            await notificationManager.scheduleHallaReminder(for: targetDate, phase: selectedPhase.rawValue)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    private func tipForPhase(_ phase: HallaPhase) -> String {
        switch phase {
        case .rising:
            return "Couvrez la pâte avec un torchon humide et placez-la dans un endroit tiède, à l'abri des courants d'air."
        case .secondRise:
            return "Après avoir tressé vos hallot, laissez-les lever une seconde fois pour obtenir une texture moelleuse."
        case .hafrashatHalla:
            return "Si vous utilisez plus de 1,2kg de farine, c'est le moment de prélever la Halla avec la bénédiction."
        case .baking:
            return "Préchauffez votre four à 180°C. Les hallot sont prêtes quand elles sonnent creux en tapotant dessous."
        }
    }
}

// MARK: - Phase Button
struct PhaseButton: View {
    let phase: HallaTimerSheet.HallaPhase
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: phase.icon)
                    .font(.title3)
                Text(phase.rawValue)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.shabGold.opacity(0.2) : Color(UIColor.secondarySystemBackground))
            }
            .foregroundStyle(isSelected ? Color.shabGold : .primary)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Recipe Share Sheet
struct RecipeShareSheet: UIViewControllerRepresentable {
    let text: String
    let recipeName: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityItems: [Any] = [text]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.assignToContact, .addToReadingList]
        return activityVC
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Content View (sans NavigationStack pour MainTabView)
struct RecipesContentView: View {
    var body: some View {
        RecipesView()
            .navigationBarHidden(true)
    }
}

// MARK: - Swipe Back Gesture Enabler
struct SwipeBackGestureEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = SwipeBackViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class SwipeBackViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Réactiver le swipe back même quand la navbar est cachée
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

#Preview {
    RecipesView()
        .environmentObject(AppState())
        .environmentObject(NotificationManager())
        .modelContainer(for: Recipe.self, inMemory: true)
}
