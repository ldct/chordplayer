import SwiftUI

struct SettingsModel {
    var selectedRoot: MusicalNote = MusicalKey.defaultKey.rootNote
    var tonality: Modality = .major
    
    var shouldShowDiminishedInMajor: Bool = true
    var shouldShowSecondRow: Bool = false

    
    var selectedKey: MusicalKey {
        MusicalKey(rootNote: selectedRoot, modality: tonality)
    }
    
    static let defaultSettingsModel = SettingsModel()
}

struct Settings: View {
    @Binding var model: SettingsModel
    
    var body: some View {
        Form {
            Picker("Tonic (root note of key)", selection: $model.selectedRoot) {
                ForEach(allNotes) { key in
                    Text(key.debugDescription).tag(key)
                }
            }
            Picker("Tonality", selection: $model.tonality) {
                Text("Major").tag(Modality.major)
                Text("Minor").tag(Modality.minor)
            }
            Toggle("Show non-diatonic chords in second row", isOn: $model.shouldShowSecondRow)
            Toggle("Show diminished chord (vii°) in major", isOn: $model.shouldShowDiminishedInMajor)

        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        let settingsModel = SettingsModel.defaultSettingsModel
        Settings(model: .constant(settingsModel))
    }
}
