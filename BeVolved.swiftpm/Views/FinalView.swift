//
//  FinalView.swift
//  BeVolved
//
//  Created by Paulo Brand on 27/01/25.
//
import SwiftUI
import AVFoundation

struct FinalView: View {
    var bpm: Int
    var selectedDrums: String?
    var selectedSynth: String?
    var selectedBass: String?
    var selectedBackground: String?

    @StateObject private var audioManager = FinalMusicManager()
    @State private var isReverbEnabled = true

    var body: some View {
        ZStack {
            GradientBackground()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Spacer()

                Text("Harmonizing heart \n& music at \n \n\(bpm) BPM")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)

                Text(finalMessage(bpm))
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.75))
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)

                Spacer()

                HStack(spacing: 20) {
                    Button(action: {
                        audioManager.loadTracks(drums: selectedDrums, synth: selectedSynth, bass: selectedBass, background: selectedBackground)
                        audioManager.adjustRate(for: bpm)
                        audioManager.play()
                    }) {
                        Text("Feel the Sound")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding()
                            .frame(width: 160)
                            .background(LinearGradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }

                    Button(action: { audioManager.stop() }) {
                        Text("Pause the Vibe")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding()
                            .frame(width: 160)
                            .background(Color.red.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }
                }
                .padding(.bottom, 20)

                Toggle(isOn: $isReverbEnabled) {
                    Text("Enhance Atmosphere (Reverb)")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
                .onChange(of: isReverbEnabled) { enabled in
                    audioManager.reverb.bypass = !enabled
                }

                if isReverbEnabled {
                    VStack(spacing: 10) {
                        Picker("Reverb Style", selection: $audioManager.selectedPresetName) {
                            ForEach(audioManager.reverbPresetNames, id: \.self) { presetName in
                                Text(presetName)
                                    .foregroundColor(.white)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: 250)
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(15)

                        VStack {
                            Slider(value: $audioManager.reverbIntensity, in: 0...100, step: 1)
                                .accentColor(.blue)
                            Text("Intensity: \(Int(audioManager.reverbIntensity))%")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 30)
                    }
                }

                Spacer()
            }
            .padding()
        }
        //.navigationBarBackButtonHidden(true)
    }

    private func finalMessage(_ bpm: Int) -> String {
        switch bpm {
        case 40...84:
            return "A calming rhythm for your mind. Breathe, reflect, and restore balance."
        case 85...109:
            return "A smooth harmony for focus and clarity. Stay present and embrace the moment."
        case 110...200:
            return "A powerful beat for energy and motivation. Let the rhythm drive your passion!"
        default:
            return "Your sound, your story. Let your heartbeat inspire innovation."
        }
    }
}
