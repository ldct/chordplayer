import SwiftUI

struct ContentView: View {
    private let rotationChangePublisher = NotificationCenter.default
        .publisher(for: UIDevice.orientationDidChangeNotification)
    @State private var isOrientationLocked = false

    @State var settings: SettingsModel
    
    @State var keyChangeAllowed: Bool = true
    
    @State var currentTriad: MusicalTriad? {
        didSet {
            if let oldValue {
                if oldValue.modality == .major {
                    piano.stopMajorChord(rootPitch: 60 + oldValue.rootNote.asPitch)
                } else if oldValue.modality == .minor {
                    piano.stopMinorChord(rootPitch: 60 + oldValue.rootNote.asPitch)
                }
            }
            if let newValue = currentTriad {
                if newValue.modality == .major {
                    piano.playMajorChord(rootPitch: 60 + newValue.rootNote.asPitch)
                } else if newValue.modality == .minor {
                    piano.playMinorChord(rootPitch: 60 + newValue.rootNote.asPitch)
                }
            }
        }
    }

    let piano = PianoSound()

    func makeButton(rubyText: String, triad: MusicalTriad, height: CGFloat) -> some View  {
        let ret = Button(action: {
            if currentTriad == triad {
                currentTriad = nil
            } else {
                currentTriad = triad
            }
        }) {
            VStack {
                Text(rubyText).font(.caption2)
                Text(triad.debugDescription)
                    .frame(width: 80, height: height)
                    .background((triad == currentTriad ? .green : .yellow))
                    .cornerRadius(5)
            }
        }
        return ret
    }
    
    var chords: [[MusicalTriad]] {
        var ret = chromatic_triads_in_key(key: settings.selectedKey)
        return ret
    }

    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink("settings", value: "settings")
                    .navigationDestination(for: String.self) { value in
                        Settings(model: $settings)
                    }
                Spacer()
                VStack {
                    let lockIndicator: String = keyChangeAllowed ? "" : "🔒"
                    Text("current key: \(settings.selectedKey.toString) \(lockIndicator)").font(.body)
                    let text: String = keyChangeAllowed ? "(double-click piano to change key)" : "(tap here to change key)"
                    Text(text).font(.caption2)
                }.onTapGesture {
                    keyChangeAllowed = !keyChangeAllowed
                }
            }
            
            HStack {
                ForEach(chords.indices) { idx in
                    let chord_pair = chords[idx]
                    if settings.selectedKey.modality == .major, chord_pair[0].modality == .diminished {
                        if settings.shouldShowDiminishedInMajor  {
                            makeButton(rubyText: " ", triad: chord_pair[0], height: 40)
                        }
                    } else {
                        let rubyText = idx == 3 ? "IV" : (idx == 4 ? "V" : " ")
                        makeButton(rubyText: rubyText, triad: chord_pair[0], height: 40)
                    }
                }
            }
            if settings.shouldShowSecondRow {
                HStack {
                    ForEach(chords.indices) { idx in
                        let chord_pair = chords[idx]
                        makeButton(rubyText: "", triad: chord_pair[1], height: 20)
                    }
                }
            }
            PianoView(selectedRoot: $settings.selectedRoot, keyChangeAllowed: $keyChangeAllowed)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let settingsModel = SettingsModel.defaultSettingsModel
        ContentView(settings: settingsModel)
    }
}
