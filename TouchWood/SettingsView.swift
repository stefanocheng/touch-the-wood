import SwiftUI

struct SettingsView: View {
    @ObservedObject var stats: Stats

    @Environment(\.dismiss) private var dismiss
    @AppStorage("soundOn") private var soundOn = true
    @AppStorage("hapticsOn") private var hapticsOn = true
    @State private var confirmReset = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Your knocks") {
                    LabeledContent("Total", value: stats.total.formatted())
                    LabeledContent("Current streak", value: streakText)
                }

                Section("Feedback") {
                    Toggle("Knock sound", isOn: $soundOn)
                    Toggle("Haptics", isOn: $hapticsOn)
                }

                Section {
                    ShareLink(item: shareText) {
                        Label("Share Touch the Wood", systemImage: "square.and.arrow.up")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        confirmReset = true
                    } label: {
                        Text("Reset count and streak")
                    }
                } footer: {
                    Text("Your count stays on this device. Touch the Wood collects nothing and sends nothing anywhere.")
                }
            }
            .navigationTitle("Touch the Wood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .confirmationDialog(
                "Reset your count and streak?",
                isPresented: $confirmReset,
                titleVisibility: .visible
            ) {
                Button("Reset", role: .destructive) { stats.reset() }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    private var streakText: String {
        switch stats.streak {
        case 0: return "None yet"
        case 1: return "1 day"
        default: return "\(stats.streak) days"
        }
    }

    private var shareText: String {
        stats.total == 0
            ? "Touch the Wood: knock on wood, wherever you are."
            : "I've knocked on wood \(stats.total.formatted()) times. Touch the Wood for iPhone."
    }
}

#Preview {
    SettingsView(stats: Stats.shared)
}
