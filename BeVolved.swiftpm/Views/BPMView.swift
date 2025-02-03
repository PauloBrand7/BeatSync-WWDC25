//
//  BPMView.swift
//  BeVolved
//
//  Created by Paulo Brand on 27/01/25.
//
import SwiftUI
import AudioToolbox

struct BPMView: View {
    @State private var taps: [Date] = []
    @State private var bpmUser: Int = 0
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack {
                Text("Find Your Rhythm!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .shadow(radius: 5)
                
                Spacer()
                
                Text("Tap the screen in sync with your heartbeat to create your music experience.")
                    .font(.system(size: 22, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 30)
                    .shadow(radius: 3)
                
                Spacer()
                
                Text("BPM: \(bpmUser)")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 3)
                
                Text(bpmMeaning(bpmUser))
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
                    .shadow(radius: 3)
                
                Button(action: {
                    recordTap()
                    calculateBPM()
                    AudioServicesPlaySystemSound(1105)
                }) {
                    Text("Tap Here")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding()
                        .frame(width: 300, height: 300)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.3), Color.blue.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
                .padding(.top, 20)
                
                Spacer()
                
                NavigationLink(destination: TrackSelectionView(bpm: bpmUser)) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(radius: 5)
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    private func recordTap() {
        taps.append(Date())
        if taps.count > 5 {
            taps.removeFirst()
        }
    }
    
    private func calculateBPM() {
        guard taps.count >= 3 else { return }
        var intervals: [TimeInterval] = []
        for i in 1..<taps.count {
            let interval = taps[i].timeIntervalSince(taps[i - 1])
            if interval >= 0.2 && interval <= 2.0 {
                intervals.append(interval)
            }
        }
        guard !intervals.isEmpty else { return }
        let averageInterval = intervals.reduce(0, +) / Double(intervals.count)
        bpmUser = Int(80 / averageInterval)
    }
    
    private func bpmMeaning(_ bpm: Int) -> String {
        switch bpm {
        case 40...84:
            return "Relax mode activated! Enjoy the calmness."
        case 85...109:
            return "Balanced energy! Create a sound to keep focused."
        case 110...200:
            return "High adrenaline! Perfect for an energy boost."
        default:
            return "Set your rhythm and let the music flow!"
        }
    }
}

