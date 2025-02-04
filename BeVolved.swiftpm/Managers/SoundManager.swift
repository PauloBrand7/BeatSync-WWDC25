import AVFoundation

actor SoundManager {
    private var player: AVAudioPlayer?
    
    func playBackgroundSound(type: String) async {
        let soundName = getLocalSoundFile(type: type)
        
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
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
    
    private func getLocalSoundFile(type: String) -> String {
        switch type {
        case "ocean":
            return "ocean-waves"
        case "rain":
            return "rain"
        case "nature":
            return "nature"
        default:
            return type
        }
    }
}
