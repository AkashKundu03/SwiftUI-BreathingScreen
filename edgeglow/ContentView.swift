
import SwiftUI

struct ContentView: View {
    private var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            BreathingScreenEdges(
                edgeThickness: isPad ? 8 : 3,
                featherWidth:  isPad ? 16 : 10,
                featherBlur:   isPad ? 5 : 4,
//                corner:        isPad ? .device : .custom(45),
                corner:        .device,
                recipe:        .figma4,
                rotationPeriod: 4.0,
                breathePeriod:  2.2,
                minOpacity:     0.92,
                maxOpacity:     1.00
            )

            VStack(spacing: 12) {
                // --- Multicolor "Welcome to\nLoominote" ---
                let titleFont: Font = .system(size: 30, weight: .heavy, design: .rounded)

                let welcomeGradient = LinearGradient(
                    colors: [
//                        Color(hex: "C686FF"),
//                        Color(hex: "BC82F3"),
//                        Color(hex: "F5B9EA"),
//                        Color(hex: "8D99FF"),
                        Color(hex: "AA6EEE"),
                        Color(hex: "FF6778"),
                        Color(hex: "FFBA71")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )

                let welcomeText = Text("Welcome to Loominote")
                    .font(titleFont)
                    .multilineTextAlignment(.center)

                welcomeText
                    .overlay(welcomeGradient) // apply gradient overlay
                    .mask(welcomeText)        // mask gradient with text glyphs
                    .drawingGroup()

                Text("You don't just capture voice notes, You \norganize your ideas.")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}

// Small hex helper
private extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var v: UInt64 = 0; Scanner(string: s).scanHexInt64(&v)
        self.init(.sRGB,
                  red:   Double((v >> 16) & 0xFF) / 255.0,
                  green: Double((v >>  8) & 0xFF) / 255.0,
                  blue:  Double((v >>  0) & 0xFF) / 255.0,
                  opacity: 1.0)
    }
}

#Preview { ContentView() }
