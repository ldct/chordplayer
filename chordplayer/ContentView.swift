import SwiftUI

struct SettingsModel {
    var selectedKey: MusicalKey
    
    static let defaultSettingsModel = SettingsModel(selectedKey: MusicalKey.defaultKey)
}

struct Settings: View {
    @Binding var model: SettingsModel
    
    var body: some View {
        Form {
            Picker("key", selection: $model.selectedKey) {
                ForEach(allKeys) { key in
                    Text(key.toString).tag(key)
                }
            }
        }
    }
}

struct ContentView: View {
    @State var settings: SettingsModel

    func makeButton(_ text: String) -> some View  {
        let ret = Button(text) {
        }.frame(width: 100, height: 100).background(.yellow).cornerRadius(5)

        return ret
    }
    
    var chords: [String] {
        notes_in_major_key(rootNote: settings.selectedKey.rootNote).map {
            "\($0)"
        }
    }

    var body: some View {
        NavigationStack {
                NavigationLink("settings", value: "settings")
                    .navigationDestination(for: String.self) { value in
                        Settings(model: $settings)
                    }
                PianoView()
                HStack {
                    ForEach(chords.indices, id: \.self) {
                        makeButton(chords[$0])
                    }
                }
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let settingsModel = SettingsModel.defaultSettingsModel
        ContentView(settings: settingsModel)
    }
}
