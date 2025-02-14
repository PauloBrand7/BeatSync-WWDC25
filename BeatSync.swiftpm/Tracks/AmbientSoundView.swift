import SwiftUI

struct AmbientSoundView: View {
    var bpm: Int
    var selectedDrums: String?
    var selectedSynth: String?
    var selectedBass: String?
    @State private var selectedBackground: String? = nil
    private let soundManager = SoundManager()
    
    var body: some View {
        ZStack {
            DesignResources.AnimatedBackground()
            
            VStack(spacing: 50) {
                Text("One more thing...")
                    .font(DesignResources.TextStyles.titleFont)
                    .foregroundColor(DesignResources.TextStyles.titleColor)
                    .shadow(radius: 10)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                
                Text("Choose a ambient sound:")
                    .font(DesignResources.TextStyles.textFont)
                    .foregroundColor(DesignResources.TextStyles.textColor)
                    .shadow(radius: 10)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Button(action: {
                        selectedBackground = "ocean"
                        Task {
                            await soundManager.playBackgroundSound(soundName: "ocean")
                        }
                    }) {
                        Text("Ocean \n🌊")
                            .frame(width: 100, height: 100)
                            .background(selectedBackground == "ocean" ? Color.blue : Color.cyan.opacity(0.4))
                            .cornerRadius(15)
                            .font(DesignResources.TextStyles.textFont)
                            .foregroundColor(DesignResources.TextStyles.textColor)
                            .fontWeight(.bold)
                    }
                    
                    Button(action: {
                        selectedBackground = "rain"
                        Task {
                            await soundManager.playBackgroundSound(soundName: "rain")
                        }
                    }) {
                        Text("Rain \n🌧️")
                            .frame(width: 100, height: 100)
                            .background(selectedBackground == "rain" ? Color.blue : Color.cyan.opacity(0.4))
                            .cornerRadius(15)
                            .font(DesignResources.TextStyles.textFont)
                            .foregroundColor(DesignResources.TextStyles.textColor)
                            .fontWeight(.bold)
                    }
                    
                    Button(action: {
                        selectedBackground = "nature"
                        Task {
                            await soundManager.playBackgroundSound(soundName: "nature")
                        }
                    }) {
                        Text("Nature \n🍃")
                            .frame(width: 100, height: 100)
                            .background(selectedBackground == "nature" ? Color.blue : Color.cyan.opacity(0.4))
                            .cornerRadius(15)
                            .font(DesignResources.TextStyles.textFont)
                            .foregroundColor(DesignResources.TextStyles.textColor)
                            .fontWeight(.bold)
                    }
                }
                
                Text(backgroundMeaning(selectedBackground))
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
                    .shadow(radius: 3)
                
                NavigationLink(destination: FinalView(bpm: bpm, selectedDrums: selectedDrums, selectedSynth: selectedSynth, selectedBass: selectedBass, selectedBackground: selectedBackground)) {
                    DesignResources.nextButton()
                }.simultaneousGesture(TapGesture().onEnded {
                    Task {
                        await soundManager.stop()
                    }
                })
                .padding(.bottom, 40)
            }
        }
    }
    
    private func backgroundMeaning(_ track: String?) -> String {
        switch track {
        case "ocean":
            return "Calming ocean waves."
        case "rain":
            return "A soft rain falling."
        case "nature":
            return "Birds, drops, and a gentle breeze."
        default:
            return ""
        }
    }
}
