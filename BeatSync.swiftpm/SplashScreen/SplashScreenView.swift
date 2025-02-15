import SwiftUI

struct SplashScreenView: View {
    @State private var showWords = false
    @State private var showMainTitle = false
    @State private var navigateToWelcome = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if !showMainTitle {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Heart.")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .opacity(showWords ? 1 : 0)
                            .animation(.easeIn(duration: 0.6).delay(0.2), value: showWords)
                        
                        Text("Your Beat.")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .opacity(showWords ? 1 : 0)
                            .animation(.easeIn(duration: 0.6).delay(0.8), value: showWords)
                        
                        Text("Synced.")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .opacity(showWords ? 1 : 0)
                            .animation(.easeIn(duration: 0.6).delay(1.4), value: showWords)
                    }
                }
                
                if showMainTitle {
                    Text("BeatSync")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: showMainTitle ? 0 : 100)
                        .animation(.easeInOut(duration: 0.10), value: showMainTitle)
                }
            }
            .onAppear {
                showWords = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    showMainTitle = true
                    showWords = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    navigateToWelcome = true
                }
            }
            .navigationDestination(isPresented: $navigateToWelcome) {
                WelcomeView()
            }
        }
    }
}
