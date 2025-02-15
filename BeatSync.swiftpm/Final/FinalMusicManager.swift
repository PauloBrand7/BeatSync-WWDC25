import AVFoundation
import Accelerate

class FinalMusicManager: ObservableObject {
    private var playerNodes: [AVAudioPlayerNode] = []
    private var varispeedNodes: [AVAudioUnitVarispeed] = []
    private var engine = AVAudioEngine()
    private var mixer = AVAudioMixerNode()
    var reverb = AVAudioUnitReverb()
    
    // default reverb config
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
    
    @Published var audioLevels: [Float] = Array(repeating: 0.0, count: 10)
    
    let fftSize: Int = 512
    private let sampleRate: Double
    
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
        self.sampleRate = engine.outputNode.outputFormat(forBus: 0).sampleRate
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        reverb.loadFactoryPreset(.mediumHall)
        reverb.wetDryMix = 30.0
        
        engine.attach(mixer)
        engine.attach(reverb)
        engine.connect(mixer, to: reverb, format: nil)
        engine.connect(reverb, to: engine.outputNode, format: nil)
        
        setupAudioTap()
        
        do {
            try engine.start()
        } catch {
            print("Error starting engine: \(error)")
        }
    }
    
    func loadTracks(drums: String?, synth: String?, bass: String?, background: String?) {
        let trackNames = [drums, synth, bass, background].compactMap { $0 }
        for track in trackNames {
            guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
                print("Track not found: \(track)")
                continue
            }
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
                print("Error loading track \(track): \(error)")
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
        for playerNode in playerNodes where !playerNode.isPlaying {
            playerNode.play()
        }
    }
    
    func stop() {
        for playerNode in playerNodes {
            playerNode.stop()
        }
    }
    
    private func setupAudioTap() {
        let format = mixer.outputFormat(forBus: 0)
        let bufferSize: AVAudioFrameCount = 1024
        mixer.installTap(onBus: 0, bufferSize: bufferSize, format: format) { [weak self] buffer, _ in
            self?.processAudioBuffer(buffer: buffer)
        }
    }
    
    private func processAudioBuffer(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else {
            print("No channel data")
            return
        }
        let log2n = vDSP_Length(log2(Float(fftSize)))
        guard let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2)) else {
            print("FFT setup error")
            return
        }
        // store fft values
        var realp = [Float](repeating: 0.0, count: fftSize / 2)
        var imagp = [Float](repeating: 0.0, count: fftSize / 2)
        var splitComplex = DSPSplitComplex(realp: &realp, imagp: &imagp)
        channelData.withMemoryRebound(to: DSPComplex.self, capacity: fftSize) { pointer in
            vDSP_ctoz(pointer, 2, &splitComplex, 1, vDSP_Length(fftSize / 2))
        }
        vDSP_fft_zrip(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_FORWARD))
        
        // get audio low frequency
        let lowFrequency = (0..<5).reduce(0) { $0 + hypot(splitComplex.realp[$1], splitComplex.imagp[$1]) }
        vDSP_destroy_fftsetup(fftSetup)
        DispatchQueue.main.async {
            self.audioLevels = [lowFrequency]
        }
    }
}

