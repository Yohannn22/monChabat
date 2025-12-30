//
//  ParashotSummaries.swift
//  monChabat
//
//  Résumés de toutes les Parachiot de la Torah
//

import Foundation

struct ParashaSummary {
    let name: String
    let hebrewName: String
    let book: TorahBook
    let summary: String
    let keyVerses: [String]
    let themes: [String]
}

enum TorahBook: String, CaseIterable {
    case bereshit = "Livre de Berechit"
    case shemot = "Livre de Chemot"
    case vayikra = "Livre de Vayikra"
    case bamidbar = "Livre de Bamidbar"
    case devarim = "Livre de Devarim"
    
    var hebrewName: String {
        switch self {
        case .bereshit: return "בראשית"
        case .shemot: return "שמות"
        case .vayikra: return "ויקרא"
        case .bamidbar: return "במדבר"
        case .devarim: return "דברים"
        }
    }
}

// MARK: - Parachiot Database
struct ParashotDatabase {
    
    static let summaries: [String: ParashaSummary] = [
        // ========================================
        // BERECHIT (Genèse)
        // ========================================
        
        "Bereshit": ParashaSummary(
            name: "Bereshit",
            hebrewName: "בראשית",
            book: .bereshit,
            summary: "D.ieu crée le monde en six jours et se repose le septième (Chabbat). Adam et Ève sont placés au Jardin d'Éden mais en sont chassés après avoir mangé du fruit défendu. Caïn tue son frère Abel. L'humanité se corrompt, menant au déluge.",
            keyVerses: ["Au commencement, D.ieu créa le ciel et la terre (1:1)", "Il n'est pas bon que l'homme soit seul (2:18)"],
            themes: ["Création", "Chabbat", "Libre arbitre", "Conséquences des actes"]
        ),
        
        "Noach": ParashaSummary(
            name: "Noach",
            hebrewName: "נח",
            book: .bereshit,
            summary: "Noé, homme juste dans sa génération, construit une arche sur ordre divin pour survivre au déluge. Après le déluge, D.ieu établit une alliance avec l'humanité (arc-en-ciel). La Tour de Babel est construite et les langues sont confondues.",
            keyVerses: ["Noé était un homme juste, intègre parmi ses contemporains (6:9)", "Je mets Mon arc dans la nuée (9:13)"],
            themes: ["Justice", "Renouveau", "Alliance", "Orgueil humain"]
        ),
        
        "Lech-Lecha": ParashaSummary(
            name: "Lech-Lecha",
            hebrewName: "לך לך",
            book: .bereshit,
            summary: "D.ieu ordonne à Avram de quitter sa terre natale pour Canaan. Avram et Saraï voyagent et font face à des épreuves. D.ieu promet à Avram une descendance nombreuse. Avram devient Abraham après la Brit Mila (circoncision).",
            keyVerses: ["Va pour toi, de ton pays... vers le pays que Je te montrerai (12:1)", "Je ferai de toi une grande nation (12:2)"],
            themes: ["Foi", "Épreuve", "Alliance", "Destinée du peuple juif"]
        ),
        
        "Vayera": ParashaSummary(
            name: "Vayera",
            hebrewName: "וירא",
            book: .bereshit,
            summary: "Abraham accueille trois anges qui annoncent la naissance d'Isaac. Sodome et Gomorrhe sont détruites. Isaac naît et Ismaël est renvoyé. L'épreuve suprême : la ligature d'Isaac (Akédat Yitzhak).",
            keyVerses: ["Y a-t-il une chose impossible pour D.ieu ? (18:14)", "Maintenant je sais que tu crains D.ieu (22:12)"],
            themes: ["Hospitalité", "Justice divine", "Foi absolue", "Épreuve"]
        ),
        
        "Chayei Sarah": ParashaSummary(
            name: "Chayei Sarah",
            hebrewName: "חיי שרה",
            book: .bereshit,
            summary: "Sarah meurt à 127 ans. Abraham achète la grotte de Makhpéla pour l'enterrer. Eliézer est envoyé chercher une épouse pour Isaac et rencontre Rébecca au puits. Abraham meurt et est enterré à Makhpéla.",
            keyVerses: ["La vie de Sarah fut de 127 ans (23:1)", "Isaac l'introduisit dans la tente de Sarah sa mère (24:67)"],
            themes: ["Honorer les morts", "Mariage", "Continuité", "Providence"]
        ),
        
        "Toldot": ParashaSummary(
            name: "Toldot",
            hebrewName: "תולדות",
            book: .bereshit,
            summary: "Jacob et Ésaü naissent. Ésaü vend son droit d'aînesse pour un plat de lentilles. Rébecca aide Jacob à obtenir la bénédiction d'Isaac. Jacob fuit vers Haran pour échapper à la colère d'Ésaü.",
            keyVerses: ["Deux nations sont dans ton ventre (25:23)", "La voix est celle de Jacob, mais les mains sont celles d'Ésaü (27:22)"],
            themes: ["Destinée", "Bénédiction", "Rivalité fraternelle", "Valeurs spirituelles vs matérielles"]
        ),
        
        "Vayetzei": ParashaSummary(
            name: "Vayetzei",
            hebrewName: "ויצא",
            book: .bereshit,
            summary: "Jacob rêve de l'échelle avec les anges. Il travaille 14 ans pour épouser Rachel et Léa. Les 12 tribus naissent (11 fils et 1 fille). Jacob prospère et décide de retourner en Canaan.",
            keyVerses: ["Voici, une échelle posée sur la terre, et son sommet atteignait le ciel (28:12)", "Je suis avec toi, Je te garderai partout où tu iras (28:15)"],
            themes: ["Exil et retour", "Travail", "Construction de la famille juive", "Providence divine"]
        ),
        
        "Vayishlach": ParashaSummary(
            name: "Vayishlach",
            hebrewName: "וישלח",
            book: .bereshit,
            summary: "Jacob se prépare à rencontrer Ésaü et lutte avec un ange, recevant le nom 'Israël'. La réconciliation avec Ésaü. Dina est enlevée et ses frères vengent son honneur. Rachel meurt en donnant naissance à Benjamin.",
            keyVerses: ["Ton nom ne sera plus Jacob, mais Israël (32:29)", "J'ai vu D.ieu face à face et ma vie a été préservée (32:31)"],
            themes: ["Transformation", "Réconciliation", "Épreuves", "Identité"]
        ),
        
        "Vayeshev": ParashaSummary(
            name: "Vayeshev",
            hebrewName: "וישב",
            book: .bereshit,
            summary: "Joseph, fils préféré de Jacob, reçoit une tunique colorée et raconte ses rêves. Ses frères le vendent comme esclave. En Égypte, il est acheté par Potiphar puis emprisonné injustement. Il interprète les rêves des officiers du Pharaon.",
            keyVerses: ["Israël aimait Joseph plus que tous ses fils (37:3)", "D.ieu était avec Joseph (39:2)"],
            themes: ["Jalousie", "Exil", "Foi dans l'adversité", "Providence"]
        ),
        
        "Miketz": ParashaSummary(
            name: "Miketz",
            hebrewName: "מקץ",
            book: .bereshit,
            summary: "Joseph interprète les rêves de Pharaon (7 vaches grasses, 7 vaches maigres) et devient vice-roi d'Égypte. La famine frappe et les frères de Joseph viennent acheter du blé. Joseph les reconnaît mais se cache d'eux.",
            keyVerses: ["Ce n'est pas moi, c'est D.ieu qui donnera une réponse favorable à Pharaon (41:16)"],
            themes: ["Sagesse", "Élévation", "Test", "Pardon"]
        ),
        
        "Vayigash": ParashaSummary(
            name: "Vayigash",
            hebrewName: "ויגש",
            book: .bereshit,
            summary: "Juda plaide pour Benjamin. Joseph se révèle à ses frères : 'Je suis Joseph !'. Émouvantes retrouvailles. Jacob et toute sa famille descendent en Égypte. Ils s'installent au pays de Goshen.",
            keyVerses: ["Je suis Joseph, mon père vit-il encore ? (45:3)", "Ce n'est pas vous qui m'avez envoyé ici, c'est D.ieu (45:8)"],
            themes: ["Réconciliation", "Pardon", "Providence divine", "Unité familiale"]
        ),
        
        "Vayechi": ParashaSummary(
            name: "Vayechi",
            hebrewName: "ויחי",
            book: .bereshit,
            summary: "Jacob bénit Éphraïm et Manassé, puis chacun de ses 12 fils avec des bénédictions prophétiques. Jacob meurt et est enterré à Makhpéla. Joseph rassure ses frères et meurt à 110 ans.",
            keyVerses: ["Que l'ange qui m'a délivré de tout mal bénisse ces enfants (48:16)", "Rassemblez-vous et je vous dirai ce qui vous arrivera à la fin des jours (49:1)"],
            themes: ["Bénédiction", "Transmission", "Prophétie", "Fin de l'ère des Patriarches"]
        ),
        
        // ========================================
        // CHEMOT (Exode)
        // ========================================
        
        "Shemot": ParashaSummary(
            name: "Shemot",
            hebrewName: "שמות",
            book: .shemot,
            summary: "Les Hébreux se multiplient en Égypte et Pharaon les asservit. Moïse naît, est sauvé des eaux, grandit au palais, puis fuit après avoir tué un Égyptien. Au buisson ardent, D.ieu lui confie la mission de libérer le peuple.",
            keyVerses: ["Je suis Celui qui suis (3:14)", "Laisse partir Mon peuple ! (5:1)"],
            themes: ["Esclavage", "Libération", "Appel divin", "Leadership"]
        ),
        
        "Vaera": ParashaSummary(
            name: "Vaera",
            hebrewName: "וארא",
            book: .shemot,
            summary: "D.ieu renforce Moïse et lui révèle Son Nom. Les sept premières plaies frappent l'Égypte : sang, grenouilles, vermine, bêtes sauvages, peste, ulcères, grêle. Pharaon endurcit son cœur.",
            keyVerses: ["Je suis l'Éternel (6:2)", "Par ceci tu sauras que Je suis l'Éternel (7:17)"],
            themes: ["Révélation divine", "Jugement", "Endurcissement", "Miracles"]
        ),
        
        "Bo": ParashaSummary(
            name: "Bo",
            hebrewName: "בא",
            book: .shemot,
            summary: "Les trois dernières plaies : sauterelles, ténèbres, mort des premiers-nés. Institution de Pessa'h : l'agneau pascal, les Matzot, le récit de la sortie. Les Hébreux quittent l'Égypte après 430 ans.",
            keyVerses: ["Ce mois sera pour vous le commencement des mois (12:2)", "Tu raconteras à ton fils (13:8)"],
            themes: ["Libération", "Mémoire", "Transmission", "Naissance du peuple"]
        ),
        
        "Beshalach": ParashaSummary(
            name: "Beshalach",
            hebrewName: "בשלח",
            book: .shemot,
            summary: "Pharaon poursuit les Hébreux. La mer se fend miraculeusement. Le cantique de la mer (Chirat HaYam). Dans le désert : la manne, les cailles, l'eau du rocher. Combat contre Amalek.",
            keyVerses: ["L'Éternel combattra pour vous (14:14)", "Qui est comme Toi parmi les puissants, ô Éternel ? (15:11)"],
            themes: ["Miracle", "Foi", "Gratitude", "Épreuves du désert"]
        ),
        
        "Yitro": ParashaSummary(
            name: "Yitro",
            hebrewName: "יתרו",
            book: .shemot,
            summary: "Jethro, beau-père de Moïse, le conseille sur l'organisation judiciaire. Le peuple arrive au Sinaï. Révélation divine et don des Dix Commandements. Le peuple tremble devant la manifestation divine.",
            keyVerses: ["Vous serez pour Moi un royaume de prêtres et une nation sainte (19:6)", "Je suis l'Éternel ton D.ieu (20:2)"],
            themes: ["Révélation", "Alliance", "Dix Commandements", "Mission du peuple juif"]
        ),
        
        "Mishpatim": ParashaSummary(
            name: "Mishpatim",
            hebrewName: "משפטים",
            book: .shemot,
            summary: "Lois civiles et pénales : esclavage, dommages, prêts, justice, fêtes. Le peuple déclare 'Naassé véNichma' (nous ferons et nous écouterons). Moïse monte sur la montagne pendant 40 jours.",
            keyVerses: ["Nous ferons et nous écouterons (24:7)", "Tu ne suivras pas la multitude pour faire le mal (23:2)"],
            themes: ["Justice sociale", "Lois civiles", "Engagement", "Éthique"]
        ),
        
        "Terumah": ParashaSummary(
            name: "Terumah",
            hebrewName: "תרומה",
            book: .shemot,
            summary: "Instructions pour la construction du Michkan (Tabernacle). Description de l'Arche d'Alliance, de la Table, du Chandelier (Ménorah), et de la structure du sanctuaire.",
            keyVerses: ["Ils Me feront un sanctuaire et Je résiderai parmi eux (25:8)"],
            themes: ["Sanctuaire", "Générosité", "Présence divine", "Artisanat sacré"]
        ),
        
        "Tetzaveh": ParashaSummary(
            name: "Tetzaveh",
            hebrewName: "תצוה",
            book: .shemot,
            summary: "Instructions sur les vêtements des Cohanim (prêtres) : l'Éphod, le Pectoral, la Robe, la Tiare. Consécration d'Aaron et de ses fils. L'autel des parfums.",
            keyVerses: ["Tu feras des vêtements sacrés pour Aaron ton frère, pour honneur et splendeur (28:2)"],
            themes: ["Sacerdoce", "Vêtements sacrés", "Service divin", "Sainteté"]
        ),
        
        "Ki Tisa": ParashaSummary(
            name: "Ki Tisa",
            hebrewName: "כי תשא",
            book: .shemot,
            summary: "Le demi-sicle et le recensement. Le veau d'or est fabriqué pendant l'absence de Moïse. Moïse brise les Tables. D.ieu révèle les 13 attributs de miséricorde. Nouvelles Tables.",
            keyVerses: ["Éternel, Éternel, D.ieu miséricordieux et compatissant (34:6)"],
            themes: ["Faute et repentir", "Pardon divin", "Attributs de miséricorde", "Renouvellement"]
        ),
        
        "Vayakhel": ParashaSummary(
            name: "Vayakhel",
            hebrewName: "ויקהל",
            book: .shemot,
            summary: "Moïse rassemble le peuple et rappelle le Chabbat. Le peuple apporte généreusement des matériaux pour le Michkan. Betsalel et Oholiav dirigent la construction.",
            keyVerses: ["Six jours on travaillera, mais le septième jour sera pour vous un jour de sainteté (35:2)"],
            themes: ["Chabbat", "Générosité", "Communauté", "Artisanat sacré"]
        ),
        
        "Pekudei": ParashaSummary(
            name: "Pekudei",
            hebrewName: "פקודי",
            book: .shemot,
            summary: "Inventaire des matériaux du Michkan. Fabrication des vêtements sacerdotaux. Moïse bénit le travail accompli. Érection du Michkan. La nuée divine remplit le sanctuaire.",
            keyVerses: ["La gloire de l'Éternel remplit le Tabernacle (40:34)"],
            themes: ["Achèvement", "Intégrité", "Présence divine", "Bénédiction"]
        ),
        
        // ========================================
        // VAYIKRA (Lévitique)
        // ========================================
        
        "Vayikra": ParashaSummary(
            name: "Vayikra",
            hebrewName: "ויקרא",
            book: .vayikra,
            summary: "D.ieu appelle Moïse depuis le Tabernacle. Lois sur les différents sacrifices : Olah (holocauste), Min'ha (oblation), Chelamim (sacrifice de paix), 'Hatat (expiatoire), Acham (culpabilité).",
            keyVerses: ["L'Éternel appela Moïse (1:1)", "Quand une personne présentera une offrande à l'Éternel (2:1)"],
            themes: ["Sacrifices", "Expiation", "Approche de D.ieu", "Service"]
        ),
        
        "Tzav": ParashaSummary(
            name: "Tzav",
            hebrewName: "צו",
            book: .vayikra,
            summary: "Instructions détaillées aux Cohanim sur la procédure des sacrifices. Le feu perpétuel sur l'autel. Interdiction de consommer graisse et sang. Consécration de sept jours pour Aaron et ses fils.",
            keyVerses: ["Un feu perpétuel brûlera sur l'autel, il ne s'éteindra pas (6:6)"],
            themes: ["Service sacerdotal", "Feu perpétuel", "Sainteté", "Consécration"]
        ),
        
        "Shmini": ParashaSummary(
            name: "Shmini",
            hebrewName: "שמיני",
            book: .vayikra,
            summary: "Le huitième jour de consécration. Nadav et Avihou meurent en offrant un feu étranger. Lois de Cacherout : animaux, poissons, oiseaux et insectes permis et interdits.",
            keyVerses: ["Car Je suis l'Éternel votre D.ieu : sanctifiez-vous et soyez saints (11:44)"],
            themes: ["Sainteté", "Service correct", "Cacherout", "Distinction"]
        ),
        
        "Tazria": ParashaSummary(
            name: "Tazria",
            hebrewName: "תזריע",
            book: .vayikra,
            summary: "Lois de pureté après l'accouchement. La Tsaraat (affection cutanée) : symptômes, diagnostic par le Cohen, et isolement. Tsaraat sur les vêtements.",
            keyVerses: ["Il sera déclaré impur par le Cohen (13:3)"],
            themes: ["Pureté", "Tsaraat", "Parole", "Isolement et réflexion"]
        ),
        
        "Metzora": ParashaSummary(
            name: "Metzora",
            hebrewName: "מצורע",
            book: .vayikra,
            summary: "Purification du Metsora : rituel des deux oiseaux, bain rituel, offrandes. Tsaraat des maisons. Lois sur les impuretés corporelles et leur purification.",
            keyVerses: ["Voici la loi concernant le lépreux au jour de sa purification (14:2)"],
            themes: ["Purification", "Techouva", "Réintégration", "Guérison spirituelle"]
        ),
        
        "Achrei Mot": ParashaSummary(
            name: "Achrei Mot",
            hebrewName: "אחרי מות",
            book: .vayikra,
            summary: "Service de Yom Kippour : entrée du Grand Prêtre dans le Saint des Saints, les deux boucs, confession sur le bouc émissaire. Interdiction du sang. Relations interdites.",
            keyVerses: ["Car en ce jour on fera l'expiation pour vous (16:30)"],
            themes: ["Yom Kippour", "Expiation", "Sainteté", "Kedoucha"]
        ),
        
        "Kedoshim": ParashaSummary(
            name: "Kedoshim",
            hebrewName: "קדושים",
            book: .vayikra,
            summary: "Appel à la sainteté. Lois éthiques fondamentales : respect des parents, Chabbat, honnêteté, justice, 'Tu aimeras ton prochain comme toi-même'. Interdiction du mélange des espèces.",
            keyVerses: ["Soyez saints car Je suis saint, Moi l'Éternel votre D.ieu (19:2)", "Tu aimeras ton prochain comme toi-même (19:18)"],
            themes: ["Sainteté", "Éthique", "Amour du prochain", "Justice sociale"]
        ),
        
        "Emor": ParashaSummary(
            name: "Emor",
            hebrewName: "אמור",
            book: .vayikra,
            summary: "Sainteté des Cohanim : restrictions matrimoniales, impuretés. Défauts physiques invalidants. Calendrier des fêtes : Chabbat, Pessa'h, Omer, Chavouot, Roch Hachana, Yom Kippour, Souccot.",
            keyVerses: ["Voici les fêtes de l'Éternel, les saintes convocations (23:2)"],
            themes: ["Fêtes juives", "Calendrier", "Sainteté sacerdotale", "Temps sacré"]
        ),
        
        "Behar": ParashaSummary(
            name: "Behar",
            hebrewName: "בהר",
            book: .vayikra,
            summary: "La Chemita (année sabbatique) : la terre se repose. Le Yovel (Jubilé) tous les 50 ans : libération des esclaves, retour des terres. Interdiction de l'usure. Rachat des terres et des personnes.",
            keyVerses: ["La terre ne sera pas vendue à perpétuité, car la terre est à Moi (25:23)"],
            themes: ["Chemita", "Jubilé", "Justice économique", "Confiance en D.ieu"]
        ),
        
        "Bechukotai": ParashaSummary(
            name: "Bechukotai",
            hebrewName: "בחקותי",
            book: .vayikra,
            summary: "Bénédictions pour l'observance des commandements : prospérité, paix, présence divine. Malédictions (To'hekha) pour la désobéissance. Promesse de ne jamais rejeter Israël. Lois sur les vœux et les dîmes.",
            keyVerses: ["Si vous suivez Mes lois (26:3)", "Je Me souviendrai de Mon alliance avec Jacob (26:42)"],
            themes: ["Bénédictions et malédictions", "Alliance éternelle", "Conséquences", "Espoir"]
        ),
        
        // ========================================
        // BAMIDBAR (Nombres)
        // ========================================
        
        "Bamidbar": ParashaSummary(
            name: "Bamidbar",
            hebrewName: "במדבר",
            book: .bamidbar,
            summary: "Recensement des tribus d'Israël dans le désert du Sinaï. Organisation du camp autour du Tabernacle. Les Lévites sont consacrés au service et ne sont pas comptés avec les autres.",
            keyVerses: ["L'Éternel parla à Moïse dans le désert du Sinaï (1:1)"],
            themes: ["Recensement", "Organisation", "Désert", "Service des Lévites"]
        ),
        
        "Nasso": ParashaSummary(
            name: "Nasso",
            hebrewName: "נשא",
            book: .bamidbar,
            summary: "Suite du recensement des Lévites et leurs fonctions. Loi du Nazir. Bénédiction des Cohanim (Birkat Cohanim). Offrandes des princes des tribus pour l'inauguration du Tabernacle.",
            keyVerses: ["Que l'Éternel te bénisse et te garde (6:24)"],
            themes: ["Bénédiction sacerdotale", "Naziréat", "Inauguration", "Service"]
        ),
        
        "Beha'alotcha": ParashaSummary(
            name: "Beha'alotcha",
            hebrewName: "בהעלותך",
            book: .bamidbar,
            summary: "Allumage de la Ménorah. Consécration des Lévites. Le Pessa'h Chéni (deuxième chance). Les trompettes d'argent. Départ du Sinaï. Plaintes du peuple, les cailles, Myriam frappée de Tsaraat.",
            keyVerses: ["Quand tu allumeras les lampes (8:2)", "Nous nous souvenons du poisson que nous mangions en Égypte (11:5)"],
            themes: ["Lumière", "Voyage", "Plaintes", "Humilité de Moïse"]
        ),
        
        "Sh'lach": ParashaSummary(
            name: "Sh'lach",
            hebrewName: "שלח",
            book: .bamidbar,
            summary: "Les 12 explorateurs sont envoyés en Canaan. Dix rapportent négativement, seuls Josué et Caleb sont positifs. Le peuple pleure et est condamné à 40 ans dans le désert. Lois des Tsitsit (franges).",
            keyVerses: ["Tout le pays que vous avez exploré, nous pouvons le conquérir (13:30)", "Vous les verrez et vous vous souviendrez de tous les commandements (15:39)"],
            themes: ["Foi", "Médisance", "Conséquences", "Tsitsit et mémoire"]
        ),
        
        "Korach": ParashaSummary(
            name: "Korach",
            hebrewName: "קרח",
            book: .bamidbar,
            summary: "Kora'h, Datan et Aviram se rebellent contre Moïse et Aaron. La terre les engloutit. 250 rebelles sont consumés par le feu. Le bâton d'Aaron fleurit, confirmant le choix divin des Lévites.",
            keyVerses: ["Toute l'assemblée est sainte (16:3)", "La terre ouvrit sa bouche et les engloutit (16:32)"],
            themes: ["Rébellion", "Jalousie", "Leadership légitime", "Conséquences"]
        ),
        
        "Chukat": ParashaSummary(
            name: "Chukat",
            hebrewName: "חקת",
            book: .bamidbar,
            summary: "La vache rousse et la purification. Mort de Myriam, le puits disparaît. Moïse frappe le rocher au lieu de lui parler : il ne rentrera pas en Canaan. Mort d'Aaron. Serpent de cuivre.",
            keyVerses: ["Voici le statut de la Torah (19:2)", "Parce que vous n'avez pas eu foi en Moi pour Me sanctifier (20:12)"],
            themes: ["Statuts incompréhensibles", "Eau", "Conséquences du leadership", "Foi"]
        ),
        
        "Balak": ParashaSummary(
            name: "Balak",
            hebrewName: "בלק",
            book: .bamidbar,
            summary: "Balak, roi de Moab, engage Bilaam pour maudire Israël. L'ânesse de Bilaam parle. Au lieu de malédictions, Bilaam prononce des bénédictions prophétiques : 'Comme tes tentes sont belles, Jacob !'",
            keyVerses: ["Comme tes tentes sont belles, Jacob ! (24:5)", "Une étoile surgira de Jacob (24:17)"],
            themes: ["Bénédiction", "Prophétie", "Protection divine", "Ironie"]
        ),
        
        "Pinchas": ParashaSummary(
            name: "Pinchas",
            hebrewName: "פינחס",
            book: .bamidbar,
            summary: "Pin'has reçoit l'alliance de paix pour son zèle. Nouveau recensement avant l'entrée en Canaan. Les filles de Tselof'had et l'héritage. Josué désigné successeur. Calendrier détaillé des sacrifices.",
            keyVerses: ["Pin'has a détourné Ma colère (25:11)", "Les filles de Tselof'had parlent juste (27:7)"],
            themes: ["Zèle", "Justice", "Héritage", "Sacrifice quotidien"]
        ),
        
        "Matot": ParashaSummary(
            name: "Matot",
            hebrewName: "מטות",
            book: .bamidbar,
            summary: "Lois sur les vœux et leur annulation. Guerre contre Midian. Partage du butin. Les tribus de Ruben, Gad et demi-Manassé s'installent en Transjordanie à condition de combattre.",
            keyVerses: ["Si un homme fait un vœu à l'Éternel (30:3)"],
            themes: ["Vœux", "Parole", "Guerre", "Unité du peuple"]
        ),
        
        "Masei": ParashaSummary(
            name: "Masei",
            hebrewName: "מסעי",
            book: .bamidbar,
            summary: "Liste des 42 étapes du voyage dans le désert. Frontières de la Terre Promise. Villes de refuge pour les meurtriers involontaires. Lois sur l'héritage des filles.",
            keyVerses: ["Voici les étapes des enfants d'Israël (33:1)"],
            themes: ["Voyage", "Frontières", "Justice", "Héritage"]
        ),
        
        // ========================================
        // DEVARIM (Deutéronome)
        // ========================================
        
        "Devarim": ParashaSummary(
            name: "Devarim",
            hebrewName: "דברים",
            book: .devarim,
            summary: "Début du discours d'adieu de Moïse. Récapitulation des événements depuis le Sinaï : les explorateurs, les guerres, les juges. Moïse ne rentrera pas en Terre Promise.",
            keyVerses: ["Voici les paroles que Moïse adressa à tout Israël (1:1)", "L'Éternel votre D.ieu vous a multipliés (1:10)"],
            themes: ["Récapitulation", "Enseignement", "Adieu", "Histoire"]
        ),
        
        "Vaetchanan": ParashaSummary(
            name: "Vaetchanan",
            hebrewName: "ואתחנן",
            book: .devarim,
            summary: "Moïse supplie D.ieu de le laisser entrer en Canaan. Répétition des Dix Commandements. Le Chéma Israël. Transmission de la Torah aux enfants. Commandement d'aimer D.ieu.",
            keyVerses: ["Écoute, Israël, l'Éternel est notre D.ieu, l'Éternel est Un (6:4)", "Tu aimeras l'Éternel ton D.ieu de tout ton cœur (6:5)"],
            themes: ["Chéma", "Amour de D.ieu", "Transmission", "Unicité divine"]
        ),
        
        "Eikev": ParashaSummary(
            name: "Eikev",
            hebrewName: "עקב",
            book: .devarim,
            summary: "Bénédictions pour l'observance. La manne comme leçon de dépendance. Description de la Terre Promise. Mise en garde contre l'orgueil. Deuxièmes Tables de la Loi.",
            keyVerses: ["L'homme ne vit pas de pain seulement (8:3)", "C'est un pays où coulent le lait et le miel (11:9)"],
            themes: ["Gratitude", "Humilité", "Dépendance de D.ieu", "Terre Promise"]
        ),
        
        "Re'eh": ParashaSummary(
            name: "Re'eh",
            hebrewName: "ראה",
            book: .devarim,
            summary: "Bénédiction et malédiction sur les monts Guérizim et Éival. Lieu choisi par D.ieu pour le culte. Lois de Cacherout. Charité obligatoire. Chemita et remise des dettes. Les trois fêtes de pèlerinage.",
            keyVerses: ["Vois, Je place devant vous la bénédiction et la malédiction (11:26)"],
            themes: ["Choix", "Lieu saint", "Charité", "Fêtes"]
        ),
        
        "Shoftim": ParashaSummary(
            name: "Shoftim",
            hebrewName: "שופטים",
            book: .devarim,
            summary: "Établissement de juges et officiers. Les quatre piliers de l'autorité : juges, roi, cohanim, prophètes. Lois de la guerre. Villes de refuge. Faux témoins. L'égla aroufa.",
            keyVerses: ["La justice, la justice tu poursuivras (16:20)"],
            themes: ["Justice", "Leadership", "Guerre éthique", "Vérité"]
        ),
        
        "Ki Teitzei": ParashaSummary(
            name: "Ki Teitzei",
            hebrewName: "כי תצא",
            book: .devarim,
            summary: "74 commandements sur divers sujets : captive de guerre, héritage, enfant rebelle, pureté du camp, mariage, divorce, salaire, charité, honnêteté commerciale, souvenir d'Amalek.",
            keyVerses: ["Tu auras des poids justes (25:15)", "Souviens-toi de ce que t'a fait Amalek (25:17)"],
            themes: ["Éthique familiale", "Justice sociale", "Compassion", "Mémoire"]
        ),
        
        "Ki Tavo": ParashaSummary(
            name: "Ki Tavo",
            hebrewName: "כי תבוא",
            book: .devarim,
            summary: "Prémices et déclaration. Dîme du pauvre. 'Aujourd'hui tu deviens un peuple'. Bénédictions et malédictions sur les monts. La To'hekha : terrible avertissement. Alliance renouvelée.",
            keyVerses: ["Aujourd'hui l'Éternel ton D.ieu te commande (26:16)", "Ces malédictions viendront sur toi si tu n'écoutes pas (28:15)"],
            themes: ["Prémices", "Alliance", "Bénédictions/Malédictions", "Responsabilité"]
        ),
        
        "Nitzavim": ParashaSummary(
            name: "Nitzavim",
            hebrewName: "נצבים",
            book: .devarim,
            summary: "Tout Israël, du chef au porteur d'eau, entre dans l'Alliance. Les générations futures aussi. La Techouva est toujours possible. 'J'ai placé devant toi la vie et la mort : choisis la vie !'",
            keyVerses: ["Vous vous tenez aujourd'hui tous devant l'Éternel (29:9)", "Choisis la vie afin que tu vives (30:19)"],
            themes: ["Alliance collective", "Techouva", "Libre arbitre", "Vie"]
        ),
        
        "Vayeilech": ParashaSummary(
            name: "Vayeilech",
            hebrewName: "וילך",
            book: .devarim,
            summary: "Moïse, à 120 ans, prépare sa succession. Il encourage Josué et le peuple. Commandement d'écrire la Torah et de la lire tous les 7 ans (Hakhel). Le cantique Haazinou est préparé.",
            keyVerses: ["J'ai aujourd'hui 120 ans (31:2)", "Soyez forts et courageux (31:6)"],
            themes: ["Transition", "Courage", "Torah", "Hakhel"]
        ),
        
        "Ha'azinu": ParashaSummary(
            name: "Ha'azinu",
            hebrewName: "האזינו",
            book: .devarim,
            summary: "Le grand cantique poétique de Moïse. Histoire d'Israël en poésie : l'élection, les bienfaits divins, la rébellion, la punition, la rédemption finale. Moïse reçoit l'ordre de monter sur le mont Nébo.",
            keyVerses: ["Prêtez l'oreille, cieux, que je parle (32:1)", "Car ce n'est pas une parole vaine pour vous, c'est votre vie (32:47)"],
            themes: ["Poésie", "Histoire", "Témoignage", "Vie de Torah"]
        ),
        
        "Vezot Haberakhah": ParashaSummary(
            name: "Vezot Haberakhah",
            hebrewName: "וזאת הברכה",
            book: .devarim,
            summary: "Moïse bénit chaque tribu individuellement avant sa mort. Il monte sur le mont Nébo, voit la Terre Promise, et meurt à 120 ans. D.ieu l'enterre en secret. Josué lui succède. 'Il n'y a pas eu de prophète comme Moïse.'",
            keyVerses: ["Voici la bénédiction dont Moïse bénit les enfants d'Israël (33:1)", "Il n'a plus paru en Israël de prophète semblable à Moïse (34:10)"],
            themes: ["Bénédiction finale", "Mort de Moïse", "Succession", "Unicité de Moïse"]
        )
    ]
    
