//
//  PulsatingGradientBackground.swift
//  BeVolved
//
//  Created by Paulo Brand on 27/01/25.
//
import SwiftUI

struct GradientBackground: View {
    let color1 = Color(red: 0.1, green: 0.1, blue: 0.5)
    let color2 = Color(red: 0.7, green: 0.1, blue: 0.4)
    
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [animateGradient ? color1 : color2, animateGradient ? color2 : color1]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            .animation(
                Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true),
                value: animateGradient
            )
            .onAppear {
                animateGradient.toggle()
            }
        }
    }
}
