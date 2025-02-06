import SwiftUI

struct WelcomeView: View {
    private let title = "Welcome to BeVolved!"
    private let text = "Sync your heartbeat to feel the music. \n\nWhether you’re looking to relax, focus, or just tune yourself, BeVolved helps you find your perfect rhythm."
    
    var body: some View {
        ZStack {
            DesignResources.AnimatedBackground()
            
            VStack(spacing: 30) {
                Spacer()
                
                Text(title)
                    .font(DesignResources.TextStyles.titleFont)
                    .foregroundColor(DesignResources.TextStyles.titleColor)
                    .shadow(radius: 10)
                    .multilineTextAlignment(.center)
                
                Text(text)
                    .font(DesignResources.TextStyles.textFont)
                    .foregroundColor(DesignResources.TextStyles.textColor)
                    .shadow(radius: 8)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                NavigationLink(destination: BPMSelectionView()) {
                    Text("Start")
                        .font(DesignResources.TextStyles.textFont)
                        .foregroundColor(DesignResources.TextStyles.textColor)
                        .padding()
                        .frame(maxWidth: 260)
                        .background(                                DesignResources.ButtonStyles.backgroundDefaultButton
                        )
                        .cornerRadius(30)
                        .shadow(radius: 10)
                        .padding(.bottom, 50)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
