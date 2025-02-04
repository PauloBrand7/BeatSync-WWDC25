import SwiftUI

struct BPMSelectionView: View {
    @State private var showWatchInfo = false
    @State private var fakeBPM: Int = 0
    @State private var timer: Timer?
    @State private var isBPMFixed = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 60) {
                Text("Choose Your BPM Mode")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .padding(.top, 50)
                
                Text("Select how you want to measure your heartbeat.")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 30)
                    .shadow(radius: 3)
                
                VStack(spacing: 20) {
                    NavigationLink(destination: BPMView()) {
                        Text("Tap Manually 🫳")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .padding()
                            .frame(maxWidth: 280)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.85), Color.purple.opacity(0.85)]), startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .shadow(radius: 10)
                    }
                    
                    Button(action: {
                        startFakeBPM()
                        showWatchInfo.toggle()
                    }) {
                        Text("Use Apple Watch ⌚️")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .padding()
                            .frame(maxWidth: 280)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.85), Color.teal.opacity(0.85)]), startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .shadow(radius: 10)
                    }
                }
                
                if showWatchInfo {
                    VStack(spacing: 10) {
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
                        
                        Spacer()
                        
                        NavigationLink(destination: TrackSelectionView(bpm: fakeBPM)) {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white.opacity(0.9))
                                .shadow(radius: 5)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            stopFakeBPM()
                        })
                    }
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: showWatchInfo)
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func startFakeBPM() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            fakeBPM = Int.random(in: 60...120)
        }
    }
    
    private func stopFakeBPM() {
        timer?.invalidate()
        timer = nil
    }
}
