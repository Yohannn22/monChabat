//
//  Models.swift
//  monChabat
//
//  Modèles de données pour l'application
//

import SwiftUI
import SwiftData
import Foundation

// MARK: - Checklist Item
@Model
final class ChecklistItem {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var category: ChecklistCategory
    var isVital: Bool // Pour le Mode Panique
    var order: Int
    var createdAt: Date
    var isRecurring: Bool
    var icon: String? // SF Symbol name (optional for migration)
    
    var displayIcon: String {
        icon ?? "checklist"
    }
    
    init(
        title: String,
        category: ChecklistCategory = .preparation,
        isVital: Bool = false,
        order: Int = 0,
        isRecurring: Bool = true,
        icon: String = "checklist"
    ) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.category = category
        self.isVital = isVital
        self.order = order
        self.createdAt = Date()
        self.isRecurring = isRecurring
        self.icon = icon
    }
}

enum ChecklistCategory: String, Codable, CaseIterable {
    case preparation = "Préparation"
    case cuisine = "Cuisine"
    case maison = "Maison"
    case courses = "Courses"
    case spirituel = "Spirituel"
    
    var icon: String {
        switch self {
        case .preparation: return "checklist"
        case .cuisine: return "frying.pan"
        case .maison: return "house"
        case .courses: return "cart"
        case .spirituel: return "sparkles"
        }
    }
    
    var color: Color {
        switch self {
        case .preparation: return .shabGold
        case .cuisine: return .shabCandleOrange
        case .maison: return .shabDeepBlue
        case .courses: return .parveGreen
        case .spirituel: return .shabSoftPurple
        }
    }
}

// MARK: - Shopping Item
@Model
final class ShoppingItem {
    var id: UUID
    var name: String
    var quantity: String
    var category: ShoppingCategory
    var isChecked: Bool
    var linkedRecipeId: UUID?
    var notes: String?
    
    init(
        name: String,
        quantity: String = "",
        category: ShoppingCategory = .epicerie,
        linkedRecipeId: UUID? = nil,
        notes: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.quantity = quantity
        self.category = category
        self.isChecked = false
        self.linkedRecipeId = linkedRecipeId
        self.notes = notes
    }
}

enum ShoppingCategory: String, Codable, CaseIterable {
    case viande = "Viande"
    case lait = "Lait"
    case parve = "Parvé"
    case epicerie = "Épicerie"
    case menage = "Ménage"
    case autre = "Autre"
    
    var icon: String {
        switch self {
        case .viande: return "fork.knife"
        case .lait: return "cup.and.saucer"
        case .parve: return "leaf"
        case .epicerie: return "basket"
        case .menage: return "sparkles"
        case .autre: return "ellipsis.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .viande: return .meatRed
        case .lait: return .dairyBlue
        case .parve: return .parveGreen
        case .epicerie: return .shabGold
        case .menage: return .purple
        case .autre: return .gray
        }
    }
}

// MARK: - Meal Plan
@Model
final class MealPlan {
    var id: UUID
    var weekStartDate: Date
    var fridayDinnerRecipes: [UUID]
    var saturdayLunchRecipes: [UUID]
    var seoudaChlichitRecipes: [UUID]
    var notes: String?
    
    init(weekStartDate: Date = Date()) {
        self.id = UUID()
        self.weekStartDate = weekStartDate
        self.fridayDinnerRecipes = []
        self.saturdayLunchRecipes = []
        self.seoudaChlichitRecipes = []
    }
}

enum MealType: String, CaseIterable {
    case fridayDinner = "Vendredi Soir"
    case saturdayLunch = "Samedi Midi"
    case seoudaChlichit = "Séouda Chlichit"
    
    var icon: String {
        switch self {
        case .fridayDinner: return "moon.stars"
        case .saturdayLunch: return "sun.max"
        case .seoudaChlichit: return "sunset"
        }
    }
}

// MARK: - Guest
@Model
final class Guest {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String?
    var phone: String?
    var allergies: [String]
    var dietaryRestrictions: DietaryRestriction
    var kashroutLevel: KashroutLevel
    var notes: String?
    var isConfirmed: Bool
    var invitedMeals: [String] // MealType raw values
    var tablePosition: Int? // Position à la table (nil = pas encore placé)
    var isFamily: Bool = false // true = membre de la famille (récurrent), false = invité ponctuel
    
    init(
        firstName: String,
        lastName: String,
        email: String? = nil,
        phone: String? = nil,
        dietaryRestrictions: DietaryRestriction = .none,
        kashroutLevel: KashroutLevel = .standard
    ) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.allergies = []
        self.dietaryRestrictions = dietaryRestrictions
        self.kashroutLevel = kashroutLevel
        self.notes = nil
        self.isConfirmed = false
        self.invitedMeals = []
        self.tablePosition = nil
        self.isFamily = false
    }
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

enum DietaryRestriction: String, Codable, CaseIterable {
    case none = "Aucune"
    case vegetarian = "Végétarien"
    case vegan = "Végan"
    case glutenFree = "Sans Gluten"
    case lactoseFree = "Sans Lactose"
}

enum KashroutLevel: String, Codable, CaseIterable {
    case standard = "Standard"
    case strict = "Strict (Mehadrin)"
    case chalakBeitYossef = "Chalak Beit Yossef"
    case flexible = "Flexible"
}

// MARK: - Table Seat
@Model
final class TableSeat {
    var id: UUID
    var position: Int
    var guestId: UUID?
    var tableId: UUID
    
    init(position: Int, tableId: UUID, guestId: UUID? = nil) {
        self.id = UUID()
        self.position = position
        self.tableId = tableId
        self.guestId = guestId
    }
}

