
import SwiftUI

public enum CornerSpec: Equatable { case device, custom(CGFloat) }

public enum GlowRecipe { case figma1, figma2, figma3, figma4
    var baseAngle: Double { 180 }
    var stops: [Gradient.Stop] {
        switch self {
        case .figma1: return [
            .init(color: Color(hex:"C686FF"), location: 0.00),
            .init(color: Color(hex:"BC82F3"), location: 0.20),
            .init(color: Color(hex:"F5B9EA"), location: 0.25),
            .init(color: Color(hex:"8D99FF"), location: 0.34),
            .init(color: Color(hex:"AA6EEE"), location: 0.53),
            .init(color: Color(hex:"FF6778"), location: 0.62),
            .init(color: Color(hex:"FFBA71"), location: 0.71),
            .init(color: Color(hex:"C686FF"), location: 0.80),
            .init(color: Color(hex:"BC82F3"), location: 1.00),
        ]
        case .figma2: return [
            .init(color: Color(hex:"FF6778"), location: 0.00),
            .init(color: Color(hex:"AA6EEE"), location: 0.28),
            .init(color: Color(hex:"8D99FF"), location: 0.32),
            .init(color: Color(hex:"F5B9EA"), location: 0.41),
            .init(color: Color(hex:"FFBA71"), location: 0.44),
            .init(color: Color(hex:"BC82F3"), location: 0.46),
            .init(color: Color(hex:"C686FF"), location: 0.52),
            .init(color: Color(hex:"FF6778"), location: 0.72),
            .init(color: Color(hex:"AA6EEE"), location: 1.00),
        ]
        case .figma3: return [
            .init(color: Color(hex:"8D99FF"), location: 0.00),
            .init(color: Color(hex:"C686FF"), location: 0.25),
            .init(color: Color(hex:"F5B9EA"), location: 0.31),
            .init(color: Color(hex:"FFBA71"), location: 0.40),
            .init(color: Color(hex:"AA6EEE"), location: 0.43),
            .init(color: Color(hex:"FF6778"), location: 0.50),
            .init(color: Color(hex:"BC82F3"), location: 0.62),
            .init(color: Color(hex:"8D99FF"), location: 0.75),
            .init(color: Color(hex:"C686FF"), location: 1.00),
        ]
        case .figma4: return [
            .init(color: Color(hex:"BC82F3"), location: 0.00),
            .init(color: Color(hex:"C686FF"), location: 0.20),
            .init(color: Color(hex:"FFBA71"), location: 0.29),
            .init(color: Color(hex:"FF6778"), location: 0.38),
            .init(color: Color(hex:"AA6EEE"), location: 0.47),
            .init(color: Color(hex:"8D99FF"), location: 0.65),
            .init(color: Color(hex:"F5B9EA"), location: 0.74),
            .init(color: Color(hex:"BC82F3"), location: 0.80),
            .init(color: Color(hex:"C686FF"), location: 1.00),
        ]
        }
    }
}

private extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var v: UInt64 = 0; Scanner(string: s).scanHexInt64(&v)
        self.init(.sRGB,
                  red:   Double((v >> 16) & 0xFF)/255,
                  green: Double((v >>  8) & 0xFF)/255,
                  blue:  Double((v >>  0) & 0xFF)/255,
                  opacity: 1)
    }
}

/// Bright, rotating border with inner-only emission (blend) and breathing.
public struct BreathingScreenEdges: View {
    // Appearance
    public var edgeThickness: CGFloat = 10      // bright outer ring
    public var featherWidth: CGFloat = 8        // inner emission ring
    public var featherBlur: CGFloat = 12        // softness of inner emission
    public var corner: CornerSpec = .device
    public var recipe: GlowRecipe = .figma1

    // Motion / brightness
    public var rotationPeriod: Double = 4.5     // seconds per full spin (lower = faster)
    public var breathePeriod:  Double = 2.4     // seconds per in+out
    public var minOpacity:     Double = 0.90    // bright baseline
    public var maxOpacity:     Double = 1.00    // peak

    public init(edgeThickness: CGFloat = 10,
                featherWidth: CGFloat = 8,
                featherBlur: CGFloat = 12,
                corner: CornerSpec = .device,
                recipe: GlowRecipe = .figma1,
                rotationPeriod: Double = 4.5,
                breathePeriod: Double = 2.4,
                minOpacity: Double = 0.90,
                maxOpacity: Double = 1.00) {
        self.edgeThickness = edgeThickness
        self.featherWidth = featherWidth
        self.featherBlur = featherBlur
        self.corner = corner
        self.recipe = recipe
        self.rotationPeriod = rotationPeriod
        self.breathePeriod = breathePeriod
        self.minOpacity = minOpacity
        self.maxOpacity = maxOpacity
    }

    public var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate

            // Breathing brightness
            let phase   = 0.5 + 0.5 * sin(2 * .pi * (t / breathePeriod))  // 0→1→0
            let opacity = minOpacity + (maxOpacity - minOpacity) * phase

            // Continuous conic rotation
            let angle = (t.truncatingRemainder(dividingBy: rotationPeriod) / rotationPeriod) * 360
            let gradient = AngularGradient(
                gradient: Gradient(stops: recipe.stops),
                center: .center,
                angle: .degrees(recipe.baseAngle + angle)
            )

            switch corner {
            case .device:
                let shape = ContainerRelativeShape()

                let core = shape
                    .inset(by: edgeThickness/2)
                    .stroke(gradient, lineWidth: edgeThickness) // bright, no blur/blend

                // Inner emission: blurred & blended, but clipped to INSIDE ONLY
                let innerClip = shape.inset(by: edgeThickness) // inside region
                let inner = shape
                    .inset(by: edgeThickness)
                    .stroke(gradient, lineWidth: featherWidth)
                    .blur(radius: featherBlur)
                    .blendMode(.plusLighter)
                    .clipShape(innerClip) // ← ensures the blur bleeds inward, not outward

                ZStack { core; inner }
                    .opacity(opacity)
                    .clipShape(shape)
                    .compositingGroup()
                    .ignoresSafeArea(.container, edges: .all)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

            case .custom(let r):
                let shape = RoundedRectangle(cornerRadius: r, style: .continuous)

                let core = shape
                    .inset(by: edgeThickness/2)
                    .stroke(gradient, lineWidth: edgeThickness)

                let innerClip = shape.inset(by: edgeThickness)
                let inner = shape
                    .inset(by: edgeThickness)
                    .stroke(gradient, lineWidth: featherWidth)
                    .blur(radius: featherBlur)
                    .blendMode(.plusLighter)
                    .clipShape(innerClip)

                ZStack { core; inner }
                    .opacity(opacity)
                    .clipShape(shape)
                    .compositingGroup()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
    }
}
