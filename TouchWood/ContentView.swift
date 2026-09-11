import SwiftUI

private struct Ripple: Identifiable {
    let id = UUID()
    let location: CGPoint
}

struct ContentView: View {
    private let messages = [
        "Safe.", "Warded off.", "Nothing tempted.", "Jinx avoided.", "Fate untempted.",
        "All good.", "Bad luck deflected.", "You're covered.", "Steady now.",
        "Crisis averted.", "Knocked. Noted.", "Untempted.", "Whew.", "Well warded."
    ]

    @StateObject private var stats = Stats.shared

    @AppStorage("soundOn") private var soundOn = true
    @AppStorage("hapticsOn") private var hapticsOn = true

    @State private var ripples: [Ripple] = []
    @State private var message = ""
    @State private var showMessage = false
    @State private var pressed = false
    @State private var showHint = true
    @State private var lastMessage = -1
    @State private var showSettings = false

    private let cream = Color(red: 1.0, green: 0.94, blue: 0.86)

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 0.16, green: 0.10, blue: 0.05).ignoresSafeArea()

                Image("Wood")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .scaleEffect(pressed ? 0.986 : 1.0)
                    .brightness(pressed ? -0.04 : 0)
                    .animation(.easeOut(duration: 0.09), value: pressed)
                    .ignoresSafeArea()

                // Expanding rings where you touched.
                ForEach(ripples) { r in
                    Circle()
                        .strokeBorder(Color(red: 1.0, green: 0.93, blue: 0.82).opacity(0.7), lineWidth: 2)
                        .frame(width: 40, height: 40)
                        .position(r.location)
                        .modifier(RippleAnimation())
                }

                // Reassurance message.
                Text(message)
                    .font(.system(size: 46, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(red: 1.0, green: 0.95, blue: 0.89))
                    .shadow(color: .black.opacity(0.55), radius: 12, y: 2)
                    .opacity(showMessage ? 1 : 0)
                    .scaleEffect(showMessage ? 1 : 0.9)
                    .animation(.easeOut(duration: 0.18), value: showMessage)
                    .allowsHitTesting(false)

                if showHint {
                    VStack {
                        Spacer()
                        Text("TAP THE WOOD")
                            .font(.system(size: 15, weight: .regular))
                            .tracking(3)
                            .foregroundStyle(cream.opacity(0.55))
                            .padding(.bottom, 34)
                    }
                    .transition(.opacity)
                    .allowsHitTesting(false)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in knock(at: value.location) }
            )
            .accessibilityElement(children: .ignore)
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Wood surface")
            .accessibilityHint("Knocks on wood")
            .accessibilityValue(showMessage ? message : "")
            .accessibilityAction {
                knock(at: CGPoint(x: geo.size.width / 2, y: geo.size.height / 2))
            }
            .overlay(alignment: .top) { topBar }
        }
        .ignoresSafeArea()
        .persistentSystemOverlays(.hidden)
        .sheet(isPresented: $showSettings) {
            SettingsView(stats: stats)
        }
    }

    private var topBar: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 1) {
                Text(knockLabel)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(cream.opacity(0.72))
                if stats.streak > 0 {
                    Text(streakLabel)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundStyle(cream.opacity(0.5))
                }
            }
            .shadow(color: .black.opacity(0.5), radius: 6, y: 1)
            .allowsHitTesting(false)
            .accessibilityElement(children: .combine)

            Spacer()

            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(cream.opacity(0.6))
                    .shadow(color: .black.opacity(0.5), radius: 6, y: 1)
                    .frame(width: 44, height: 44, alignment: .topTrailing)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Settings")
        }
        .padding(.horizontal, 22)
        .padding(.top, 8)
    }

    private var knockLabel: String {
        stats.total == 1 ? "1 knock" : "\(stats.total.formatted()) knocks"
    }

    private var streakLabel: String {
        stats.streak == 1 ? "1 day streak" : "\(stats.streak) day streak"
    }

    private func knock(at point: CGPoint) {
        if hapticsOn { Haptics.shared.knock() }
        if soundOn { SoundPlayer.shared.knock() }
        stats.record()

        let r = Ripple(location: point)
        ripples.append(r)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            ripples.removeAll { $0.id == r.id }
        }

        pressed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { pressed = false }

        var i = Int.random(in: 0..<messages.count)
        while i == lastMessage && messages.count > 1 { i = Int.random(in: 0..<messages.count) }
        lastMessage = i
        message = messages[i]
        showMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 0.35)) { showMessage = false }
        }

        if showHint { withAnimation(.easeOut(duration: 0.5)) { showHint = false } }
    }
}

/// Drives the grow-and-fade of each ripple ring.
private struct RippleAnimation: ViewModifier {
    @State private var animate = false
    func body(content: Content) -> some View {
        content
            .scaleEffect(animate ? 9 : 0.3)
            .opacity(animate ? 0 : 0.9)
            .onAppear {
                withAnimation(.easeOut(duration: 0.55)) { animate = true }
            }
    }
}

#Preview {
    ContentView()
}
