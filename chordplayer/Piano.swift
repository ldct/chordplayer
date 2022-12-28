//
//  Piano.swift
//  chordplayer
//
//  Created by Li Xuanji on 28/12/22.
//

import Foundation
import SwiftUI
import AVFoundation

class PianoSound {

    private let audioEngine = AVAudioEngine()
    private let unitSampler = AVAudioUnitSampler()
    private var whiteNotes = [UInt8]()
    private var blackNotes = [UInt8]()

    init(volume: Float = 0.5) {
        whiteNotes = makeWhiteNotes(14)
        blackNotes = mekeBlackNotes(13)
        audioEngine.mainMixerNode.volume = volume
        audioEngine.attach(unitSampler)
        audioEngine.connect(unitSampler, to: audioEngine.mainMixerNode, format: nil)
        if let _ = try? audioEngine.start() {
            loadSoundFont()
        }
    }

    deinit {
        if audioEngine.isRunning {
            audioEngine.disconnectNodeOutput(unitSampler)
            audioEngine.detach(unitSampler)
            audioEngine.stop()
        }
    }

    private func loadSoundFont() {
        guard let url = Bundle.main.url(forResource: "emuaps_8mb",
                                        withExtension: "sf2") else { return }
        try? unitSampler.loadSoundBankInstrument(
            at: url, program: 0,
            bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
            bankLSB: UInt8(kAUSampler_DefaultBankLSB)
        )
    }

    private func makeWhiteNotes(_ n: Int) -> [UInt8] {
        if n < 0 {
            fatalError("bad request")
        } else if n == 0 {
            return [60]
        } else if n % 7 == 0 || n % 7 == 3 {
            let notes = makeWhiteNotes(n - 1)
            return notes + [notes.last! + 1]
        } else {
            let notes = makeWhiteNotes(n - 1)
            return notes + [notes.last! + 2]
        }
    }

    private func mekeBlackNotes(_ n: Int) -> [UInt8] {
        if n < 0 {
            fatalError("bad request")
        } else if n == 0 {
            return [61]
        } else if n % 7 == 2 || n % 7 == 6 {
            let notes = mekeBlackNotes(n - 1)
            return notes + [notes.last! + 1]
        } else {
            let notes = mekeBlackNotes(n - 1)
            return notes + [notes.last! + 2]
        }
    }

    private func convert(keyInfo: KeyInfo) -> UInt8 {
        if keyInfo.color == .white {
            return UInt8(whiteNotes[keyInfo.n])
        } else {
            return UInt8(blackNotes[keyInfo.n])
        }
    }

    func play(keyInfo: KeyInfo) {
        let note = convert(keyInfo: keyInfo)
        self.unitSampler.startNote(note, withVelocity: 80, onChannel: 0)
    }

//    func fadeOut(note: UInt8, pressure: UInt8 = 80) {
//        if 0 < pressure {
//            self.unitSampler.sendPressure(forKey: note, withValue: pressure - 10, onChannel: 0)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                self.fadeOut(note: note, pressure: pressure - 10)
//            }
//        } else {
//            self.unitSampler.stopNote(note, onChannel: 0)
//        }
//    }

    func stop(keyInfo: KeyInfo) {
        let note = convert(keyInfo: keyInfo)
        self.unitSampler.stopNote(note, onChannel: 0)
    }

}


struct PianoKeyView: View {

    let model: PianoKeyModel
    @Binding var location: CGPoint

    init(model: PianoKeyModel, location: Binding<CGPoint>) {
        self.model = model
        _location = location
    }

    var body: some View {
        let size = getSize()
        return GeometryReader { geometry in
            self.makeShape(geometry: geometry)
        }
        .frame(width: size.width, height: size.height)
    }

    private func getSize() -> CGSize {
        let w: CGFloat = model.color == .white ? 40 : 24
        let h: CGFloat = model.color == .white ? 200 : 119
        return CGSize(width: w, height: h)
    }

    private func hit(geometry: GeometryProxy) -> Bool {
        let frame = geometry.frame(in: .global)
        let path = KeyShape(radius: 8, type: model.type)
            .invertPath(in: CGRect(origin: .zero, size: frame.size))
        
        let pt = CGPoint(x: location.x - frame.origin.x,
                         y: location.y - frame.origin.y)
        return path.contains(pt)
    }

    private func makeShape(geometry: GeometryProxy) -> some View {
        self.model.isHit = hit(geometry: geometry)
        return KeyShape(radius: 8, type: model.type)
            .fill(model.getColor())
    }

    func onEvent(handler: @escaping ((KeyInfo) -> Void)) -> some View {
        return self.onReceive(model.subject, perform: { (keyInfo) in
            handler(keyInfo)
        })
    }
}


class SoundModel {

    let piano = PianoSound()

    func called(keyInfo: KeyInfo) {
        print(keyInfo.description)
        if keyInfo.isPressed {
            piano.play(keyInfo: keyInfo)
        } else {
            piano.stop(keyInfo: keyInfo)
        }
    }

}

