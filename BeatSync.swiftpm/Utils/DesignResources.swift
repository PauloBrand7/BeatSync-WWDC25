import SwiftUI

struct DesignResources {
    
    struct AnimatedBackground: View {
        let deepBlue = Color(red: 0.1, green: 0.1, blue: 0.5)
        let deepPink = Color(red: 0.7, green: 0.1, blue: 0.4)
        @State private var animateGradient = false
        
        var body: some View {
            LinearGradient(
                gradient: Gradient(colors: animateGradient ? [deepBlue, deepPink] : [deepPink, deepBlue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .animation(
                Animation.easeInOut(duration: 4).repeatForever(autoreverses: true),
                value: animateGradient
            )
            .onAppear {
                animateGradient.toggle()
            }
            .edgesIgnoringSafeArea(.all)
        }
    }

    struct TextStyles {
        static let titleFont = Font.system(size: 34, weight: .bold, design: .rounded)
        static let textFont = Font.system(size: 22, weight: .medium, design: .rounded)
        static let titleColor = Color.white
        static let textColor = Color.white.opacity(0.85)
    }
    
    struct ButtonStyles {
        static let backgroundDefaultButton = LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.85), Color.purple.opacity(0.85)]), startPoint: .leading, endPoint: .trailing)
        static let backgroundAppleWatchButton = LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.85), Color.teal.opacity(0.85)]), startPoint: .leading, endPoint: .trailing)
    }
    
    static func nextButton() -> some View {
        Image(systemName: "arrow.right.circle.fill")
            .resizable()
            .frame(width: 60, height: 60)
            .foregroundColor(.white.opacity(0.9))
            .shadow(radius: 5)
    }
    
    static func trackButton(track: String) -> some View {
        Text(track)
            .frame(width: 100, height: 100)
            .foregroundColor(.white)
            .shadow(radius: 4)
    }
}
