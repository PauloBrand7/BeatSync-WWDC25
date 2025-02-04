import SwiftUI

struct TrackSelectionView: View {
    var bpm: Int
    @State private var selectedDrums: String? = nil
    @State private var selectedSynth: String? = nil
    @State private var selectedBass: String? = nil
    private let soundManager = SoundManager()
    
    let drumTracks = ["Drum 1", "Drum 2", "Drum 3"]
    let bassTracks = ["Bass 1", "Bass 2", "Bass 3", "Bass 4"]
    let synthTracks = ["Synth 1", "Synth 2", "Synth 3"]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                Text("Choose Your Tracks")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Spacer()
                
                Text("DRUMS 🥁")
                    .font(.system(size: 22, weight: .regular, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                
                VStack(alignment: .trailing, spacing: 25) {
                    trackSelectionButtons(tracks: drumTracks, selectedTrack: $selectedDrums, defaultColor: Color.gray.opacity(0.6))
                }
                
                Spacer()
                
                Text("BASS 🎸")
                    .font(.system(size: 22, weight: .regular, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 15) {
                    trackSelectionButtons(tracks: Array(bassTracks.prefix(2)), selectedTrack: $selectedBass, defaultColor: Color.brown.opacity(0.5))
                    trackSelectionButtons(tracks: Array(bassTracks.suffix(2)), selectedTrack: $selectedBass, defaultColor: Color.brown.opacity(0.5))
                }
                
                Spacer()
                
                Text("SYNTHS 🎹")
                    .font(.system(size: 22, weight: .regular, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                trackSelectionButtons(tracks: synthTracks, selectedTrack: $selectedSynth, defaultColor: Color.purple.opacity(0.5))
                
                Spacer()
                
                NavigationLink(destination: BackgroundSoundView(bpm: bpm, selectedDrums: selectedDrums, selectedSynth: selectedSynth, selectedBass: selectedBass)) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(radius: 5)
                }
            }
        }.onDisappear {
            Task {
                await soundManager.stop()
            }
        }
    }
    
    private func trackSelectionButtons(tracks: [String], selectedTrack: Binding<String?>, defaultColor: Color) -> some View {
        HStack(spacing: 15) {
            ForEach(tracks, id: \.self) { track in
                Button(action: {
                    selectedTrack.wrappedValue = track
                    Task {
                        await soundManager.playBackgroundSound(type: track)
                    }
                }) {
                    Text(track)
                        .frame(width: 100, height: 100)
                        .background(selectedTrack.wrappedValue == track ? Color.blue : defaultColor)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 4)
                }
            }
        }
    }
}