    // MARK: - Helper Methods
    static func getSummary(for parashaName: String) -> ParashaSummary? {
        // Normaliser le nom pour la recherche
        let normalizedInput = normalizeParashaName(parashaName)
        
        // Chercher par nom exact
        if let summary = summaries[parashaName] {
            return summary
        }
        
        // Chercher par nom normalisé exact
        for (key, summary) in summaries {
            let normalizedKey = normalizeParashaName(key)
            if normalizedInput == normalizedKey {
                return summary
            }
        }
        
        // Chercher avec correspondance de similarité (pour gérer Vayehi vs Vayechi, etc.)
        for (key, summary) in summaries {
            let normalizedKey = normalizeParashaName(key)
            if areSimilarParashaNames(normalizedInput, normalizedKey) {
                return summary
            }
        }
        
        // Chercher par correspondance partielle
        for (key, summary) in summaries {
            if parashaName.localizedCaseInsensitiveContains(key) ||
               key.localizedCaseInsensitiveContains(parashaName) ||
               parashaName.localizedCaseInsensitiveContains(summary.hebrewName) {
                return summary
            }
        }
        
        // Chercher avec le nom normalisé en correspondance partielle
        for (key, summary) in summaries {
            let normalizedKey = normalizeParashaName(key)
            if normalizedInput.contains(normalizedKey) || normalizedKey.contains(normalizedInput) {
                return summary
            }
        }
        
        // Gérer les parachiot combinées (ex: "Tazria-Metzora" -> retourner "Tazria")
        if parashaName.contains("-") {
            let parts = parashaName.split(separator: "-")
            if let firstPart = parts.first {
                return getSummary(for: String(firstPart))
            }
        }
        
        return nil
    }
    
