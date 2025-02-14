import SwiftUI

struct TrackSelectionView: View {
    var bpm: Int
    @State private var selectedDrums: String? = nil
    @State private var selectedSynth: String? = nil
    @State private var selectedBass: String? = nil
    private let soundManager = SoundManager()
    
    private let drumTracks = ["Soft Drum", "Acoustic Drum", "House Drum"]
    private let bassTracks = ["Dubstep Bass", "Synth Bass", "Kick Bass", "Lo-Fi Bass"]
    private let synthTracks = ["Crystals Synth", "Progressive Synth", "Bells Synth"]
    
    var body: some View {
        ZStack {
            DesignResources.AnimatedBackground()
            
            VStack {
                Text("Choose Your Tracks")
                    .font(DesignResources.TextStyles.titleFont)
                    .foregroundColor(DesignResources.TextStyles.titleColor)
                    .padding(.leading)
                
                Spacer()
                
                Text("DRUMS 🥁")
                    .font(DesignResources.TextStyles.textFont)
                    .foregroundColor(DesignResources.TextStyles.textColor)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                VStack(alignment: .trailing, spacing: 25) {
                    trackSelectionButtons(tracks: drumTracks, selectedTrack: $selectedDrums, defaultColor: Color.green.opacity(0.4))
                }
                
                Spacer()
                
                Text("BASS 🎸")
                    .font(DesignResources.TextStyles.textFont)
                    .foregroundColor(DesignResources.TextStyles.textColor)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 15) {
                    trackSelectionButtons(tracks: Array(bassTracks.prefix(2)), selectedTrack: $selectedBass, defaultColor: Color.orange.opacity(0.5))
                    trackSelectionButtons(tracks: Array(bassTracks.suffix(2)), selectedTrack: $selectedBass, defaultColor: Color.orange.opacity(0.5))
                }
                
                Spacer()
                
                Text("SYNTHS 🎹")
                    .font(DesignResources.TextStyles.textFont)
                    .foregroundColor(DesignResources.TextStyles.textColor)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                trackSelectionButtons(tracks: synthTracks, selectedTrack: $selectedSynth, defaultColor: Color.purple.opacity(0.5))
                
                Spacer()
                
                NavigationLink(destination: AmbientSoundView(bpm: bpm, selectedDrums: selectedDrums, selectedSynth: selectedSynth, selectedBass: selectedBass)) {
                    DesignResources.nextButton()
                }.simultaneousGesture(TapGesture().onEnded {
                    Task {
                        await soundManager.stop()
                    }
                })
            }
        }
    }
    
    private func trackSelectionButtons(tracks: [String], selectedTrack: Binding<String?>, defaultColor: Color) -> some View {
        HStack(spacing: 15) {
            ForEach(tracks, id: \.self) { track in
                Button(action: {
                    selectedTrack.wrappedValue = track
                    Task {
                        await soundManager.playBackgroundSound(soundName: track)
                    }
                }) {
                    DesignResources.trackButton(track: track)
                        .background(selectedTrack.wrappedValue == track ? Color.blue : defaultColor)
                        .cornerRadius(15)
                }
            }
        }
    }
}
