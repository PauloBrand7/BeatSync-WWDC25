import AVFoundation

class FinalMusicManager: ObservableObject {
    var playerNodes: [AVAudioPlayerNode] = []
    var varispeedNodes: [AVAudioUnitVarispeed] = []
    var engine = AVAudioEngine()
    var reverb = AVAudioUnitReverb()
    var mixer = AVAudioMixerNode()
    
    @Published var selectedReverbName: String = "Medium Hall" {
        didSet {
            if let preset = reverbPresetMapping[selectedReverbName] {
                reverb.loadFactoryPreset(preset)
            }
        }
    }
    
    @Published var reverbIntensity: Float = 30.0 {
        didSet {
            reverb.wetDryMix = reverbIntensity
        }
    }
    
    let reverbPresetNames: [String] = [
        "Small Room",
        "Medium Room",
        "Medium Room 2",
        "Large Room",
        "Medium Hall",
        "Medium Hall 2",
        "Medium Hall 3",
        "Large Hall",
        "Large Hall 2",
        "Medium Chamber",
        "Large Chamber",
        "Plate",
        "Cathedral"
    ]
    
    let reverbPresetMapping: [String: AVAudioUnitReverbPreset] = [
        "Small Room": .smallRoom,
        "Medium Room": .mediumRoom,
        "Large Room": .largeRoom,
        "Medium Hall": .mediumHall,
        "Large Hall": .largeHall,
        "Plate": .plate,
        "Medium Chamber": .mediumChamber,
        "Large Chamber": .largeChamber,
        "Cathedral": .cathedral,
        "Large Room 2": .largeRoom2,
        "Medium Hall 2": .mediumHall2,
        "Medium Hall 3": .mediumHall3,
        "Large Hall 2": .largeHall2
    ]
    
    init() {
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        reverb.loadFactoryPreset(.mediumHall)
        reverb.wetDryMix = 30.0
        
        engine.attach(mixer)
        engine.attach(reverb)
        engine.connect(mixer, to: reverb, format: nil)
        engine.connect(reverb, to: engine.outputNode, format: nil)
        
        do {
            try engine.start()
        } catch {
            print("Error starting engine: \(error)")
        }
    }
    
    func loadTracks(drums: String?, synth: String?, bass: String?, background: String?) {
        let tracks = [drums, synth, bass, background].compactMap { $0 }
        for track in tracks {
            if let url = Bundle.main.url(forResource: track, withExtension: "mp3") {
                print("Loading track: \(track)")
                do {
                    let playerNode = AVAudioPlayerNode()
                    let varispeedNode = AVAudioUnitVarispeed()
                    
                    engine.attach(playerNode)
                    engine.attach(varispeedNode)
                    
                    let audioFile = try AVAudioFile(forReading: url)
                    let audioFormat = audioFile.processingFormat
                    
                    engine.connect(playerNode, to: varispeedNode, format: audioFormat)
                    engine.connect(varispeedNode, to: mixer, format: audioFormat)
                    
                    playerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
                    
                    playerNodes.append(playerNode)
                    varispeedNodes.append(varispeedNode)
                } catch {
                    print("Error loading track: \(track) - \(error)")
                }
            }
        }
    }
    
    func adjustRate(for bpm: Int) {
        let rate = Float(bpm) / 80.0
        for varispeedNode in varispeedNodes {
            varispeedNode.rate = rate
        }
    }
    
    func play() {
        for playerNode in playerNodes {
            if !playerNode.isPlaying {
                playerNode.play()
            }
        }
    }
    
    func stop() {
        for playerNode in playerNodes {
            playerNode.stop()
        }
    }
}