    /// Vérifie si deux noms de paracha sont similaires (gère les variations d'orthographe)
    /// Ex: "vayehi" ~ "vayechi", "shlach" ~ "shelach", "chayei sara" ~ "chayei sarah"
    private static func areSimilarParashaNames(_ name1: String, _ name2: String) -> Bool {
        // Simplifier les translittérations courantes
        let simplified1 = simplifyTransliteration(name1)
        let simplified2 = simplifyTransliteration(name2)
        
        if simplified1 == simplified2 {
            return true
        }
        
        // Vérifier si l'un est un préfixe significatif de l'autre (au moins 4 caractères)
        if simplified1.count >= 4 && simplified2.count >= 4 {
            let prefix1 = String(simplified1.prefix(min(simplified1.count, 6)))
            let prefix2 = String(simplified2.prefix(min(simplified2.count, 6)))
            if prefix1 == prefix2 {
                return true
            }
        }
        
        // Vérifier si l'un contient l'autre (pour les noms courts comme "Bo")
        if name1.count >= 2 && name2.count >= 2 {
            if simplified1.contains(simplified2) || simplified2.contains(simplified1) {
                return true
            }
        }
        
        return false
    }
    
    /// Simplifie les variations de translittération hébraïque
    private static func simplifyTransliteration(_ name: String) -> String {
        return name
            .replacingOccurrences(of: "ch", with: "h")
            .replacingOccurrences(of: "sh", with: "s")
            .replacingOccurrences(of: "kh", with: "h")
            .replacingOccurrences(of: "tz", with: "z")
            .replacingOccurrences(of: "ah", with: "a")  // Sara vs Sarah
    }
    
    /// Normalise le nom de la paracha pour la comparaison
    /// Enlève les accents, apostrophes, préfixes et met en minuscules
    private static func normalizeParashaName(_ name: String) -> String {
        return name
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: "parashat ", with: "")
            .replacingOccurrences(of: "parachah ", with: "")
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
    
    static func getParashaByHebrew(_ hebrewName: String) -> ParashaSummary? {
        for (_, summary) in summaries {
            if summary.hebrewName == hebrewName {
                return summary
            }
        }
        return nil
    }
}
