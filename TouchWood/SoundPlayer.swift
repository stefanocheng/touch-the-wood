import AVFoundation

/// Plays the wooden knock sound. Keeps a small pool of players so rapid taps
/// overlap cleanly. Uses the ambient category so it layers over other audio
/// and respects the silent switch (haptics still fire when muted).
final class SoundPlayer {
    static let shared = SoundPlayer()

    private var players: [AVAudioPlayer] = []
    private var index = 0

    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)

        if let url = Bundle.main.url(forResource: "knock", withExtension: "wav") {
            for _ in 0..<4 {
                if let p = try? AVAudioPlayer(contentsOf: url) {
                    // enableRate must be set before prepareToPlay, or rate changes are ignored.
                    p.enableRate = true
                    p.prepareToPlay()
                    players.append(p)
                }
            }
        }
    }

    func knock() {
        guard !players.isEmpty else { return }
        let p = players[index]
        index = (index + 1) % players.count
        p.currentTime = 0
        // Slight random pitch and volume so repeats do not sound identical.
        p.rate = Float.random(in: 0.94...1.06)
        p.volume = Float.random(in: 0.85...1.0)
        p.play()
    }
}
