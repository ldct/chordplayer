import SwiftUI

struct SettingsModel {
    var selectedRoot: MusicalNote = MusicalKey.defaultKey.rootNote
    var tonality: Modality = .major
    
    var showDiminishedInMajor: Bool = false
    
    var selectedKey: MusicalKey {
        MusicalKey(rootNote: selectedRoot, modality: tonality)
    }
    
    static let defaultSettingsModel = SettingsModel()
}

struct Settings: View {
    @Binding var model: SettingsModel
    
    var body: some View {
        Form {
            Picker("Key (root)", selection: $model.selectedRoot) {
                ForEach(allNotes) { key in
                    Text(key.debugDescription).tag(key)
                }
            }
            Picker("Tonality", selection: $model.tonality) {
                Text("Major").tag(Modality.major)
                Text("Minor").tag(Modality.minor)
            }
            if model.tonality == .major {
                Toggle("Show diminished chord", isOn: $model.showDiminishedInMajor)
            }
        }
    }
}

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

    
    func makeButton(_ triad: MusicalTriad) -> some View  {
        let ret = Button(action: {
            if currentTriad == triad {
                currentTriad = nil
            } else {
                currentTriad = triad
            }
        }) {
            Text(triad.debugDescription)
                .frame(width: 80, height: 40)
                .background((triad == currentTriad ? .green : .yellow))
                .cornerRadius(5)
        }
        return ret
    }
    
    var chords: [[MusicalTriad]] {
        var ret = chromatic_triads_in_major_key(rootNote: settings.selectedKey.rootNote)
//        if !settings.showDiminishedInMajor {
//            ret = ret.filter {
//                $0.modality != .diminished
//            }
//        }
        return ret
    }

    var body: some View {
        NavigationStack {
            HStack {
                NavigationLink("settings", value: "settings")
                    .navigationDestination(for: String.self) { value in
                        Settings(model: $settings)
                    }
                Toggle("", isOn: $keyChangeAllowed)

            }

                HStack {
            
            
                    Button(action: {
                    }) {
                        Text("<")
                            .frame(width: 40, height: 100)
                            .background(.yellow)
                            .cornerRadius(5)
                    }
                    ForEach(chords.indices) { idx in
                        let chord_pair = chords[idx]
                        VStack {
                            ForEach(chord_pair) { chord in
                                makeButton(chord)
                            }
                        }
                    }
                    Button(action: {
                    }) {
                        Text(">")
                            .frame(width: 40, height: 100)
                            .background(.yellow)
                            .cornerRadius(5)
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
