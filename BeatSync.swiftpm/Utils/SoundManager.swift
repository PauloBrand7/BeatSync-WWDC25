import AVFoundation

actor SoundManager {
    private var player: AVAudioPlayer?
    
    func playBackgroundSound(soundName: String) {
        
        guard let soundURL = Bundle.main.url(
            forResource: soundName, withExtension: "mp3"
        ) else {
            print("Sound file not found: \(soundName)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: soundURL)
            player?.numberOfLoops = -1
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
    
    func stop() {
        player?.stop()
        player = nil
    }
}
