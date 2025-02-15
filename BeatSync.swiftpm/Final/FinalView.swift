import SwiftUI

struct FinalView: View {
    var bpm: Int
    var selectedDrums: String?
    var selectedSynth: String?
    var selectedBass: String?
    var selectedBackground: String?
    
    @ObservedObject private var audioManager = FinalMusicManager()
    @State private var isReverbEnabled = true
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
            //3D background
            FinalBackground(
                beatLevel: audioManager.audioLevels.first ?? 0.0
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                Text("Your song is done!")
                    .font(DesignResources.TextStyles.titleFont)
                    .foregroundColor(DesignResources.TextStyles.titleColor)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                
                Text("Harmonizing with your heart at:")
                    .font(DesignResources.TextStyles.textFont)
                    .foregroundColor(DesignResources.TextStyles.textColor)
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)
                
                Text("\(bpm) BPM")
                    .font(DesignResources.TextStyles.titleFont)
                    .foregroundColor(DesignResources.TextStyles.titleColor)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                
                Text(finalMessage(bpm))
                    .font(DesignResources.TextStyles.textFont)
                    .foregroundColor(DesignResources.TextStyles.textColor)
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        if !isPlaying {
                            audioManager.loadTracks(drums: selectedDrums, synth: selectedSynth, bass: selectedBass, background: selectedBackground)
                            audioManager.adjustRate(for: bpm)
                            audioManager.play()
                            isPlaying = true
                        }
                    }) {
                        Text("Play song")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding()
                            .frame(width: 160)
                            .background(DesignResources.ButtonStyles.backgroundDefaultButton)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }
                    
                    Button(action: {
                        audioManager.stop()
                        isPlaying = false
                    }) {
                        Text("Stop Vibe")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding()
                            .frame(width: 160)
                            .background(Color.red.opacity(0.6))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }
                }
                .padding(.bottom, 20)
                
                Toggle(isOn: $isReverbEnabled) {
                    Text("Enhance Atmosphere (Reverb)")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
                .onChange(of: isReverbEnabled) { enabled in
                    audioManager.reverb.bypass = !enabled
                }
                
                if isReverbEnabled {
                    VStack(spacing: 30) {
                        Picker("Reverb Style", selection: $audioManager.selectedReverbName) {
                            ForEach(audioManager.reverbPresetNames, id: \.self) { presetName in
                                Text(presetName)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: 160)
                        .padding()
                        .background(Color.white.opacity(0.80))
                        .cornerRadius(15)
                        
                        VStack {
                            Slider(value: $audioManager.reverbIntensity, in: 0...100, step: 1)
                                .accentColor(.blue)
                            Text("Intensity: \(Int(audioManager.reverbIntensity))%")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 80)
                }
                Spacer()
            }
            .padding()
        }.onDisappear {
            audioManager.stop()
            isPlaying = false
        }
    }
    
    private func finalMessage(_ bpm: Int) -> String {
        switch bpm {
        case 40...84:
            return "A calming rhythm for your mind!"
        case 85...109:
            return "A harmony for focus!"
        case 110...200:
            return "A beat for motivation!"
        default:
            return "Let your heartbeat inspire."
        }
    }
}
