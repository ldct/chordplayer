//
//  PianoView.swift
//  chordplayer
//
//  Created by Li Xuanji on 28/12/22.
//

import SwiftUI

struct PianoView: View {

    @State var lastHitKeyInfo: KeyInfo? = nil
        
    @State var location: CGPoint = .zero
    
    @Binding var selectedRoot: MusicalNote
    
    @Binding var keyChangeAllowed: Bool
    
    let model = SoundModel()

    var body: some View {
        let drag = DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
            .onChanged({ drag in
                self.location = drag.location
            })
            .onEnded({ _ in
                self.location = .zero
            })
        
        let tap = TapGesture(count: 2)
            .onEnded({
                guard keyChangeAllowed else {
                    return
                }
                keyChangeAllowed = false
                if let lastHitKeyInfo {
                    let absolutePitch = PianoSound().convert(keyInfo: lastHitKeyInfo)
                    
                    var pitchClass = (Int(absolutePitch) - 60) % 12
                    pitchClass += 12
                    pitchClass %= 12

                    let r = twelveNotes[Int(pitchClass)]
                    
                    selectedRoot = r
                    print("doubleclick \(r)")
                }
            })
        
        return ZStack(alignment: .top) {
            // white keys
            HStack(spacing: 2) {
                ForEach(0 ..< 14) { n in
                    self.makeWhiteKey(n: n)
                }
                self.lastWhiteKey(n: 14)
            }
            // black keys
            HStack(spacing: 18) {
                ForEach(0 ..< 14) { n in
                    self.makeBlackKey(n: n)
                }
            }
        }
        .padding(20)
        .background(Color.gray)
        .gesture(drag)
        .simultaneousGesture(tap)
    }

    private func makeWhiteKey(n: Int) -> some View {
        let view: PianoKeyView
        switch n % 7 {
        case 0, 3:
            let model = PianoKeyModel(color: .white, type: .left, n: n)
            view = PianoKeyView(model: model, location: self.$location)
        case 1, 4, 5:
            let model = PianoKeyModel(color: .white, type: .center, n: n)
            view = PianoKeyView(model: model, location: self.$location)
        case 2, 6:
            let model = PianoKeyModel(color: .white, type: .right, n: n)
            view = PianoKeyView(model: model, location: self.$location)
        default:
            fatalError("impossible")
        }
        return view.onEvent(handler: { (keyInfo) in
            self.lastHitKeyInfo = keyInfo
            self.model.called(keyInfo: keyInfo)
        })
    }

    private func lastWhiteKey(n: Int) -> some View {
        let model = PianoKeyModel(color: .white, type: .plain, n: n)
        return PianoKeyView(model: model, location: self.$location)
            .onEvent(handler: { (keyInfo) in
                self.lastHitKeyInfo = keyInfo
                self.model.called(keyInfo: keyInfo)
            })
    }

    private func makeBlackKey(n: Int) -> AnyView {
        switch n % 7 {
        case 2, 6:
            return AnyView(Spacer().frame(width: 24))
        default:
            let model = PianoKeyModel(color: .black, type: .plain, n: n)
            let view = PianoKeyView(model: model, location: self.$location)
                .onEvent(handler: { (keyInfo) in
                    self.lastHitKeyInfo = keyInfo
                    self.model.called(keyInfo: keyInfo)
                })
            return AnyView(view)
        }
    }
}