// MARK: - Recipe
@Model
final class Recipe {
    var id: UUID
    var name: String
    var descriptionText: String
    var ingredients: [Ingredient]
    var instructions: [String]
    var prepTime: Int // minutes
    var cookTime: Int // minutes
    var servings: Int
    var category: RecipeCategory
    var kashroutType: KashroutType
    var imageURL: String?
    var imageData: Data? // For user-added photos
    var isFavorite: Bool
    var source: String?
    
    init(
        name: String,
        description: String = "",
        category: RecipeCategory = .plat,
        kashroutType: KashroutType = .parve,
        prepTime: Int = 0,
        cookTime: Int = 0,
        servings: Int = 4
    ) {
        self.id = UUID()
        self.name = name
        self.descriptionText = description
        self.ingredients = []
        self.instructions = []
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.servings = servings
        self.category = category
        self.kashroutType = kashroutType
        self.isFavorite = false
    }
}

struct Ingredient: Codable, Hashable {
    var name: String
    var quantity: Double
    var unit: String
    
    func scaled(for newServings: Int, originalServings: Int) -> Ingredient {
        let ratio = Double(newServings) / Double(originalServings)
        return Ingredient(name: name, quantity: quantity * ratio, unit: unit)
    }
}

enum RecipeCategory: String, Codable, CaseIterable {
    case entree = "Entrée"
    case plat = "Plat Principal"
    case accompagnement = "Accompagnement"
    case dessert = "Dessert"
    case pain = "Pain & Hallot"
    case boisson = "Boisson"
    
    var icon: String {
        switch self {
        case .entree: return "leaf.circle"
        case .plat: return "flame.circle"
        case .accompagnement: return "square.grid.2x2"
        case .dessert: return "birthday.cake"
        case .pain: return "oval.portrait"
        case .boisson: return "cup.and.saucer"
        }
    }
}

enum KashroutType: String, Codable, CaseIterable {
    case viande = "Viande"
    case lait = "Lait"
    case parve = "Parvé"
    
    var color: Color {
        switch self {
        case .viande: return .meatRed
        case .lait: return .dairyBlue
        case .parve: return .parveGreen
        }
    }
}

// MARK: - Zmanim (Horaires)
struct Zmanim: Codable {
    let date: Date
    let location: String
    let candleLighting: Date
    let havdalah: Date
    let sunrise: Date
    let sunset: Date
    let chatzot: Date // Midi halakhique
    let plagHaMincha: Date
    let shkia: Date
    let sofZmanShma: Date
    let sofZmanTfilla: Date
}

// MARK: - Parasha
struct Parasha: Codable, Identifiable {
    var id: String { hebrew }
    let hebrew: String
    let english: String
    let book: String
    let summary: String?
    let keyPoints: [String]?
    let quizQuestions: [QuizQuestion]?
}

struct QuizQuestion: Codable, Identifiable {
    var id: UUID { UUID() }
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String?
}

// MARK: - Prayer/Song
struct Prayer: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let hebrewName: String
    let category: PrayerCategory
    let textAshkenaz: String?
    let textSefarad: String?
    let transliteration: String?
    let translation: String?
}

enum PrayerCategory: String, Codable, CaseIterable {
    case kiddush = "Kiddouch"
    case birkatHamazon = "Birkat Hamazon"
    case zemirot = "Zemirot"
    case havdalah = "Havdalah"
    case other = "Autre"
}

// MARK: - Halla Timer
struct HallaTimer: Codable {
    var startTime: Date
    var targetTime: Date
    var phase: HallaPhase
    var isActive: Bool
    
    enum HallaPhase: String, Codable {
        case rising = "Levée de la pâte"
        case secondRise = "Deuxième levée"
        case hafrashatHalla = "Hafrachat Halla"
        case baking = "Cuisson"
    }
}

// MARK: - Default Data
struct DefaultData {
    static let checklistItems: [(String, ChecklistCategory, Bool)] = [
        ("Mettre la plata", .cuisine, true),
        ("Préparer les hallot", .cuisine, true),
        ("Régler la minuterie des lumières", .maison, true),
        ("Dévisser l'ampoule du frigo", .maison, true),
        ("Préparer les bougies", .preparation, true),
        ("Préparer les mouchoirs prédécoupés", .preparation, false),
        ("Couvrir la table de Chabat", .maison, false),
        ("Préparer le vin pour le Kiddouch", .preparation, false),
        ("Vérifier les plats sur la plata", .cuisine, false),
        ("Préparer les vêtements de Chabat", .preparation, false),
        ("Prendre une douche avant Chabat", .preparation, false),
        ("Faire les courses de dernière minute", .courses, false)
    ]
    
    static let classicRecipes: [Recipe] = {
        var recipes: [Recipe] = []
        
        let dafina = Recipe(
            name: "Dafina Marocaine",
            description: "Le plat traditionnel du Chabat marocain, mijoté toute la nuit",
            category: .plat,
            kashroutType: .viande,
            prepTime: 45,
            cookTime: 720,
            servings: 8
        )
        
        let cholent = Recipe(
            name: "Cholent Ashkénaze",
            description: "Ragoût traditionnel ashkénaze avec haricots, orge et viande",
            category: .plat,
            kashroutType: .viande,
            prepTime: 30,
            cookTime: 600,
            servings: 8
        )
        
        let hallot = Recipe(
            name: "Hallot Tressées",
            description: "Pains tressés traditionnels pour le Chabat",
            category: .pain,
            kashroutType: .parve,
            prepTime: 30,
            cookTime: 35,
            servings: 2
        )
        
        recipes = [dafina, cholent, hallot]
        return recipes
    }()
}
