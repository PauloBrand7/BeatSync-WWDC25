import SwiftUI
import AudioToolbox

struct BPMView: View {
    @State private var showNextButton = false
    @State private var taps: [Date] = []
    @State private var bpmUser: Int = 0
    
    var body: some View {
        ZStack {
            DesignResources.AnimatedBackground()
            
            VStack {
                Text("Let's Find Your Rhythm!")
                    .font(DesignResources.TextStyles.titleFont)
                    .foregroundColor(DesignResources.TextStyles.titleColor)
                    .shadow(radius: 10)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                    .shadow(radius: 5)
                
                Spacer()
                
                if !showNextButton {
                    Text("Tap the screen in sync with your heartbeat at least 3 times to find your beat.")
                        .font(DesignResources.TextStyles.textFont)
                        .foregroundColor(DesignResources.TextStyles.textColor)
                        .shadow(radius: 8)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                Text("BPM: \(bpmUser)")
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 3)
                
                Text(bpmMessage(bpmUser))
                    .font(.system(size: 20, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.top, 10)
                    .padding(.horizontal, 30)
                    .shadow(radius: 3)
                
                Button(action: {
                    AudioServicesPlaySystemSound(1105)
                    calculateBPM()
                }) {
                    Text("Tap Here")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding()
                        .frame(width: 250, height: 250)
                        .background(DesignResources.ButtonStyles.backgroundDefaultButton)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
                .padding(.top, 20)
                
                Spacer()
                
                if showNextButton {
                    NavigationLink(destination: InstrumentsView(bpm: bpmUser)) {
                        DesignResources.nextButton()
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
    
    private func calculateBPM() {
        taps.append(Date())
        // To keep only the last 3 taps to calculate.
        if taps.count > 3 {
            taps.removeFirst()
        }
        
        //At least 3 taps to calculate
        guard taps.count >= 3 else { return }
        showNextButton = true
        var intervals: [TimeInterval] = []
        
        for i in 1..<taps.count {
            let interval = taps[i].timeIntervalSince(taps[i - 1])
            // Ignoring taps that are too fast or tooo slow
            if interval >= 0.2 && interval <= 2.0 {
                intervals.append(interval)
            }
        }
        guard !intervals.isEmpty else { return }
        let averageInterval = intervals.reduce(0, +) / Double(intervals.count)
        bpmUser = Int(60 / averageInterval)
    }
    
    private func bpmMessage(_ bpm: Int) -> String {
        switch bpm {
        case 40...84:
            return "Relaxed rhythm! \nYour song will slow down."
        case 85...109:
            return "Balanced rhythm! \nNice, you're right on beat."
        case 110...200:
            return "High rhythm! \nWhoa, you need a fast song!"
        case 201...:
            return "KEEP CALM! \nYou're going too fast..."
        default:
            return "Waiting for your rhythm..."
        }
    }
}

