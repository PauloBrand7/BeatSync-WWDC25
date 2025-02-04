import SwiftUI

struct BackgroundSoundView: View {
    var bpm: Int
    var selectedDrums: String?
    var selectedSynth: String?
    var selectedBass: String?
    @State private var selectedBackground: String = ""
    private let soundManager = SoundManager()

    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 50) {
                Text("Choose a background sound:")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack {
                    Button(action: {
                        selectedBackground = "ocean-waves"
                        Task {
                            await soundManager.playBackgroundSound(type: "ocean")
                        }
                    }) {
                        Text("Ocean \n🌊")
                            .frame(width: 100, height: 100)
                            .background(selectedBackground == "ocean-waves" ? Color.blue : Color.gray)
                            .cornerRadius(15)
                            .font(.system(size: 22, weight: .regular, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        selectedBackground = "rain"
                        Task {
                            await soundManager.playBackgroundSound(type: "rain")
                        }
                    }) {
                        Text("Rain \n🌧️")
                            .frame(width: 100, height: 100)
                            .background(selectedBackground == "rain" ? Color.blue : Color.gray)
                            .cornerRadius(15)
                            .font(.system(size: 22, weight: .regular, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }

                    Button(action: {
                        selectedBackground = "nature"
                        Task {
                            await soundManager.playBackgroundSound(type: "nature")
                        }
                    }) {
                        Text("Nature \n🍃")
                            .frame(width: 100, height: 100)
                            .background(selectedBackground == "nature" ? Color.blue : Color.gray)
                            .cornerRadius(15)
                            .font(.system(size: 22, weight: .regular, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                
                Text(backgroundMeaning(selectedBackground))
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
                    .shadow(radius: 3)
                
                NavigationLink(destination: FinalView(bpm: bpm, selectedDrums: selectedDrums, selectedSynth: selectedSynth, selectedBass: selectedBass, selectedBackground: selectedBackground)) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(radius: 5)
                }
                .padding(.bottom, 40)
            }
        }.onDisappear {
            Task {
                await soundManager.stop()
            }
        }
    }
    
    private func backgroundMeaning(_ track: String) -> String {
        switch track {
        case "ocean-waves":
            return "Calming waves for relaxation."
        case "rain":
            return "Soft drizzles to enhance focus."
        case "nature":
            return "Soothing sounds to relieve stress."
        default:
            return ""
        }
    }
}
