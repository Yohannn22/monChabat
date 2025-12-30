//
//  ParashaQuizData.swift
//  monChabat
//
//  Quiz pour enfants sur les Parachiot - Questions adaptées aux enfants
//

import Foundation

// Utilise QuizQuestion de Models.swift (avec correctAnswer)

struct ParashaQuiz {
    let parashaName: String
    let hebrewName: String
    let questions: [QuizQuestion]
}

// MARK: - Quiz Database
struct ParashaQuizDatabase {
    
    static let quizzes: [String: ParashaQuiz] = [
        
        // ========================================
        // BERESHIT (Genèse) - 12 Parachiot
        // ========================================
        
        "Bereshit": ParashaQuiz(
            parashaName: "Bereshit",
            hebrewName: "בראשית",
            questions: [
                QuizQuestion(
                    question: "En combien de jours D.ieu a-t-il créé le monde ?",
                    options: ["5 jours", "6 jours", "7 jours", "10 jours"],
                    correctAnswer: 1,
                    explanation: "D.ieu a créé le monde en 6 jours et s'est reposé le 7ème jour (Shabbat)."
                ),
                QuizQuestion(
                    question: "Comment s'appellent le premier homme et la première femme ?",
                    options: ["Noé et Sarah", "Adam et Ève", "Abraham et Rebecca", "Isaac et Léa"],
                    correctAnswer: 1,
                    explanation: "Adam et Ève sont les premiers êtres humains créés par D.ieu."
                ),
                QuizQuestion(
                    question: "Quel fruit Adam et Ève ne devaient-ils pas manger ?",
                    options: ["Une pomme", "Le fruit de l'arbre de la connaissance", "Une orange", "Du raisin"],
                    correctAnswer: 1,
                    explanation: "D.ieu leur avait interdit de manger le fruit de l'arbre de la connaissance."
                ),
                QuizQuestion(
                    question: "Qui a tué son frère Abel ?",
                    options: ["Adam", "Seth", "Caïn", "Noé"],
                    correctAnswer: 2,
                    explanation: "Caïn, jaloux de son frère Abel, l'a tué."
                )
            ]
        ),
        
        "Noach": ParashaQuiz(
            parashaName: "Noach",
            hebrewName: "נח",
            questions: [
                QuizQuestion(
                    question: "Pourquoi Noé a-t-il construit une arche ?",
                    options: ["Pour voyager", "Pour survivre au déluge", "Pour pêcher", "Pour habiter"],
                    correctAnswer: 1,
                    explanation: "D.ieu a demandé à Noé de construire une arche car il allait envoyer un déluge."
                ),
                QuizQuestion(
                    question: "Combien d'animaux de chaque espèce Noé a-t-il pris dans l'arche ?",
                    options: ["1", "2", "5", "10"],
                    correctAnswer: 1,
                    explanation: "Noé a pris 2 animaux de chaque espèce (un mâle et une femelle)."
                ),
                QuizQuestion(
                    question: "Quel signe D.ieu a-t-il donné après le déluge ?",
                    options: ["Une étoile", "Un arc-en-ciel", "Le soleil", "La lune"],
                    correctAnswer: 1,
                    explanation: "L'arc-en-ciel est le signe de l'alliance entre D.ieu et l'humanité."
                ),
                QuizQuestion(
                    question: "Qu'ont voulu construire les hommes à Babel ?",
                    options: ["Un pont", "Une maison", "Une tour jusqu'au ciel", "Un temple"],
                    correctAnswer: 2,
                    explanation: "Les hommes ont voulu construire la Tour de Babel pour atteindre le ciel."
                )
            ]
        ),
        
        "Lech-Lecha": ParashaQuiz(
            parashaName: "Lech-Lecha",
            hebrewName: "לך לך",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Lech Lecha' ?",
                    options: ["Reste ici", "Va pour toi", "Reviens", "Attends"],
                    correctAnswer: 1,
                    explanation: "'Lech Lecha' signifie 'Va pour toi' - D.ieu demande à Avram de partir."
                ),
                QuizQuestion(
                    question: "Comment s'appelait Avram après son nouveau nom ?",
                    options: ["Isaac", "Jacob", "Abraham", "Moïse"],
                    correctAnswer: 2,
                    explanation: "D.ieu a changé le nom d'Avram en Abraham."
                ),
                QuizQuestion(
                    question: "Que D.ieu a-t-il promis à Abraham ?",
                    options: ["De l'or", "Une descendance nombreuse", "Un palais", "Un cheval"],
                    correctAnswer: 1,
                    explanation: "D.ieu a promis à Abraham une descendance aussi nombreuse que les étoiles."
                ),
                QuizQuestion(
                    question: "Quel commandement Abraham a-t-il reçu à 99 ans ?",
                    options: ["Prier", "La Brit Mila (circoncision)", "Jeûner", "Construire"],
                    correctAnswer: 1,
                    explanation: "Abraham a reçu le commandement de la Brit Mila (circoncision)."
                )
            ]
        ),
        
        "Vayera": ParashaQuiz(
            parashaName: "Vayera",
            hebrewName: "וירא",
            questions: [
                QuizQuestion(
                    question: "Combien d'anges Abraham a-t-il accueilli ?",
                    options: ["1", "2", "3", "4"],
                    correctAnswer: 2,
                    explanation: "Abraham a accueilli 3 anges déguisés en voyageurs."
                ),
                QuizQuestion(
                    question: "Comment s'appelle le fils d'Abraham et Sarah ?",
                    options: ["Ismaël", "Isaac", "Jacob", "Ésaü"],
                    correctAnswer: 1,
                    explanation: "Isaac est le fils qu'Abraham et Sarah ont eu dans leur vieillesse."
                ),
                QuizQuestion(
                    question: "Quelles villes D.ieu a-t-il détruites ?",
                    options: ["Jérusalem et Hébron", "Sodome et Gomorrhe", "Béthel et Aï", "Sichem et Dothan"],
                    correctAnswer: 1,
                    explanation: "Sodome et Gomorrhe ont été détruites à cause de leur méchanceté."
                ),
                QuizQuestion(
                    question: "Comment s'appelle l'épreuve d'Abraham avec Isaac ?",
                    options: ["La bénédiction", "La ligature d'Isaac (Akeda)", "Le sacrifice", "La prière"],
                    correctAnswer: 1,
                    explanation: "L'Akeda (ligature d'Isaac) est la grande épreuve de foi d'Abraham."
                )
            ]
        ),
        
        "Chayei Sarah": ParashaQuiz(
            parashaName: "Chayei Sarah",
            hebrewName: "חיי שרה",
            questions: [
                QuizQuestion(
                    question: "Combien d'années Sarah a-t-elle vécu ?",
                    options: ["90 ans", "100 ans", "127 ans", "150 ans"],
                    correctAnswer: 2,
                    explanation: "Sarah a vécu 127 ans."
                ),
                QuizQuestion(
                    question: "Où Abraham a-t-il enterré Sarah ?",
                    options: ["À Jérusalem", "À la grotte de Makhpéla", "En Égypte", "À Béthel"],
                    correctAnswer: 1,
                    explanation: "Abraham a acheté la grotte de Makhpéla à Hébron pour enterrer Sarah."
                ),
                QuizQuestion(
                    question: "Qui est allé chercher une femme pour Isaac ?",
                    options: ["Abraham", "Éliézer", "Lot", "Ismaël"],
                    correctAnswer: 1,
                    explanation: "Éliézer, le serviteur d'Abraham, est allé chercher une femme pour Isaac."
                ),
                QuizQuestion(
                    question: "Comment s'appelle la femme d'Isaac ?",
                    options: ["Sarah", "Léa", "Rébecca", "Rachel"],
                    correctAnswer: 2,
                    explanation: "Rébecca est devenue la femme d'Isaac."
                )
            ]
        ),
        
        "Toldot": ParashaQuiz(
            parashaName: "Toldot",
            hebrewName: "תולדות",
            questions: [
                QuizQuestion(
                    question: "Comment s'appellent les jumeaux d'Isaac et Rébecca ?",
                    options: ["Caïn et Abel", "Jacob et Ésaü", "Moïse et Aaron", "Joseph et Benjamin"],
                    correctAnswer: 1,
                    explanation: "Jacob et Ésaü sont les fils jumeaux d'Isaac et Rébecca."
                ),
                QuizQuestion(
                    question: "Contre quoi Ésaü a-t-il vendu son droit d'aînesse ?",
                    options: ["De l'or", "Un plat de lentilles", "Un vêtement", "Un cheval"],
                    correctAnswer: 1,
                    explanation: "Ésaü a vendu son droit d'aînesse pour un plat de lentilles."
                ),
                QuizQuestion(
                    question: "Qui a aidé Jacob à obtenir la bénédiction de son père ?",
                    options: ["Sarah", "Léa", "Rébecca", "Rachel"],
                    correctAnswer: 2,
                    explanation: "Rébecca a aidé Jacob à recevoir la bénédiction d'Isaac."
                ),
                QuizQuestion(
                    question: "Isaac était-il aveugle quand il a béni Jacob ?",
                    options: ["Oui", "Non"],
                    correctAnswer: 0,
                    explanation: "Isaac était devenu aveugle dans sa vieillesse."
                )
            ]
        ),
        
        "Vayetzei": ParashaQuiz(
            parashaName: "Vayetzei",
            hebrewName: "ויצא",
            questions: [
                QuizQuestion(
                    question: "De quoi Jacob a-t-il rêvé à Béthel ?",
                    options: ["D'un arbre", "D'une échelle avec des anges", "D'un fleuve", "D'une montagne"],
                    correctAnswer: 1,
                    explanation: "Jacob a rêvé d'une échelle allant jusqu'au ciel avec des anges."
                ),
                QuizQuestion(
                    question: "Combien d'années Jacob a-t-il travaillé pour épouser Rachel ?",
                    options: ["5 ans", "7 ans", "10 ans", "14 ans"],
                    correctAnswer: 3,
                    explanation: "Jacob a travaillé 14 ans au total (7 pour Léa, 7 pour Rachel)."
                ),
                QuizQuestion(
                    question: "Qui est le père de Rachel et Léa ?",
                    options: ["Abraham", "Laban", "Isaac", "Ésaü"],
                    correctAnswer: 1,
                    explanation: "Laban est le père de Rachel et Léa, et l'oncle de Jacob."
                ),
                QuizQuestion(
                    question: "Combien de fils Jacob a-t-il eus ?",
                    options: ["8", "10", "12", "14"],
                    correctAnswer: 2,
                    explanation: "Jacob a eu 12 fils qui sont devenus les 12 tribus d'Israël."
                )
            ]
        ),
        
        "Vayishlach": ParashaQuiz(
            parashaName: "Vayishlach",
            hebrewName: "וישלח",
            questions: [
                QuizQuestion(
                    question: "Avec qui Jacob a-t-il lutté toute la nuit ?",
                    options: ["Ésaü", "Un ange", "Laban", "Un lion"],
                    correctAnswer: 1,
                    explanation: "Jacob a lutté avec un ange et a été béni."
                ),
                QuizQuestion(
                    question: "Quel nouveau nom Jacob a-t-il reçu ?",
                    options: ["Abraham", "Israël", "David", "Moïse"],
                    correctAnswer: 1,
                    explanation: "Jacob a reçu le nom 'Israël' qui signifie 'celui qui lutte avec D.ieu'."
                ),
                QuizQuestion(
                    question: "Jacob et Ésaü se sont-ils réconciliés ?",
                    options: ["Oui", "Non"],
                    correctAnswer: 0,
                    explanation: "Les deux frères se sont retrouvés et réconciliés."
                ),
                QuizQuestion(
                    question: "Qui est mort en donnant naissance à Benjamin ?",
                    options: ["Léa", "Rachel", "Bilha", "Zilpa"],
                    correctAnswer: 1,
                    explanation: "Rachel est morte en donnant naissance à Benjamin."
                )
            ]
        ),
        
        "Vayeshev": ParashaQuiz(
            parashaName: "Vayeshev",
            hebrewName: "וישב",
            questions: [
                QuizQuestion(
                    question: "Quel cadeau spécial Jacob a-t-il donné à Joseph ?",
                    options: ["Un cheval", "Une tunique colorée", "Un anneau", "Une épée"],
                    correctAnswer: 1,
                    explanation: "Jacob a donné à Joseph une belle tunique colorée."
                ),
                QuizQuestion(
                    question: "Pourquoi les frères de Joseph étaient-ils jaloux ?",
                    options: ["Il était le plus grand", "Il était le préféré de leur père", "Il était le plus fort", "Il était le plus riche"],
                    correctAnswer: 1,
                    explanation: "Joseph était le fils préféré de Jacob, ce qui rendait ses frères jaloux."
                ),
                QuizQuestion(
                    question: "Qu'ont fait les frères de Joseph ?",
                    options: ["Ils l'ont tué", "Ils l'ont vendu comme esclave", "Ils l'ont enfermé", "Ils l'ont pardonné"],
                    correctAnswer: 1,
                    explanation: "Les frères ont vendu Joseph comme esclave à des marchands."
                ),
                QuizQuestion(
                    question: "Dans quel pays Joseph a-t-il été emmené ?",
                    options: ["Canaan", "Babylone", "Égypte", "Assyrie"],
                    correctAnswer: 2,
                    explanation: "Joseph a été emmené en Égypte où il est devenu esclave."
                )
            ]
        ),
        
        "Miketz": ParashaQuiz(
            parashaName: "Miketz",
            hebrewName: "מקץ",
            questions: [
                QuizQuestion(
                    question: "Quel don spécial Joseph avait-il ?",
                    options: ["Chanter", "Interpréter les rêves", "Construire", "Cuisiner"],
                    correctAnswer: 1,
                    explanation: "Joseph savait interpréter les rêves grâce à D.ieu."
                ),
                QuizQuestion(
                    question: "De quoi Pharaon a-t-il rêvé ?",
                    options: ["De lions", "De 7 vaches grasses et 7 vaches maigres", "D'étoiles", "De la mer"],
                    correctAnswer: 1,
                    explanation: "Pharaon a rêvé de 7 vaches grasses et 7 vaches maigres."
                ),
                QuizQuestion(
                    question: "Que signifiait le rêve de Pharaon ?",
                    options: ["Une guerre", "7 années d'abondance puis 7 de famine", "Un voyage", "Une fête"],
                    correctAnswer: 1,
                    explanation: "Le rêve annonçait 7 années d'abondance suivies de 7 années de famine."
                ),
                QuizQuestion(
                    question: "Quel poste Joseph a-t-il obtenu en Égypte ?",
                    options: ["Cuisinier", "Garde", "Vice-roi", "Esclave"],
                    correctAnswer: 2,
                    explanation: "Joseph est devenu vice-roi d'Égypte, le second après Pharaon."
                )
            ]
        ),
        
        "Vayigash": ParashaQuiz(
            parashaName: "Vayigash",
            hebrewName: "ויגש",
            questions: [
                QuizQuestion(
                    question: "Qui a plaidé pour sauver Benjamin ?",
                    options: ["Ruben", "Juda", "Siméon", "Lévi"],
                    correctAnswer: 1,
                    explanation: "Juda a plaidé courageusement pour sauver son frère Benjamin."
                ),
                QuizQuestion(
                    question: "Qu'a dit Joseph à ses frères ?",
                    options: ["'Je vous pardonne'", "'Je suis Joseph !'", "'Partez !'", "'Payez-moi'"],
                    correctAnswer: 1,
                    explanation: "Joseph s'est révélé en disant 'Je suis Joseph !'"
                ),
                QuizQuestion(
                    question: "Joseph a-t-il pardonné à ses frères ?",
                    options: ["Oui", "Non"],
                    correctAnswer: 0,
                    explanation: "Joseph a pardonné à ses frères et les a embrassés."
                ),
                QuizQuestion(
                    question: "Où la famille de Jacob s'est-elle installée en Égypte ?",
                    options: ["À Memphis", "Au pays de Goshen", "À Thèbes", "Au Caire"],
                    correctAnswer: 1,
                    explanation: "La famille de Jacob s'est installée au pays de Goshen."
                )
            ]
        ),
        
        "Vayechi": ParashaQuiz(
            parashaName: "Vayechi",
            hebrewName: "ויחי",
            questions: [
                QuizQuestion(
                    question: "Combien de fils Jacob a-t-il bénis ?",
                    options: ["10", "12", "7", "5"],
                    correctAnswer: 1,
                    explanation: "Jacob a béni chacun de ses 12 fils avant de mourir."
                ),
                QuizQuestion(
                    question: "Qui sont Éphraïm et Manassé ?",
                    options: ["Les frères de Joseph", "Les fils de Joseph", "Les oncles de Joseph", "Les cousins de Joseph"],
                    correctAnswer: 1,
                    explanation: "Éphraïm et Manassé sont les deux fils de Joseph."
                ),
                QuizQuestion(
                    question: "Où Jacob a-t-il demandé à être enterré ?",
                    options: ["En Égypte", "À la grotte de Makhpéla", "À Béthel", "À Beer-Sheva"],
                    correctAnswer: 1,
                    explanation: "Jacob a demandé à être enterré à Makhpéla avec ses ancêtres."
                ),
                QuizQuestion(
                    question: "Combien d'années Joseph a-t-il vécu ?",
                    options: ["100 ans", "110 ans", "120 ans", "130 ans"],
                    correctAnswer: 1,
                    explanation: "Joseph a vécu 110 ans."
                )
            ]
        ),
        
        // MARK: - Shemot (Exode)
        
        "Shemot": ParashaQuiz(
            parashaName: "Shemot",
            hebrewName: "שמות",
            questions: [
                QuizQuestion(
                    question: "Dans quoi le bébé Moïse a-t-il été placé ?",
                    options: ["Un berceau", "Une grotte", "Un panier sur le Nil", "Une tente"],
                    correctAnswer: 2,
                    explanation: "Moïse a été placé dans un panier sur le Nil pour le sauver."
                ),
                QuizQuestion(
                    question: "Qui a trouvé Moïse dans le Nil ?",
                    options: ["La fille de Pharaon", "La reine", "Une servante", "Myriam"],
                    correctAnswer: 0,
                    explanation: "La fille de Pharaon a trouvé et adopté Moïse."
                ),
                QuizQuestion(
                    question: "Comment D.ieu est-il apparu à Moïse ?",
                    options: ["Dans un rêve", "Dans un buisson ardent", "Sur une montagne", "Dans le désert"],
                    correctAnswer: 1,
                    explanation: "D.ieu est apparu à Moïse dans un buisson qui brûlait sans se consumer."
                ),
                QuizQuestion(
                    question: "Quelle mission D.ieu a-t-il confiée à Moïse ?",
                    options: ["Construire le Temple", "Conquérir Canaan", "Écrire la Torah", "Libérer les Hébreux d'Égypte"],
                    correctAnswer: 3,
                    explanation: "D.ieu a envoyé Moïse libérer les Hébreux de l'esclavage en Égypte."
                )
            ]
        ),
        
        "Vaera": ParashaQuiz(
            parashaName: "Vaera",
            hebrewName: "וארא",
            questions: [
                QuizQuestion(
                    question: "Combien de plaies D.ieu a-t-il envoyées sur l'Égypte ?",
                    options: ["7", "10", "12", "5"],
                    correctAnswer: 1,
                    explanation: "D.ieu a envoyé 10 plaies sur l'Égypte."
                ),
                QuizQuestion(
                    question: "Quelle était la première plaie ?",
                    options: ["Le sang", "Les grenouilles", "Les poux", "Les ténèbres"],
                    correctAnswer: 0,
                    explanation: "La première plaie a transformé l'eau du Nil en sang."
                ),
                QuizQuestion(
                    question: "Qui était le frère de Moïse ?",
                    options: ["Josué", "Caleb", "Nadab", "Aaron"],
                    correctAnswer: 3,
                    explanation: "Aaron était le frère de Moïse et parlait pour lui devant Pharaon."
                ),
                QuizQuestion(
                    question: "Pharaon a-t-il laissé partir les Hébreux après les premières plaies ?",
                    options: ["Oui", "Non"],
                    correctAnswer: 1,
                    explanation: "Pharaon a endurci son cœur et a refusé de laisser partir le peuple."
                )
            ]
        ),
        
        "Bo": ParashaQuiz(
            parashaName: "Bo",
            hebrewName: "בא",
            questions: [
                QuizQuestion(
                    question: "Quelle était la dernière plaie ?",
                    options: ["La mort des premiers-nés", "Les ténèbres", "Les sauterelles", "La grêle"],
                    correctAnswer: 0,
                    explanation: "La dixième et dernière plaie était la mort des premiers-nés."
                ),
                QuizQuestion(
                    question: "Que devaient mettre les Hébreux sur leurs portes ?",
                    options: ["De l'eau", "De l'huile", "Du sang d'agneau", "De la farine"],
                    correctAnswer: 2,
                    explanation: "Les Hébreux devaient marquer leurs portes avec du sang d'agneau."
                ),
                QuizQuestion(
                    question: "Quelle fête célèbre la sortie d'Égypte ?",
                    options: ["Souccot", "Chavouot", "Pourim", "Pessah"],
                    correctAnswer: 3,
                    explanation: "Pessah (la Pâque) célèbre la libération des Hébreux d'Égypte."
                ),
                QuizQuestion(
                    question: "Que mange-t-on à Pessah ?",
                    options: ["Du pain", "Des matsot (pain azyme)", "Des gâteaux", "Du riz"],
                    correctAnswer: 1,
                    explanation: "On mange des matsot car les Hébreux n'ont pas eu le temps de faire lever le pain."
                )
            ]
        ),
        
        "Beshalach": ParashaQuiz(
            parashaName: "Beshalach",
            hebrewName: "בשלח",
            questions: [
                QuizQuestion(
                    question: "Quelle mer D.ieu a-t-il fendue pour les Hébreux ?",
                    options: ["La Méditerranée", "La mer Morte", "La mer Rouge", "Le Nil"],
                    correctAnswer: 2,
                    explanation: "D.ieu a fendu la mer Rouge pour que les Hébreux puissent passer."
                ),
                QuizQuestion(
                    question: "Qu'est-il arrivé à l'armée de Pharaon ?",
                    options: ["Elle s'est noyée dans la mer", "Elle a fui", "Elle s'est rendue", "Elle s'est perdue"],
                    correctAnswer: 0,
                    explanation: "L'armée égyptienne a été engloutie quand la mer s'est refermée."
                ),
                QuizQuestion(
                    question: "Comment D.ieu nourrissait-il les Hébreux dans le désert ?",
                    options: ["Avec du pain du ciel (manne)", "Avec des fruits", "Avec du poisson", "Avec de la viande"],
                    correctAnswer: 0,
                    explanation: "D.ieu envoyait la manne, une nourriture céleste, chaque matin."
                ),
                QuizQuestion(
                    question: "Qui a chanté un cantique après la traversée de la mer ?",
                    options: ["Aaron", "Moïse et Myriam", "Josué", "Les anciens"],
                    correctAnswer: 1,
                    explanation: "Moïse a chanté avec le peuple, et Myriam a mené les femmes."
                )
            ]
        ),
        
        "Yitro": ParashaQuiz(
            parashaName: "Yitro",
            hebrewName: "יתרו",
            questions: [
                QuizQuestion(
                    question: "Qui est Yitro ?",
                    options: ["Le frère de Moïse", "Le beau-père de Moïse", "Le fils de Moïse", "Le père de Moïse"],
                    correctAnswer: 1,
                    explanation: "Yitro (Jéthro) est le beau-père de Moïse, père de Tsipora."
                ),
                QuizQuestion(
                    question: "Sur quelle montagne D.ieu a-t-il donné la Torah ?",
                    options: ["Mont Nebo", "Mont Carmel", "Mont Moriah", "Mont Sinaï"],
                    correctAnswer: 3,
                    explanation: "D.ieu a donné la Torah sur le Mont Sinaï."
                ),
                QuizQuestion(
                    question: "Combien de commandements y a-t-il dans les Dix Commandements ?",
                    options: ["5", "10", "12", "7"],
                    correctAnswer: 1,
                    explanation: "Il y a 10 commandements donnés au Sinaï."
                ),
                QuizQuestion(
                    question: "Quel est le premier commandement ?",
                    options: ["Je suis l'Éternel ton D.ieu", "Tu ne tueras point", "Honore ton père et ta mère", "Tu ne voleras point"],
                    correctAnswer: 0,
                    explanation: "Le premier commandement est 'Je suis l'Éternel ton D.ieu'."
                )
            ]
        ),
        
        "Mishpatim": ParashaQuiz(
            parashaName: "Mishpatim",
            hebrewName: "משפטים",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Mishpatim' ?",
                    options: ["Prières", "Lois/Jugements", "Histoires", "Bénédictions"],
                    correctAnswer: 1,
                    explanation: "Mishpatim signifie 'lois' ou 'jugements'."
                ),
                QuizQuestion(
                    question: "Après combien d'années un esclave hébreu devait-il être libéré ?",
                    options: ["3 ans", "7 ans", "5 ans", "10 ans"],
                    correctAnswer: 1,
                    explanation: "Un esclave hébreu devait être libéré après 7 ans de service."
                ),
                QuizQuestion(
                    question: "Que dit la Torah sur le traitement de l'étranger ?",
                    options: ["L'ignorer", "Le traiter avec amour", "Le renvoyer", "Le craindre"],
                    correctAnswer: 1,
                    explanation: "La Torah commande d'aimer l'étranger car nous étions étrangers en Égypte."
                ),
                QuizQuestion(
                    question: "Qu'a dit le peuple quand il a accepté la Torah ?",
                    options: ["'Peut-être'", "'Naaseh VeNishma' (Nous ferons et écouterons)", "'Non'", "'Plus tard'"],
                    correctAnswer: 1,
                    explanation: "Le peuple a dit 'Naaseh VeNishma' - nous ferons et nous écouterons."
                )
            ]
        ),
        
        "Terumah": ParashaQuiz(
            parashaName: "Terumah",
            hebrewName: "תרומה",
            questions: [
                QuizQuestion(
                    question: "Qu'est-ce qu'une Terumah ?",
                    options: ["Une prière", "Une offrande/don", "Un vêtement", "Un animal"],
                    correctAnswer: 1,
                    explanation: "Terumah signifie 'offrande' ou 'contribution'."
                ),
                QuizQuestion(
                    question: "Que devaient construire les Hébreux ?",
                    options: ["Une ville", "Une tour", "Un Tabernacle (Mishkan)", "Un palais"],
                    correctAnswer: 2,
                    explanation: "D.ieu a demandé de construire le Mishkan, un sanctuaire portable."
                ),
                QuizQuestion(
                    question: "Qu'est-ce que l'Arche d'Alliance contenait ?",
                    options: ["De l'or", "Les Tables de la Loi", "De la manne", "Les trois"],
                    correctAnswer: 3,
                    explanation: "L'Arche contenait les Tables, un peu de manne et le bâton d'Aaron."
                ),
                QuizQuestion(
                    question: "Combien de chérubins étaient sur l'Arche ?",
                    options: ["1", "2", "4", "7"],
                    correctAnswer: 1,
                    explanation: "Deux chérubins en or étaient placés sur le couvercle de l'Arche."
                )
            ]
        ),
        
        "Tetzaveh": ParashaQuiz(
            parashaName: "Tetzaveh",
            hebrewName: "תצוה",
            questions: [
                QuizQuestion(
                    question: "Qui devait porter les vêtements sacerdotaux ?",
                    options: ["Aaron et ses fils", "Moïse", "Tout le peuple", "Les anciens"],
                    correctAnswer: 0,
                    explanation: "Aaron et ses fils, les Cohanim (prêtres), portaient les vêtements sacrés."
                ),
                QuizQuestion(
                    question: "Quelle pierre précieuse le Grand Prêtre portait-il sur son cœur ?",
                    options: ["Une seule pierre", "7 pierres", "3 pierres", "12 pierres pour les 12 tribus"],
                    correctAnswer: 3,
                    explanation: "Le pectoral du Grand Prêtre avait 12 pierres représentant les 12 tribus."
                ),
                QuizQuestion(
                    question: "Avec quoi la Ménorah devait-elle brûler ?",
                    options: ["Du bois", "De la cire", "De l'huile d'olive pure", "Du charbon"],
                    correctAnswer: 2,
                    explanation: "La Ménorah devait brûler avec de l'huile d'olive pure."
                ),
                QuizQuestion(
                    question: "Moïse est-il mentionné par son nom dans cette Paracha ?",
                    options: ["Oui, beaucoup", "Non, pas du tout", "Une seule fois", "Seulement à la fin"],
                    correctAnswer: 1,
                    explanation: "Tetzaveh est la seule Paracha (depuis sa naissance) où Moïse n'est pas nommé."
                )
            ]
        ),
        
        "Ki Tisa": ParashaQuiz(
            parashaName: "Ki Tisa",
            hebrewName: "כי תשא",
            questions: [
                QuizQuestion(
                    question: "Quelle faute le peuple a-t-il commise ?",
                    options: ["Fabriquer un veau d'or", "Voler de l'or", "Quitter le camp", "Se battre"],
                    correctAnswer: 0,
                    explanation: "Le peuple a fabriqué un veau d'or pour l'adorer."
                ),
                QuizQuestion(
                    question: "Qu'a fait Moïse quand il a vu le veau d'or ?",
                    options: ["Il a ri", "Il a fui", "Il a pleuré", "Il a brisé les Tables de la Loi"],
                    correctAnswer: 3,
                    explanation: "Moïse a brisé les Tables de la Loi en voyant le veau d'or."
                ),
                QuizQuestion(
                    question: "D.ieu a-t-il pardonné au peuple ?",
                    options: ["Oui, grâce à Moïse", "Non, jamais", "Seulement certains", "Après 40 ans"],
                    correctAnswer: 0,
                    explanation: "D.ieu a pardonné grâce aux prières de Moïse."
                ),
                QuizQuestion(
                    question: "Combien de jours Moïse est-il resté sur la montagne ?",
                    options: ["40 jours", "30 jours", "7 jours", "100 jours"],
                    correctAnswer: 0,
                    explanation: "Moïse est resté 40 jours et 40 nuits sur le Mont Sinaï."
                )
            ]
        ),
        
        "Vayakhel": ParashaQuiz(
            parashaName: "Vayakhel",
            hebrewName: "ויקהל",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Vayakhel' ?",
                    options: ["Il construisit", "Il rassembla", "Il parla", "Il partit"],
                    correctAnswer: 1,
                    explanation: "Vayakhel signifie 'il rassembla' - Moïse rassembla le peuple."
                ),
                QuizQuestion(
                    question: "Quel jour doit-on se reposer ?",
                    options: ["Le vendredi", "Le Shabbat", "Le dimanche", "Le lundi"],
                    correctAnswer: 1,
                    explanation: "Le Shabbat est le jour de repos sanctifié par D.ieu."
                ),
                QuizQuestion(
                    question: "Qui a dirigé la construction du Tabernacle ?",
                    options: ["Moïse", "Aaron", "Betsalel", "Josué"],
                    correctAnswer: 2,
                    explanation: "Betsalel était l'artisan principal choisi par D.ieu."
                ),
                QuizQuestion(
                    question: "Les femmes ont-elles contribué à la construction ?",
                    options: ["Oui, généreusement", "Non", "Seulement les hommes", "Seulement les anciens"],
                    correctAnswer: 0,
                    explanation: "Les femmes ont contribué leurs bijoux et tissé les étoffes."
                )
            ]
        ),
        
        "Pekudei": ParashaQuiz(
            parashaName: "Pekudei",
            hebrewName: "פקודי",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Pekudei' ?",
                    options: ["Construction", "Comptes/Inventaire", "Fin", "Début"],
                    correctAnswer: 1,
                    explanation: "Pekudei signifie 'comptes' ou 'inventaire' des matériaux du Tabernacle."
                ),
                QuizQuestion(
                    question: "Qu'est-ce qui a rempli le Tabernacle quand il a été terminé ?",
                    options: ["De l'eau", "Du feu", "Des anges", "La nuée de D.ieu"],
                    correctAnswer: 3,
                    explanation: "La nuée de la gloire de D.ieu a rempli le Tabernacle."
                ),
                QuizQuestion(
                    question: "Comment le peuple savait-il quand partir en voyage ?",
                    options: ["La nuée se levait", "Moïse leur disait", "Le shofar sonnait", "Le soleil se couchait"],
                    correctAnswer: 0,
                    explanation: "Quand la nuée se levait du Tabernacle, le peuple partait en voyage."
                ),
                QuizQuestion(
                    question: "Avec quel livre de la Torah se termine Pekudei ?",
                    options: ["Bereshit", "Shemot (Exode)", "Vayikra", "Bamidbar"],
                    correctAnswer: 1,
                    explanation: "Pekudei est la dernière Paracha du livre de Shemot (Exode)."
                )
            ]
        ),
        
        // MARK: - Vayikra (Lévitique)
        
        "Vayikra": ParashaQuiz(
            parashaName: "Vayikra",
            hebrewName: "ויקרא",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Vayikra' ?",
                    options: ["Et il parla", "Et il appela", "Et il construisit", "Et il partit"],
                    correctAnswer: 1,
                    explanation: "Vayikra signifie 'Et Il appela' - D.ieu appela Moïse."
                ),
                QuizQuestion(
                    question: "De quoi parle principalement le livre de Vayikra ?",
                    options: ["Les histoires des patriarches", "Les sacrifices et la sainteté", "La conquête de Canaan", "La sortie d'Égypte"],
                    correctAnswer: 1,
                    explanation: "Vayikra traite des sacrifices, de la pureté et de la sainteté."
                ),
                QuizQuestion(
                    question: "Qui offrait les sacrifices dans le Tabernacle ?",
                    options: ["Les Cohanim (prêtres)", "Moïse", "Tout le peuple", "Les anciens"],
                    correctAnswer: 0,
                    explanation: "Les Cohanim, descendants d'Aaron, offraient les sacrifices."
                ),
                QuizQuestion(
                    question: "Pourquoi offrait-on des sacrifices ?",
                    options: ["Pour manger", "Pour se rapprocher de D.ieu", "Pour voyager", "Pour construire"],
                    correctAnswer: 1,
                    explanation: "Le mot 'korban' (sacrifice) vient de 'karov' qui signifie 'proche'."
                )
            ]
        ),
        
        "Tzav": ParashaQuiz(
            parashaName: "Tzav",
            hebrewName: "צו",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Tzav' ?",
                    options: ["Ordonne", "Parle", "Écoute", "Fais"],
                    correctAnswer: 0,
                    explanation: "Tzav signifie 'Ordonne' - D.ieu ordonne à Aaron les lois des sacrifices."
                ),
                QuizQuestion(
                    question: "Combien de jours durait la consécration des Cohanim ?",
                    options: ["3 jours", "10 jours", "7 jours", "40 jours"],
                    correctAnswer: 2,
                    explanation: "La consécration d'Aaron et ses fils durait 7 jours."
                ),
                QuizQuestion(
                    question: "Quel feu brûlait constamment sur l'autel ?",
                    options: ["Un feu ordinaire", "Un feu éternel (Esh Tamid)", "Un feu bleu", "Un feu froid"],
                    correctAnswer: 1,
                    explanation: "Un feu éternel devait brûler en permanence sur l'autel."
                ),
                QuizQuestion(
                    question: "Qu'est-ce qu'un 'olah' (holocauste) ?",
                    options: ["Un sacrifice partiellement brûlé", "Un sacrifice entièrement brûlé", "Un sacrifice de fruits", "Un sacrifice de pain"],
                    correctAnswer: 1,
                    explanation: "L'olah est un sacrifice entièrement consumé par le feu."
                )
            ]
        ),
        
        "Shmini": ParashaQuiz(
            parashaName: "Shmini",
            hebrewName: "שמיני",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Shemini' ?",
                    options: ["Septième", "Huitième", "Premier", "Dernier"],
                    correctAnswer: 1,
                    explanation: "Shemini signifie 'huitième' - le 8ème jour après la consécration."
                ),
                QuizQuestion(
                    question: "Que s'est-il passé aux fils d'Aaron, Nadav et Avihou ?",
                    options: ["Ils sont devenus grands prêtres", "Ils ont fui", "Ils ont été bénis", "Ils sont morts en offrant un feu étranger"],
                    correctAnswer: 3,
                    explanation: "Nadav et Avihou sont morts en offrant un feu non commandé."
                ),
                QuizQuestion(
                    question: "Quels animaux sont cachères (permis) ?",
                    options: ["Ceux qui ruminent et ont le sabot fendu", "Le porc", "Tous les animaux", "Aucun animal"],
                    correctAnswer: 0,
                    explanation: "Un animal cachère doit ruminer ET avoir le sabot fendu."
                ),
                QuizQuestion(
                    question: "Les poissons cachères doivent avoir...",
                    options: ["Des ailes", "Des pattes", "Des nageoires et des écailles", "Une coquille"],
                    correctAnswer: 2,
                    explanation: "Les poissons cachères doivent avoir des nageoires et des écailles."
                )
            ]
        ),
        
        "Tazria": ParashaQuiz(
            parashaName: "Tazria",
            hebrewName: "תזריע",
            questions: [
                QuizQuestion(
                    question: "De quoi parle principalement Tazria ?",
                    options: ["Les fêtes", "Les lois de pureté", "Les sacrifices", "Les voyages"],
                    correctAnswer: 1,
                    explanation: "Tazria traite des lois de pureté, notamment la tsaraat."
                ),
                QuizQuestion(
                    question: "Qu'est-ce que la tsaraat ?",
                    options: ["Une maladie physique", "Une affection spirituelle de la peau", "Une bénédiction", "Un sacrifice"],
                    correctAnswer: 1,
                    explanation: "La tsaraat était une affection spirituelle, souvent liée à la médisance."
                ),
                QuizQuestion(
                    question: "Qui examinait les cas de tsaraat ?",
                    options: ["Le Cohen (prêtre)", "Moïse", "Les anciens", "La famille"],
                    correctAnswer: 0,
                    explanation: "Le Cohen examinait la personne et déclarait si elle était pure ou impure."
                ),
                QuizQuestion(
                    question: "Après combien de jours une mère était-elle purifiée après la naissance d'un garçon ?",
                    options: ["7 jours", "8 jours", "40 jours", "80 jours"],
                    correctAnswer: 2,
                    explanation: "La purification complète prenait 40 jours pour un garçon."
                )
            ]
        ),
        
        "Metzora": ParashaQuiz(
            parashaName: "Metzora",
            hebrewName: "מצורע",
            questions: [
                QuizQuestion(
                    question: "Qu'est-ce qu'un Metzora ?",
                    options: ["Un prêtre", "Une personne atteinte de tsaraat", "Un sacrifice", "Un vêtement"],
                    correctAnswer: 1,
                    explanation: "Un Metzora est une personne atteinte de tsaraat."
                ),
                QuizQuestion(
                    question: "Où devait vivre le Metzora pendant sa guérison ?",
                    options: ["Dans le Tabernacle", "Dans sa maison", "Dans le désert", "À l'extérieur du camp"],
                    correctAnswer: 3,
                    explanation: "Le Metzora devait vivre seul, à l'extérieur du camp."
                ),
                QuizQuestion(
                    question: "Quels oiseaux étaient utilisés pour la purification ?",
                    options: ["Des colombes", "Des aigles", "Deux oiseaux vivants", "Des corbeaux"],
                    correctAnswer: 2,
                    explanation: "Deux oiseaux vivants étaient utilisés dans le rituel de purification."
                ),
                QuizQuestion(
                    question: "La tsaraat pouvait-elle affecter les maisons ?",
                    options: ["Oui", "Non"],
                    correctAnswer: 0,
                    explanation: "La tsaraat pouvait affecter les vêtements et même les maisons."
                )
            ]
        ),
        
        "Achrei Mot": ParashaQuiz(
            parashaName: "Achrei Mot",
            hebrewName: "אחרי מות",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Acharei Mot' ?",
                    options: ["Avant la vie", "Après la mort", "Pendant le voyage", "Au début"],
                    correctAnswer: 1,
                    explanation: "'Acharei Mot' signifie 'après la mort' de Nadav et Avihou."
                ),
                QuizQuestion(
                    question: "Quel jour saint est décrit dans cette Paracha ?",
                    options: ["Yom Kippour", "Pessah", "Souccot", "Chavouot"],
                    correctAnswer: 0,
                    explanation: "Le service de Yom Kippour est décrit en détail."
                ),
                QuizQuestion(
                    question: "Où le Grand Prêtre entrait-il une fois par an ?",
                    options: ["Dans le camp", "Sur la montagne", "Dans le désert", "Dans le Saint des Saints"],
                    correctAnswer: 3,
                    explanation: "Le Grand Prêtre entrait dans le Saint des Saints uniquement à Yom Kippour."
                ),
                QuizQuestion(
                    question: "Qu'est-ce que le bouc émissaire (Azazel) ?",
                    options: ["Un sacrifice brûlé", "Un animal domestique", "Un bouc envoyé dans le désert avec les péchés", "Un oiseau"],
                    correctAnswer: 2,
                    explanation: "Le bouc émissaire emportait symboliquement les péchés du peuple."
                )
            ]
        ),
        
        "Kedoshim": ParashaQuiz(
            parashaName: "Kedoshim",
            hebrewName: "קדושים",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Kedoshim' ?",
                    options: ["Purs", "Saints", "Forts", "Sages"],
                    correctAnswer: 1,
                    explanation: "Kedoshim signifie 'saints' - 'Soyez saints car Je suis saint'."
                ),
                QuizQuestion(
                    question: "Quel commandement célèbre se trouve dans cette Paracha ?",
                    options: ["Tu aimeras ton prochain comme toi-même", "Tu ne voleras point", "Honore ton père", "Observe le Shabbat"],
                    correctAnswer: 0,
                    explanation: "'Tu aimeras ton prochain comme toi-même' est un commandement fondamental."
                ),
                QuizQuestion(
                    question: "Que dit la Torah sur le respect des personnes âgées ?",
                    options: ["Se lever devant eux", "Les ignorer", "Les éviter", "Rien"],
                    correctAnswer: 0,
                    explanation: "La Torah commande de se lever devant une personne âgée par respect."
                ),
                QuizQuestion(
                    question: "Doit-on laisser une partie des récoltes pour les pauvres ?",
                    options: ["Oui (le coin du champ)", "Non", "Seulement pour la famille", "Seulement le Shabbat"],
                    correctAnswer: 0,
                    explanation: "On doit laisser le coin du champ (péa) et les glanures pour les pauvres."
                )
            ]
        ),
        
        "Emor": ParashaQuiz(
            parashaName: "Emor",
            hebrewName: "אמור",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Emor' ?",
                    options: ["Fais", "Dis/Parle", "Écoute", "Viens"],
                    correctAnswer: 1,
                    explanation: "Emor signifie 'Dis' - D.ieu dit à Moïse de parler aux Cohanim."
                ),
                QuizQuestion(
                    question: "Quelles fêtes sont mentionnées dans Emor ?",
                    options: ["Hanoucca et Pourim", "Shabbat et les fêtes de pèlerinage", "Seulement Yom Kippour", "Aucune fête"],
                    correctAnswer: 1,
                    explanation: "Shabbat, Pessah, Chavouot, Rosh Hashana, Yom Kippour et Souccot sont mentionnés."
                ),
                QuizQuestion(
                    question: "Combien de jours dure Souccot ?",
                    options: ["1 jour", "8 jours", "10 jours", "7 jours"],
                    correctAnswer: 3,
                    explanation: "Souccot dure 7 jours, suivi de Chemini Atseret."
                ),
                QuizQuestion(
                    question: "Qu'est-ce que le Omer ?",
                    options: ["Une prière", "Le compte des 49 jours entre Pessah et Chavouot", "Un sacrifice", "Une fête"],
                    correctAnswer: 1,
                    explanation: "On compte 49 jours (7 semaines) du Omer entre Pessah et Chavouot."
                )
            ]
        ),
        
        "Behar": ParashaQuiz(
            parashaName: "Behar",
            hebrewName: "בהר",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Behar' ?",
                    options: ["Dans la vallée", "Sur la montagne", "Dans la mer", "Dans le désert"],
                    correctAnswer: 1,
                    explanation: "Behar signifie 'sur la montagne' (Sinaï)."
                ),
                QuizQuestion(
                    question: "Qu'est-ce que l'année de Shemitah ?",
                    options: ["Année de guerre", "Année de repos de la terre tous les 7 ans", "Année de fête", "Année de construction"],
                    correctAnswer: 1,
                    explanation: "Tous les 7 ans, la terre doit se reposer (Shemitah)."
                ),
                QuizQuestion(
                    question: "Qu'est-ce que le Yovel (Jubilé) ?",
                    options: ["L'année 25", "L'année 100", "L'année 50", "L'année 10"],
                    correctAnswer: 2,
                    explanation: "Le Yovel est l'année 50, où les esclaves sont libérés et les terres retournent."
                ),
                QuizQuestion(
                    question: "Que dit la Torah sur les prix injustes ?",
                    options: ["C'est permis", "C'est interdit de tromper son prochain", "Seulement pour les étrangers", "Rien"],
                    correctAnswer: 1,
                    explanation: "Il est interdit de tromper son prochain dans le commerce."
                )
            ]
        ),
        
        "Bechukotai": ParashaQuiz(
            parashaName: "Bechukotai",
            hebrewName: "בחקותי",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Bechukotai' ?",
                    options: ["Dans mes lois", "Dans mes maisons", "Dans mes terres", "Dans mes fêtes"],
                    correctAnswer: 0,
                    explanation: "Bechukotai signifie 'dans mes décrets/lois'."
                ),
                QuizQuestion(
                    question: "Que promet D.ieu si on suit Ses commandements ?",
                    options: ["La guerre", "Des bénédictions", "La pauvreté", "L'exil"],
                    correctAnswer: 1,
                    explanation: "D.ieu promet pluie, récoltes abondantes, paix et prospérité."
                ),
                QuizQuestion(
                    question: "Que se passe-t-il si on ne suit pas les commandements ?",
                    options: ["Rien", "Des malédictions et l'exil", "Plus de pluie seulement", "La fin du monde"],
                    correctAnswer: 1,
                    explanation: "Des conséquences négatives suivent la désobéissance."
                ),
                QuizQuestion(
                    question: "Quel livre de la Torah se termine avec Bechukotai ?",
                    options: ["Bereshit", "Shemot", "Vayikra (Lévitique)", "Bamidbar"],
                    correctAnswer: 2,
                    explanation: "Bechukotai est la dernière Paracha du livre de Vayikra."
                )
            ]
        ),
        
        // MARK: - Bamidbar (Nombres)
        
        "Bamidbar": ParashaQuiz(
            parashaName: "Bamidbar",
            hebrewName: "במדבר",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Bamidbar' ?",
                    options: ["Dans la mer", "Dans le désert", "Dans la montagne", "Dans la ville"],
                    correctAnswer: 1,
                    explanation: "Bamidbar signifie 'dans le désert'."
                ),
                QuizQuestion(
                    question: "Pourquoi a-t-on compté les Israélites ?",
                    options: ["Pour les punir", "Pour montrer l'amour de D.ieu pour eux", "Pour les diviser", "Pour les vendre"],
                    correctAnswer: 1,
                    explanation: "Compter le peuple montre combien D.ieu les aime."
                ),
                QuizQuestion(
                    question: "Quelle tribu n'a pas été comptée avec les autres ?",
                    options: ["Lévi", "Juda", "Benjamin", "Dan"],
                    correctAnswer: 0,
                    explanation: "Les Lévites avaient un rôle spécial au service du Tabernacle."
                ),
                QuizQuestion(
                    question: "Comment les tribus campaient-elles autour du Tabernacle ?",
                    options: ["En cercle", "En ligne", "Au hasard", "En carré (4 groupes de 3 tribus)"],
                    correctAnswer: 3,
                    explanation: "Les 12 tribus campaient en 4 groupes aux 4 côtés du Tabernacle."
                )
            ]
        ),
        
        "Nasso": ParashaQuiz(
            parashaName: "Nasso",
            hebrewName: "נשא",
            questions: [
                QuizQuestion(
                    question: "Nasso est la plus longue Paracha de la Torah. Vrai ou faux ?",
                    options: ["Vrai", "Faux"],
                    correctAnswer: 0,
                    explanation: "Nasso contient 176 versets, c'est la plus longue Paracha."
                ),
                QuizQuestion(
                    question: "Qu'est-ce qu'un Nazir ?",
                    options: ["Un roi", "Un prêtre", "Une personne qui fait un vœu spécial de sainteté", "Un prophète"],
                    correctAnswer: 2,
                    explanation: "Un Nazir fait un vœu de ne pas boire de vin et de ne pas couper ses cheveux."
                ),
                QuizQuestion(
                    question: "Quelle bénédiction célèbre se trouve dans Nasso ?",
                    options: ["La bénédiction des Cohanim", "Le Shema", "Le Kaddish", "La Amida"],
                    correctAnswer: 0,
                    explanation: "La bénédiction des Cohanim (Birkat Cohanim) est dans Nasso."
                ),
                QuizQuestion(
                    question: "Combien de princes ont apporté des offrandes pour le Tabernacle ?",
                    options: ["10", "12", "7", "3"],
                    correctAnswer: 1,
                    explanation: "Les 12 princes des 12 tribus ont chacun apporté une offrande."
                )
            ]
        ),
        
        "Behaalotecha": ParashaQuiz(
            parashaName: "Behaalotecha",
            hebrewName: "בהעלותך",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Behaalotecha' ?",
                    options: ["Quand tu descendras", "Quand tu allumeras", "Quand tu marcheras", "Quand tu parleras"],
                    correctAnswer: 1,
                    explanation: "Behaalotecha signifie 'quand tu allumeras' - les lampes de la Ménorah."
                ),
                QuizQuestion(
                    question: "Combien de branches avait la Ménorah ?",
                    options: ["5", "6", "9", "7"],
                    correctAnswer: 3,
                    explanation: "La Ménorah du Temple avait 7 branches."
                ),
                QuizQuestion(
                    question: "De quoi le peuple s'est-il plaint dans le désert ?",
                    options: ["Du froid", "De la nourriture (ils voulaient de la viande)", "Du Shabbat", "Des prières"],
                    correctAnswer: 1,
                    explanation: "Le peuple s'est plaint et a demandé de la viande au lieu de la manne."
                ),
                QuizQuestion(
                    question: "Qui a critiqué Moïse et a été punie de tsaraat ?",
                    options: ["Aaron", "Josué", "Myriam", "Caleb"],
                    correctAnswer: 2,
                    explanation: "Myriam a critiqué Moïse et a été atteinte de tsaraat temporairement."
                )
            ]
        ),
        
        "Sh'lach": ParashaQuiz(
            parashaName: "Sh'lach",
            hebrewName: "שלח",
            questions: [
                QuizQuestion(
                    question: "Combien d'explorateurs Moïse a-t-il envoyés en Canaan ?",
                    options: ["12", "10", "7", "40"],
                    correctAnswer: 0,
                    explanation: "12 explorateurs ont été envoyés, un de chaque tribu."
                ),
                QuizQuestion(
                    question: "Combien d'explorateurs ont donné un bon rapport ?",
                    options: ["10", "2", "12", "0"],
                    correctAnswer: 1,
                    explanation: "Seuls Josué et Caleb ont eu foi et donné un rapport positif."
                ),
                QuizQuestion(
                    question: "Combien d'années le peuple a-t-il erré dans le désert ?",
                    options: ["7 ans", "20 ans", "40 ans", "100 ans"],
                    correctAnswer: 2,
                    explanation: "Le peuple a erré 40 ans à cause de son manque de foi."
                ),
                QuizQuestion(
                    question: "Qu'est-ce que les Tsitsit ?",
                    options: ["Des chapeaux", "Des chaussures", "Des ceintures", "Des franges sur les vêtements"],
                    correctAnswer: 3,
                    explanation: "Les Tsitsit sont des franges qui rappellent les commandements."
                )
            ]
        ),
        
        "Korach": ParashaQuiz(
            parashaName: "Korach",
            hebrewName: "קורח",
            questions: [
                QuizQuestion(
                    question: "Qui était Korach ?",
                    options: ["Un prophète", "Un roi", "Un rebelle contre Moïse", "Un prêtre"],
                    correctAnswer: 2,
                    explanation: "Korach s'est rebellé contre l'autorité de Moïse et Aaron."
                ),
                QuizQuestion(
                    question: "Que voulait Korach ?",
                    options: ["Quitter l'Égypte", "Être prêtre/avoir plus de pouvoir", "Retourner en Égypte", "Construire une ville"],
                    correctAnswer: 1,
                    explanation: "Korach voulait le pouvoir sacerdotal pour lui-même."
                ),
                QuizQuestion(
                    question: "Comment Korach et ses partisans ont-ils été punis ?",
                    options: ["La terre les a engloutis", "Exilés", "Transformés en sel", "Envoyés en Égypte"],
                    correctAnswer: 0,
                    explanation: "La terre s'est ouverte et les a engloutis."
                ),
                QuizQuestion(
                    question: "Quel bâton a fleuri pour prouver le choix d'Aaron ?",
                    options: ["Le bâton de Moïse", "Le bâton de Josué", "Le bâton d'Aaron", "Le bâton de Korach"],
                    correctAnswer: 2,
                    explanation: "Le bâton d'Aaron a fleuri et donné des amandes."
                )
            ]
        ),
        
        "Chukat": ParashaQuiz(
            parashaName: "Chukat",
            hebrewName: "חוקת",
            questions: [
                QuizQuestion(
                    question: "Qu'est-ce que la vache rousse (Para Adouma) ?",
                    options: ["Un sacrifice ordinaire", "Un rituel de purification mystérieux", "Un animal de ferme", "Un symbole de richesse"],
                    correctAnswer: 1,
                    explanation: "La vache rousse purifiait ceux qui avaient touché un mort."
                ),
                QuizQuestion(
                    question: "Qui est mort dans cette Paracha ?",
                    options: ["Myriam et Aaron", "Moïse", "Josué", "Caleb"],
                    correctAnswer: 0,
                    explanation: "Myriam puis Aaron sont morts dans le désert."
                ),
                QuizQuestion(
                    question: "Pourquoi Moïse n'a-t-il pas pu entrer en Terre Promise ?",
                    options: ["Il était trop vieux", "Il était malade", "Il ne voulait pas", "Il a frappé le rocher au lieu de lui parler"],
                    correctAnswer: 3,
                    explanation: "Moïse a frappé le rocher au lieu de lui parler comme D.ieu l'avait demandé."
                ),
                QuizQuestion(
                    question: "Qu'est-ce que le serpent d'airain ?",
                    options: ["Une arme", "Un serpent de bronze qui guérissait ceux qui le regardaient", "Un bijou", "Un animal"],
                    correctAnswer: 1,
                    explanation: "Moïse a fait un serpent d'airain pour guérir le peuple des morsures."
                )
            ]
        ),
        
        "Balak": ParashaQuiz(
            parashaName: "Balak",
            hebrewName: "בלק",
            questions: [
                QuizQuestion(
                    question: "Qui était Balak ?",
                    options: ["Un prophète d'Israël", "Un prêtre", "Le roi de Moab", "Un guerrier"],
                    correctAnswer: 2,
                    explanation: "Balak était le roi de Moab qui avait peur d'Israël."
                ),
                QuizQuestion(
                    question: "Qui était Bilaam ?",
                    options: ["Un prophète païen", "Un roi", "Un prêtre", "Un guerrier"],
                    correctAnswer: 0,
                    explanation: "Bilaam était un prophète non-juif engagé pour maudire Israël."
                ),
                QuizQuestion(
                    question: "Quel animal a parlé à Bilaam ?",
                    options: ["Un cheval", "Un lion", "Un aigle", "Une ânesse"],
                    correctAnswer: 3,
                    explanation: "L'ânesse de Bilaam a parlé quand elle a vu l'ange."
                ),
                QuizQuestion(
                    question: "Au lieu de maudire, qu'a fait Bilaam ?",
                    options: ["Il s'est enfui", "Il s'est battu", "Il a béni Israël", "Il a pleuré"],
                    correctAnswer: 2,
                    explanation: "D.ieu a mis des bénédictions dans la bouche de Bilaam."
                )
            ]
        ),
        
        "Pinchas": ParashaQuiz(
            parashaName: "Pinchas",
            hebrewName: "פינחס",
            questions: [
                QuizQuestion(
                    question: "Qui était Pinchas ?",
                    options: ["Le petit-fils d'Aaron", "Un roi", "Un prophète", "Un explorateur"],
                    correctAnswer: 0,
                    explanation: "Pinchas était le petit-fils d'Aaron le Grand Prêtre."
                ),
                QuizQuestion(
                    question: "Quelle récompense Pinchas a-t-il reçue ?",
                    options: ["De l'or", "Une alliance de paix et de prêtrise", "Une terre", "Un troupeau"],
                    correctAnswer: 1,
                    explanation: "D.ieu a donné à Pinchas une alliance de paix éternelle."
                ),
                QuizQuestion(
                    question: "Qui étaient les filles de Tselofhad ?",
                    options: ["Des prophétesses", "Des femmes qui ont demandé leur héritage", "Des prêtresses", "Des reines"],
                    correctAnswer: 1,
                    explanation: "Elles ont demandé et obtenu le droit d'hériter de leur père."
                ),
                QuizQuestion(
                    question: "Qui a été choisi pour succéder à Moïse ?",
                    options: ["Aaron", "Caleb", "Josué", "Pinchas"],
                    correctAnswer: 2,
                    explanation: "Josué a été choisi pour mener le peuple en Terre Promise."
                )
            ]
        ),
        
        "Matot": ParashaQuiz(
            parashaName: "Matot",
            hebrewName: "מטות",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Matot' ?",
                    options: ["Prières", "Tribus", "Lois", "Guerres"],
                    correctAnswer: 1,
                    explanation: "Matot signifie 'tribus' (bâtons des chefs de tribus)."
                ),
                QuizQuestion(
                    question: "De quoi parle le début de la Paracha ?",
                    options: ["Les guerres", "Les vœux et promesses", "Les fêtes", "Les sacrifices"],
                    correctAnswer: 1,
                    explanation: "La Paracha commence par les lois sur les vœux (nedarim)."
                ),
                QuizQuestion(
                    question: "Contre qui Israël a-t-il combattu ?",
                    options: ["L'Égypte", "Canaan", "Babylone", "Midian"],
                    correctAnswer: 3,
                    explanation: "Israël a combattu Midian pour leur rôle dans le péché de Baal Peor."
                ),
                QuizQuestion(
                    question: "Quelles tribus ont demandé à rester de l'autre côté du Jourdain ?",
                    options: ["Juda et Benjamin", "Ruben, Gad et demi-Manassé", "Lévi et Siméon", "Dan et Nephtali"],
                    correctAnswer: 1,
                    explanation: "Ces tribus avaient beaucoup de bétail et voulaient ces terres."
                )
            ]
        ),
        
        "Masei": ParashaQuiz(
            parashaName: "Masei",
            hebrewName: "מסעי",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Masei' ?",
                    options: ["Commandements", "Voyages/Étapes", "Guerres", "Prières"],
                    correctAnswer: 1,
                    explanation: "Masei signifie 'voyages' ou 'étapes' du peuple dans le désert."
                ),
                QuizQuestion(
                    question: "Combien d'étapes le peuple a-t-il faites dans le désert ?",
                    options: ["12", "40", "42", "50"],
                    correctAnswer: 2,
                    explanation: "Le peuple a fait 42 étapes pendant les 40 ans dans le désert."
                ),
                QuizQuestion(
                    question: "Qu'est-ce que les villes de refuge ?",
                    options: ["Des villes fortifiées", "Des villes où un meurtrier accidentel pouvait fuir", "Des villes pour les prêtres", "Des villes de commerce"],
                    correctAnswer: 1,
                    explanation: "Les villes de refuge protégeaient celui qui avait tué accidentellement."
                ),
                QuizQuestion(
                    question: "Quel livre de la Torah se termine avec Masei ?",
                    options: ["Shemot", "Vayikra", "Bamidbar (Nombres)", "Devarim"],
                    correctAnswer: 2,
                    explanation: "Masei est la dernière Paracha du livre de Bamidbar."
                )
            ]
        ),
        
        // MARK: - Devarim (Deutéronome)
        
        "Devarim": ParashaQuiz(
            parashaName: "Devarim",
            hebrewName: "דברים",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Devarim' ?",
                    options: ["Actions", "Paroles", "Voyages", "Lois"],
                    correctAnswer: 1,
                    explanation: "Devarim signifie 'paroles' - les dernières paroles de Moïse."
                ),
                QuizQuestion(
                    question: "Qui parle principalement dans le livre de Devarim ?",
                    options: ["Moïse", "Aaron", "Josué", "D.ieu directement"],
                    correctAnswer: 0,
                    explanation: "Moïse récapitule l'histoire et les lois avant sa mort."
                ),
                QuizQuestion(
                    question: "Avant quoi Moïse fait-il ses discours ?",
                    options: ["Avant de quitter l'Égypte", "Avant de recevoir la Torah", "Avant le déluge", "Avant d'entrer en Terre Promise"],
                    correctAnswer: 3,
                    explanation: "Moïse parle au peuple juste avant l'entrée en Terre Promise."
                ),
                QuizQuestion(
                    question: "Moïse entrera-t-il en Terre Promise ?",
                    options: ["Oui", "Non"],
                    correctAnswer: 1,
                    explanation: "Moïse ne pourra pas entrer, il mourra sur le Mont Nebo."
                )
            ]
        ),
        
        "Vaetchanan": ParashaQuiz(
            parashaName: "Vaetchanan",
            hebrewName: "ואתחנן",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Vaetchanan' ?",
                    options: ["Et je commandai", "Et je suppliai", "Et je parlai", "Et je marchai"],
                    correctAnswer: 1,
                    explanation: "Vaetchanan signifie 'et je suppliai' - Moïse a supplié D.ieu."
                ),
                QuizQuestion(
                    question: "Quelle prière très importante se trouve dans cette Paracha ?",
                    options: ["La Amida", "Le Kaddish", "Le Shema Israël", "Adon Olam"],
                    correctAnswer: 2,
                    explanation: "Le Shema Israël est dans Vaetchanan : 'Écoute Israël, l'Éternel est notre D.ieu, l'Éternel est Un'."
                ),
                QuizQuestion(
                    question: "Où doit-on placer les paroles de la Torah ?",
                    options: ["Dans un livre seulement", "Dans le Temple", "Dans la synagogue", "Sur le cœur, les mains et entre les yeux"],
                    correctAnswer: 3,
                    explanation: "C'est l'origine des Tefilin (phylactères) et des Mezouzot."
                ),
                QuizQuestion(
                    question: "Les Dix Commandements sont-ils répétés dans cette Paracha ?",
                    options: ["Oui", "Non"],
                    correctAnswer: 0,
                    explanation: "Moïse répète les Dix Commandements au peuple."
                )
            ]
        ),
        
        "Eikev": ParashaQuiz(
            parashaName: "Eikev",
            hebrewName: "עקב",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Eikev' ?",
                    options: ["Si/Parce que", "Toujours", "Jamais", "Maintenant"],
                    correctAnswer: 0,
                    explanation: "Eikev signifie 'si' ou 'parce que' vous écoutez ces lois."
                ),
                QuizQuestion(
                    question: "Quelle bénédiction dit-on après avoir mangé ?",
                    options: ["Birkat Hamazon (bénédiction après le repas)", "Hamotsi", "Shema", "Kiddouch"],
                    correctAnswer: 0,
                    explanation: "La mitsva de Birkat Hamazon vient de cette Paracha."
                ),
                QuizQuestion(
                    question: "Comment la Torah décrit-elle la Terre d'Israël ?",
                    options: ["Une terre de désert", "Une terre de montagnes", "Une terre de lait et de miel", "Une terre de neige"],
                    correctAnswer: 2,
                    explanation: "La Terre Promise est décrite comme une terre de lait et de miel."
                ),
                QuizQuestion(
                    question: "Que demande D.ieu à Israël ?",
                    options: ["De construire des temples", "De conquérir le monde", "De rester dans le désert", "De craindre D.ieu et de marcher dans Ses voies"],
                    correctAnswer: 3,
                    explanation: "D.ieu demande de Le craindre, L'aimer et garder Ses commandements."
                )
            ]
        ),
        
        "Re'eh": ParashaQuiz(
            parashaName: "Re'eh",
            hebrewName: "ראה",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Re'eh' ?",
                    options: ["Écoute", "Vois", "Marche", "Parle"],
                    correctAnswer: 1,
                    explanation: "Re'eh signifie 'Vois' - vois, je place devant toi la bénédiction et la malédiction."
                ),
                QuizQuestion(
                    question: "Qu'est-ce que la Tsedaka ?",
                    options: ["La charité/justice", "Une fête", "Un sacrifice", "Une prière"],
                    correctAnswer: 0,
                    explanation: "La Tsedaka est le devoir de donner aux pauvres."
                ),
                QuizQuestion(
                    question: "Combien de fois par an devait-on monter au Temple ?",
                    options: ["1 fois", "2 fois", "3 fois", "4 fois"],
                    correctAnswer: 2,
                    explanation: "On montait 3 fois : à Pessah, Chavouot et Souccot."
                ),
                QuizQuestion(
                    question: "Les lois de Cacherout sont-elles mentionnées dans Re'eh ?",
                    options: ["Oui", "Non"],
                    correctAnswer: 0,
                    explanation: "Les lois alimentaires sont rappelées dans cette Paracha."
                )
            ]
        ),
        
        "Shoftim": ParashaQuiz(
            parashaName: "Shoftim",
            hebrewName: "שופטים",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Shoftim' ?",
                    options: ["Prêtres", "Juges", "Rois", "Prophètes"],
                    correctAnswer: 1,
                    explanation: "Shoftim signifie 'juges' - établir des juges et des officiers."
                ),
                QuizQuestion(
                    question: "Quel principe de justice célèbre vient de cette Paracha ?",
                    options: ["Œil pour œil", "Aime ton prochain", "Ne tue pas", "Justice, justice tu poursuivras"],
                    correctAnswer: 3,
                    explanation: "'Tsedek, tsedek tirdof' - Justice, justice tu poursuivras."
                ),
                QuizQuestion(
                    question: "Combien de témoins faut-il pour condamner quelqu'un ?",
                    options: ["2 ou 3", "1", "5", "10"],
                    correctAnswer: 0,
                    explanation: "Il faut au moins 2 témoins pour établir un fait."
                ),
                QuizQuestion(
                    question: "Les Israélites pouvaient-ils avoir un roi ?",
                    options: ["Non, jamais", "Oui, avec certaines conditions", "Seulement de la tribu de Lévi", "Seulement des étrangers"],
                    correctAnswer: 1,
                    explanation: "Un roi était permis, mais il devait suivre la Torah."
                )
            ]
        ),
        
        "Ki Teitzei": ParashaQuiz(
            parashaName: "Ki Teitzei",
            hebrewName: "כי תצא",
            questions: [
                QuizQuestion(
                    question: "Combien de mitsvot (commandements) y a-t-il dans Ki Tetze ?",
                    options: ["10", "30", "74", "100"],
                    correctAnswer: 2,
                    explanation: "Ki Tetze contient 74 mitsvot, plus que toute autre Paracha."
                ),
                QuizQuestion(
                    question: "Si on trouve un oiseau avec ses œufs, que doit-on faire ?",
                    options: ["Prendre la mère et les œufs", "Tout laisser", "Prendre seulement la mère", "Renvoyer la mère avant de prendre les œufs"],
                    correctAnswer: 3,
                    explanation: "C'est la mitsva de Shilouah Haken - renvoyer la mère."
                ),
                QuizQuestion(
                    question: "Doit-on rendre un objet perdu ?",
                    options: ["Oui, c'est une mitsva", "Non", "Seulement si on connaît le propriétaire", "Seulement les objets de valeur"],
                    correctAnswer: 0,
                    explanation: "Rendre les objets perdus est une mitsva importante."
                ),
                QuizQuestion(
                    question: "Que dit la Torah sur les poids et mesures ?",
                    options: ["On peut tricher", "Seulement pour la nourriture", "Ils doivent être justes et honnêtes", "Rien"],
                    correctAnswer: 2,
                    explanation: "Avoir des poids et mesures justes est une obligation."
                )
            ]
        ),
        
        "Ki Tavo": ParashaQuiz(
            parashaName: "Ki Tavo",
            hebrewName: "כי תבוא",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Ki Tavo' ?",
                    options: ["Quand tu sortiras", "Quand tu entreras", "Quand tu parleras", "Quand tu construiras"],
                    correctAnswer: 1,
                    explanation: "Ki Tavo signifie 'quand tu entreras' dans le pays."
                ),
                QuizQuestion(
                    question: "Qu'est-ce que les Bikourim ?",
                    options: ["Les premiers fruits offerts au Temple", "Les premiers-nés", "Les premières prières", "Les premiers vêtements"],
                    correctAnswer: 0,
                    explanation: "Les Bikourim sont les premiers fruits apportés au Temple."
                ),
                QuizQuestion(
                    question: "Où les bénédictions et malédictions ont-elles été proclamées ?",
                    options: ["Au Sinaï", "En Égypte", "À Jérusalem", "Sur les monts Gerizim et Eival"],
                    correctAnswer: 3,
                    explanation: "Les bénédictions sur le mont Gerizim, les malédictions sur le mont Eival."
                ),
                QuizQuestion(
                    question: "Pourquoi devons-nous être reconnaissants ?",
                    options: ["Pour tout ce que D.ieu nous a donné", "Pour nos richesses", "Pour notre force", "Pour notre beauté"],
                    correctAnswer: 0,
                    explanation: "On doit reconnaître toutes les bontés de D.ieu."
                )
            ]
        ),
        
        "Nitzavim": ParashaQuiz(
            parashaName: "Nitzavim",
            hebrewName: "נצבים",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Nitzavim' ?",
                    options: ["Assis", "Debout/Présents", "Marchant", "Dormant"],
                    correctAnswer: 1,
                    explanation: "Nitzavim signifie 'vous êtes tous debout/présents'."
                ),
                QuizQuestion(
                    question: "Qui était inclus dans l'alliance avec D.ieu ?",
                    options: ["Seulement les hommes", "Seulement les adultes", "Tout le monde, des chefs aux porteurs d'eau", "Seulement les prêtres"],
                    correctAnswer: 2,
                    explanation: "Tous étaient inclus : hommes, femmes, enfants, étrangers."
                ),
                QuizQuestion(
                    question: "La Torah est-elle trop difficile à suivre ?",
                    options: ["Oui, très difficile", "Non, elle est proche de nous, dans notre bouche et notre cœur", "Seulement pour les sages", "Seulement pour les prêtres"],
                    correctAnswer: 1,
                    explanation: "La Torah n'est pas au ciel, elle est accessible à tous."
                ),
                QuizQuestion(
                    question: "Quel choix D.ieu nous demande-t-il de faire ?",
                    options: ["Entre la richesse et la pauvreté", "Entre le travail et le repos", "Entre la guerre et la paix", "Entre la vie et la mort, la bénédiction et la malédiction"],
                    correctAnswer: 3,
                    explanation: "D.ieu dit : 'Choisis la vie !'"
                )
            ]
        ),
        
        "Vayeilech": ParashaQuiz(
            parashaName: "Vayeilech",
            hebrewName: "וילך",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Vayelech' ?",
                    options: ["Et il parla", "Et il alla", "Et il s'assit", "Et il dormit"],
                    correctAnswer: 1,
                    explanation: "Vayelech signifie 'et il alla' - Moïse alla vers le peuple."
                ),
                QuizQuestion(
                    question: "Quel âge avait Moïse ?",
                    options: ["120 ans", "80 ans", "100 ans", "150 ans"],
                    correctAnswer: 0,
                    explanation: "Moïse avait 120 ans le jour de sa mort."
                ),
                QuizQuestion(
                    question: "Qu'est-ce que le Hakhel ?",
                    options: ["Une fête", "Un sacrifice", "Le rassemblement de tout le peuple pour lire la Torah", "Une guerre"],
                    correctAnswer: 2,
                    explanation: "Tous les 7 ans, tout le peuple se rassemblait pour entendre la Torah."
                ),
                QuizQuestion(
                    question: "Vayelech est-elle la plus courte Paracha ?",
                    options: ["Oui", "Non"],
                    correctAnswer: 0,
                    explanation: "Vayelech est la plus courte Paracha avec seulement 30 versets."
                )
            ]
        ),
        
        "Ha'azinu": ParashaQuiz(
            parashaName: "Ha'azinu",
            hebrewName: "האזינו",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Haazinu' ?",
                    options: ["Parlez", "Écoutez/Prêtez l'oreille", "Marchez", "Voyez"],
                    correctAnswer: 1,
                    explanation: "Haazinu signifie 'Écoutez' ou 'Prêtez l'oreille'."
                ),
                QuizQuestion(
                    question: "Sous quelle forme est écrite cette Paracha ?",
                    options: ["En prose", "En poème/cantique", "En liste", "En dialogue"],
                    correctAnswer: 1,
                    explanation: "Haazinu est un poème, le cantique de Moïse."
                ),
                QuizQuestion(
                    question: "À qui Moïse demande-t-il de témoigner ?",
                    options: ["Aux anges", "Aux nations", "Aux animaux", "Au ciel et à la terre"],
                    correctAnswer: 3,
                    explanation: "Moïse prend le ciel et la terre comme témoins éternels."
                ),
                QuizQuestion(
                    question: "D'où Moïse a-t-il vu la Terre Promise ?",
                    options: ["Du Mont Sinaï", "De la mer", "Du Mont Nebo", "Du désert"],
                    correctAnswer: 2,
                    explanation: "Moïse a vu la Terre Promise depuis le Mont Nebo."
                )
            ]
        ),
        
        "Vezot Haberakhah": ParashaQuiz(
            parashaName: "Vezot Haberakhah",
            hebrewName: "וזאת הברכה",
            questions: [
                QuizQuestion(
                    question: "Que signifie 'Vezot Haberakhah' ?",
                    options: ["Et voici les paroles", "Et voici la bénédiction", "Et voici la fin", "Et voici le voyage"],
                    correctAnswer: 1,
                    explanation: "Vezot Haberakhah signifie 'Et voici la bénédiction'."
                ),
                QuizQuestion(
                    question: "Qui Moïse a-t-il béni avant de mourir ?",
                    options: ["Chacune des 12 tribus", "Josué seulement", "Les Égyptiens", "Les étrangers"],
                    correctAnswer: 0,
                    explanation: "Moïse a béni chacune des 12 tribus d'Israël."
                ),
                QuizQuestion(
                    question: "Qui a enterré Moïse ?",
                    options: ["Josué", "Aaron", "D.ieu Lui-même", "Les anciens"],
                    correctAnswer: 2,
                    explanation: "D.ieu Lui-même a enterré Moïse, et personne ne connaît sa tombe."
                ),
                QuizQuestion(
                    question: "Quand lit-on cette Paracha ?",
                    options: ["À Pessah", "À Yom Kippour", "À Chavouot", "À Simhat Torah"],
                    correctAnswer: 3,
                    explanation: "On lit Vezot Haberakhah à Simhat Torah, quand on finit et recommence la Torah."
                )
            ]
        )
    ]
    
    // MARK: - Helper Methods
    static func getQuiz(for parashaName: String) -> ParashaQuiz? {
        // Recherche exacte par clé
        if let quiz = quizzes[parashaName] {
            return quiz
        }
        
        // Nettoyer le nom (enlever préfixes)
        let cleanedName = parashaName
            .replacingOccurrences(of: "פרשת ", with: "")
            .replacingOccurrences(of: "Parashat ", with: "")
            .replacingOccurrences(of: "Parshat ", with: "")
            .replacingOccurrences(of: "Parachah ", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        // Recherche exacte avec nom nettoyé
        if let quiz = quizzes[cleanedName] {
            return quiz
        }
        
        // Recherche par nom normalisé exact
        let normalizedInput = normalizeParashaName(cleanedName)
        for (key, quiz) in quizzes {
            if normalizeParashaName(key) == normalizedInput {
                return quiz
            }
        }
        
        // Recherche avec correspondance de similarité (pour gérer Vayehi vs Vayechi, etc.)
        for (key, quiz) in quizzes {
            let normalizedKey = normalizeParashaName(key)
            if areSimilarParashaNames(normalizedInput, normalizedKey) {
                return quiz
            }
        }
        
        // Recherche par nom hébreu exact
        for (_, quiz) in quizzes {
            if quiz.hebrewName == parashaName || quiz.hebrewName == cleanedName {
                return quiz
            }
        }
        
        // Recherche partielle (nom anglais ou hébreu)
        for (key, quiz) in quizzes {
            if cleanedName.localizedCaseInsensitiveContains(key) ||
               key.localizedCaseInsensitiveContains(cleanedName) ||
               cleanedName.contains(quiz.hebrewName) ||
               quiz.hebrewName.contains(cleanedName) {
                return quiz
            }
        }
        
        // Recherche partielle avec nom normalisé
        for (key, _) in quizzes {
            let normalizedKey = normalizeParashaName(key)
            if normalizedInput.contains(normalizedKey) || normalizedKey.contains(normalizedInput) {
                return quizzes[key]
            }
        }
        
        // Gérer les parachiot combinées (ex: "Tazria-Metzora" -> retourner "Tazria")
        if cleanedName.contains("-") {
            let parts = cleanedName.split(separator: "-")
            if let firstPart = parts.first {
                return getQuiz(for: String(firstPart))
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
}
