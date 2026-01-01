//
//  LiquidGlassStyle.swift
//  monChabat
//
//  Design System inspiré du style "Liquid Glass" d'iOS 26
//  Effets de transparence, blur, et reflets dynamiques
//

import SwiftUI

// MARK: - Couleurs de l'application
extension Color {
    // Couleurs principales - Teintes chaudes pour Shabbat
    static let shabGold = Color(red: 0.95, green: 0.78, blue: 0.45)
    static let shabWarmWhite = Color(red: 1.0, green: 0.98, blue: 0.94)
    static let shabDeepBlue = Color(red: 0.25, green: 0.40, blue: 0.60) // Bleu profond lisible
    static let shabSoftPurple = Color(red: 0.55, green: 0.40, blue: 0.70) // Violet plus foncé, lisible en clair et sombre
    static let shabCandleOrange = Color(red: 1.0, green: 0.65, blue: 0.3)
    static let shabBlue = Color(red: 0.30, green: 0.55, blue: 0.85) // Bleu lisible dans les deux modes
    
    // Couleurs pour les catégories
    static let meatRed = Color(red: 0.85, green: 0.30, blue: 0.30)
    static let dairyBlue = Color(red: 0.35, green: 0.60, blue: 0.90)
    static let parveGreen = Color(red: 0.30, green: 0.70, blue: 0.45)
    
    // Glass colors
    static let glassBackground = Color.white.opacity(0.15)
    static let glassBorder = Color.white.opacity(0.3)
    static let glassHighlight = Color.white.opacity(0.5)
}

// MARK: - Gradient Definitions
struct AppGradients {
    static let shabbatSunset = LinearGradient(
        colors: [
            Color(red: 0.95, green: 0.6, blue: 0.4),
            Color(red: 0.85, green: 0.45, blue: 0.55),
            Color(red: 0.35, green: 0.25, blue: 0.5)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let candleGlow = RadialGradient(
        colors: [
            Color.shabCandleOrange.opacity(0.8),
            Color.shabGold.opacity(0.4),
            Color.clear
        ],
        center: .center,
        startRadius: 0,
        endRadius: 150
    )
    
    static let glassShine = LinearGradient(
        colors: [
            Color.white.opacity(0.4),
            Color.white.opacity(0.1),
            Color.white.opacity(0.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let nightSky = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.1, blue: 0.2),
            Color(red: 0.15, green: 0.2, blue: 0.35),
            Color(red: 0.25, green: 0.3, blue: 0.45)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Liquid Glass Card Modifier
struct LiquidGlassCard: ViewModifier {
    var cornerRadius: CGFloat = 24
    var opacity: CGFloat = 0.12
    var blur: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(Color.white.opacity(opacity))
                    }
                    .overlay {
                        // Liséré doré glass
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.shabGold.opacity(0.5),
                                        Color.shabGold.opacity(0.25),
                                        Color.shabGold.opacity(0.15)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
            }
    }
}

// MARK: - Floating Glass Button Style
struct LiquidGlassButtonStyle: ButtonStyle {
    var isAccent: Bool = false
    
    @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background {
                if isAccent {
                    Capsule()
                        .fill(Color.shabGold.opacity(0.9))
                        .overlay {
                            Capsule()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.6),
                                            Color.white.opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        }
                        .shadow(color: Color.shabGold.opacity(0.4), radius: 10, y: 5)
                } else {
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .overlay {
                            Capsule()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.6),
                                            Color.white.opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 5)
                }
            }
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Glass Tab Bar Item
struct GlassTabItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                    .symbolEffect(.bounce, value: isSelected)
                
                Text(title)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
            }
            .foregroundStyle(isSelected ? Color.shabGold : Color.primary.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background {
                if isSelected {
                    Capsule()
                        .fill(Color.shabGold.opacity(0.15))
                        .matchedGeometryEffect(id: "tabIndicator", in: tabNamespace)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    @Namespace private var tabNamespace
}

// MARK: - Glass Section Header
struct GlassSectionHeader: View {
    let title: String
    let icon: String?
    var action: (() -> Void)? = nil
    var actionLabel: String? = nil
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.shabGold)
            }
            
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            Spacer()
            
            if let action = action, let actionLabel = actionLabel {
                Button(action: action) {
                    Text(actionLabel)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.shabGold)
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Animated Candle View
struct AnimatedCandleView: View {
    @State private var flameOffset: CGFloat = 0
    @State private var glowOpacity: Double = 0.6
    
    var body: some View {
        ZStack {
            // Glow effect
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.shabCandleOrange.opacity(glowOpacity),
                            Color.shabGold.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 5,
                        endRadius: 60
                    )
                )
                .frame(width: 120, height: 120)
                .blur(radius: 15)
            
            // Flame
            FlameShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white,
                            Color.yellow,
                            Color.shabCandleOrange
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 20, height: 35)
                .offset(x: flameOffset, y: -25)
            
            // Candle body
            RoundedRectangle(cornerRadius: 4)
                .fill(
                    LinearGradient(
                        colors: [Color.shabWarmWhite, Color.shabWarmWhite.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 24, height: 50)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true)) {
                flameOffset = 2
            }
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                glowOpacity = 0.8
            }
        }
    }
}

// MARK: - Flame Shape
struct FlameShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY * 0.7),
            control: CGPoint(x: rect.maxX + 5, y: rect.midY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.midX + 5, y: rect.maxY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY * 0.7),
            control: CGPoint(x: rect.midX - 5, y: rect.maxY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.minX - 5, y: rect.midY)
        )
        
        return path
    }
}

// MARK: - Glass Progress Ring
struct GlassProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    var size: CGFloat = 80
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: lineWidth)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [Color.shabGold, Color.shabCandleOrange, Color.shabGold],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            // Percentage text
            Text("\(Int(progress * 100))%")
                .font(.system(size: size * 0.25, weight: .bold, design: .rounded))
                .foregroundStyle(Color.primary)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Shimmer Effect
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.white.opacity(0.3),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .offset(x: phase)
                .mask(content)
            }
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = 200
                }
            }
    }
}

// MARK: - View Extensions
extension View {
    func liquidGlassCard(cornerRadius: CGFloat = 24, opacity: CGFloat = 0.12) -> some View {
        modifier(LiquidGlassCard(cornerRadius: cornerRadius, opacity: opacity))
    }
    
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

// MARK: - Custom Haptics
struct HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// MARK: - Flow Layout (pour les tags/thèmes)
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let containerWidth = proposal.width ?? .infinity
        var height: CGFloat = 0
        var currentX: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > containerWidth && currentX > 0 {
                // Nouvelle ligne
                height += currentRowHeight + spacing
                currentX = 0
                currentRowHeight = 0
            }
            
            currentX += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
        
        height += currentRowHeight
        return CGSize(width: containerWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > bounds.maxX && currentX > bounds.minX {
                // Nouvelle ligne
                currentY += currentRowHeight + spacing
                currentX = bounds.minX
                currentRowHeight = 0
            }
            
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: .unspecified)
            currentX += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        AppGradients.shabbatSunset
            .ignoresSafeArea()
        
        VStack(spacing: 30) {
            AnimatedCandleView()
            
            GlassProgressRing(progress: 0.75, lineWidth: 8)
            
            Text("Shabbat Shalom")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding()
                .liquidGlassCard()
            
            Button("Action") {}
                .buttonStyle(LiquidGlassButtonStyle(isAccent: true))
        }
    }
}
