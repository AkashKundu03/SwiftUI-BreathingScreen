# SwiftUI-BreathingScreen
Siri style rotating + breathing gradient edge glow for SwiftUI (iPhone &amp; iPad).


A reusable **SwiftUI** component that recreates a **Siri-style breathing screen animation** with **rotating conic gradients** and a **bright, crisp edge** that **blends only on the inner wall** (light “leaks” inward).  
Perfect for hero screens, loading states, or ambient UI.

> Works on **iPhone & iPad**. Device corners are respected (iPad uses container corners, iPhone uses a tuned hardware-like radius).

---

## 🎥 Demo

- `docs/demo.mp4` (screen recording)  
- `docs/screenshot.png` (static)  

> Add your own recording (10–20s). On macOS: **Cmd + Shift + 5** to capture.

---

## ✨ What you get

- **Siri-style motion**: fast **rotation** + subtle **breathing** (brightness in↔out).
- **Inner-only blend**: outer ring stays **crisp & saturated**; inner feather softly **melts into the screen**.
- **Figma-accurate palettes**: 4 conic gradient **recipes** (`figma1 … figma4`) derived from your design.
- **Corner correctness**:
  - `.device` → matches iPad/window container rounding.
  - `.custom(CGFloat)` → matches iPhone 16/Pro style hardware corners.
- **Tunable**: thickness, feather width, blur, brightness min/max, rotation speed, breathing speed.

---

## 🖼️ Design rationale (why this looks “Apple”)

Most glow tutorials blur the entire stroke → the color gets dull/washed.  
We do the opposite:

- **Outer Ring (Core)**: _no blur, no blend_ → maximum brightness & color fidelity.  
- **Inner Feather**: _narrower, blurred, blended_ → only the **inner wall** emits light into the screen.  
- Result: **crisp color** + **premium diffusion** → **Apple Intelligence / Siri** vibe.

---

## 📦 Quick start

### 1) Copy the component
Drop **`BreathingScreenEdges.swift`** into your SwiftUI project.

### 2) Use it

```swift
import SwiftUI

struct ContentView: View {
    private var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            // Siri-style breathing + rotating conic gradient edges
            BreathingScreenEdges(
                edgeThickness: isPad ? 8 : 5,
                featherWidth:  isPad ? 16 : 8,
                featherBlur:   isPad ? 5 : 3,
                corner:        isPad ? .device : .custom(55),
                recipe:        .figma4,   // .figma1 / .figma2 / .figma3 / .figma4
                rotationPeriod: 4.0,      // lower = faster spin
                breathePeriod:  2.2,      // bright↔dim cycle
                minOpacity:     0.92,     // bright baseline
                maxOpacity:     1.00      // peak
            )

            VStack(spacing: 12) {
                // Multicolor headline (gradient-filled text)
                let titleFont: Font = .system(size: 56, weight: .heavy, design: .rounded)
                let gradient = LinearGradient(
                    colors: [
                        Color(hex: "C686FF"), Color(hex: "BC82F3"),
                        Color(hex: "F5B9EA"), Color(hex: "8D99FF"),
                        Color(hex: "AA6EEE"), Color(hex: "FF6778"),
                        Color(hex: "FFBA71")
                    ],
                    startPoint: .leading, endPoint: .trailing
                )
                let title = Text("Welcome to\nLoominote")
                    .font(titleFont)
                    .multilineTextAlignment(.center)

                title
                    .overlay(gradient)
                    .mask(title)

                Text("You don't just capture voice notes,\nYou organize your ideas")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
}

```

Figma → SwiftUI color recipes

Four conic gradient recipes derived from your Figma file (fixed base angle 180°; stops preserved):

figma1 → Purple/Pink dominant

figma2 → Warm Red/Violet

figma3 → Blue/Orange balance

figma4 → Rainbow mix

Switch with:

BreathingScreenEdges(recipe: .figma2)

⚙️ API
BreathingScreenEdges(
  edgeThickness: CGFloat = 10,     // bright outer ring thickness
  featherWidth:  CGFloat = 8,      // inner glow ring width
  featherBlur:   CGFloat = 12,     // softness of inner emission
  corner:        CornerSpec = .device, // .device or .custom(CGFloat)
  recipe:        GlowRecipe = .figma1, // figma1..4
  rotationPeriod: Double = 4.5,     // seconds per full spin (lower = faster)
  breathePeriod:  Double = 2.4,     // in+out time
  minOpacity:     Double = 0.90,    // bright baseline
  maxOpacity:     Double = 1.00     // peak
)

Types
enum CornerSpec { case device, custom(CGFloat) }
enum GlowRecipe { case figma1, figma2, figma3, figma4 }

📚 How others can benefit & apply this

Indie devs / startups — ship Apple-grade polish fast without motion-design overhead.

Designers — validate Figma palettes in real UI with live previews.

Teams — reuse a single component for onboarding, loading, AI prompts, ambient scenes.

Educators — demonstrate SwiftUI animation, blending, masking, and conic gradients with a production-ready example.

This component helps you:

Keep clarity: crisp color, not washed-out glows.

Add depth: subtle inner emission, not noisy outer bloom.

Convey motion: smooth, flicker-free, time-driven animation.

Troubleshooting

I only see a white screen (no glow).

Don’t use .screen blending across the whole ring on white backgrounds — the glow disappears.

This component keeps the outer ring unblended and blends only the inner feather.

If still faint: bump minOpacity (e.g., 0.95), edgeThickness (+2), or featherBlur (+2).

Corners don’t match my iPhone.

Use corner: .custom(…) and tune 60–68.

iPad should use .device to match its container rounding.

Flicker at loop points.

We use TimelineView(.animation) with continuous time — no endpoint jumps.

Performance on older devices.

It’s light, but if needed reduce featherBlur, or increase rotationPeriod to slow the spin

Contributing

Fork the repo

Create a feature branch

Open a PR with a short video/screenshot of your change

We welcome:

Additional Figma palettes (with stops)

Performance & accessibility tweaks

New animation modes (ripple, pulse, orbit)

🙏 Credits

Design: Design inspiration while building the Loominote app (Figma color palettes)

Development: Akash Kundu

Inspiration: Apple SwiftUI + Apple Intelligence design system


<img width="355" height="726" alt="Image" src="https://github.com/user-attachments/assets/e652f53c-ed05-4761-b557-d0552dc6f98b" />
