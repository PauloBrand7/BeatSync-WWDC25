import SwiftUI

struct BPMSelectionView: View {
    @State private var showAppleWatchBPM = false
    @State private var fakeBPM = 0
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            DesignResources.AnimatedBackground()
            
            VStack {
                Text("Choose Your BPM Mode")
                    .font(DesignResources.TextStyles.titleFont)
                    .foregroundColor(DesignResources.TextStyles.titleColor)
                    .shadow(radius: 10)
                    .multilineTextAlignment(.center)
                    .padding(.top, 100)
                
                Text("How do you prefer to measure your heartbeat?")
                    .font(DesignResources.TextStyles.textFont)
                    .foregroundColor(DesignResources.TextStyles.textColor)
                    .shadow(radius: 8)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                VStack(spacing: 20) {
                    NavigationLink(destination: BPMView()) {
                        Text("Touching the screen 🫳")
                            .font(DesignResources.TextStyles.textFont)
                            .foregroundColor(DesignResources.TextStyles.textColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .padding()
                            .frame(maxWidth: 280)
                            .background(
                                DesignResources.ButtonStyles.backgroundDefaultButton
                            )
                            .cornerRadius(30)
                            .shadow(radius: 10)
                    }
                    
                    Button(action: {
                        stopFakeBPM()
                        startFakeBPM()
                        showAppleWatchBPM.toggle()
                    }) {
                        Text("Using Apple Watch Data ⌚️")
                            .font(DesignResources.TextStyles.textFont)
                            .foregroundColor(DesignResources.TextStyles.textColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .padding()
                            .frame(maxWidth: 280)
                            .background(
                                DesignResources.ButtonStyles.backgroundAppleWatchButton
                            )
                            .cornerRadius(30)
                            .shadow(radius: 10)
                    }
                }
                
                Spacer()
                
                if showAppleWatchBPM {
                    VStack {
                        Text("Apple Watch integration is not supported in Playground. \nThis mode will simulate BPM measures.")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 30)
                            .shadow(radius: 3)
                        
                        Text("BPM: \(fakeBPM)")
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                        
                        NavigationLink(destination: TrackSelectionView(bpm: fakeBPM)) {
                            DesignResources.nextButton()
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            stopFakeBPM()
                        })
                    }
                }
            }
        }
    }
    
    private func startFakeBPM() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            fakeBPM = Int.random(in: 60...120)
        }
    }
    
    private func stopFakeBPM() {
        timer?.invalidate()
        timer = nil
        showAppleWatchBPM = false
    }
}
