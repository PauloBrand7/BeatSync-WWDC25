//
import SwiftUI

struct WelcomeView: View {
    let startBackgroundButton = LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.85), Color.purple.opacity(0.85)]), startPoint: .leading, endPoint: .trailing)

    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("Welcome to BeVolved!")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                
                Text("Sync your heartbeat to feel the music like never before. \n\nWhether you seek relaxation, focus, or a moment of mindfulness, BeVolved helps you harmonize your rhythm and find balance.")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.horizontal, 40)
                    .shadow(radius: 8)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.2), value: 1)
                
                Spacer()
                
                NavigationLink(destination: BPMSelectionView()) {
                    Text("Start")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .padding()
                        .frame(maxWidth: 260)
                        .background(startBackgroundButton)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                        .padding(.bottom, 50)
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 1.5), value: 1)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
