import CoreHaptics
import UIKit

/// Produces a short, sharp "knock" you can feel. Uses CoreHaptics on devices
/// that support it, and falls back to the standard impact generator otherwise.
final class Haptics {
    static let shared = Haptics()

    private var engine: CHHapticEngine?
    private let supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
    private let fallback = UIImpactFeedbackGenerator(style: .rigid)

    private init() {
        fallback.prepare()
        prepareEngine()
        // The system stops the engine when the app leaves the foreground, and a
        // restart from the background does not stick. Restart on the way back in.
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.restart()
        }
    }

    /// Brings the engine back after the app returns to the foreground.
    private func restart() {
        guard supportsHaptics else { return }
        guard let engine else {
            prepareEngine()
            return
        }
        do {
            try engine.start()
        } catch {
            prepareEngine()
        }
    }

    private func prepareEngine() {
        guard supportsHaptics else { return }
        do {
            let e = try CHHapticEngine()
            e.isAutoShutdownEnabled = true
            // Restart automatically if the system stops the engine.
            e.stoppedHandler = { [weak self] _ in try? self?.engine?.start() }
            e.resetHandler = { [weak self] in try? self?.engine?.start() }
            try e.start()
            engine = e
        } catch {
            engine = nil
        }
    }

    /// A single rap on wood: sharp transient with a touch of body.
    func knock() {
        guard supportsHaptics, let engine else {
            fallback.impactOccurred(intensity: 1.0)
            return
        }
        do {
            let tap = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.72)
                ],
                relativeTime: 0
            )
            // A faint second tick a few ms later gives it a wooden "knock" character.
            let tail = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.35),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ],
                relativeTime: 0.045
            )
            let pattern = try CHHapticPattern(events: [tap, tail], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            fallback.impactOccurred(intensity: 1.0)
        }
    }
}
