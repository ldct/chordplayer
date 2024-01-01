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
            Picker("Tonic (root note of key)", selection: $model.selectedRoot) {
                ForEach(allNotes) { key in
                    Text(key.debugDescription).tag(key)
                }
            }
            Picker("Tonality", selection: $model.tonality) {
                Text("Major").tag(Modality.major)
                Text("Minor").tag(Modality.minor)
            }
//            if model.tonality == .major {
//                Toggle("Show diminished chord", isOn: $model.showDiminishedInMajor)
//            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        let settingsModel = SettingsModel.defaultSettingsModel
        Settings(model: .constant(settingsModel))
    }
}
