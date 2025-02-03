//
//  SplashScreenView.swift
//  BeVolved
//
//  Created by Paulo Brand on 02/02/25.
//
import SwiftUI

struct SplashScreenView: View {
    @State private var showWords = false
    @State private var mergeWords = false
    @State private var navigateToWelcome = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if !mergeWords {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Be")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .opacity(showWords ? 1 : 0)
                            .animation(.easeIn(duration: 0.6).delay(0.2), value: showWords)
                        
                        Text("Involved")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .opacity(showWords ? 1 : 0)
                            .animation(.easeIn(duration: 0.6).delay(0.4), value: showWords)
                        
                        Text("With Your")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .opacity(showWords ? 1 : 0)
                            .animation(.easeIn(duration: 0.6).delay(0.6), value: showWords)
                        
                        Text("Beats")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .opacity(showWords ? 1 : 0)
                            .animation(.easeIn(duration: 0.6).delay(0.8), value: showWords)
                    }
                }
                
                if mergeWords {
                    Text("BeVolved")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: mergeWords ? 0 : 100)
                        .animation(.easeInOut(duration: 0.10), value: mergeWords)
                }
            }
            .onAppear {
                showWords = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    mergeWords = true
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
