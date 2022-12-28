//
//  MusicTheory.swift
//  chordplayer
//
//  Created by Li Xuanji on 28/12/22.
//

import Foundation

enum MusicalLetter: Int, CaseIterable {
    case C = 0
    case D = 2
    case E = 4
    case F = 5
    case G = 7
    case A = 9
    case B = 11
    
    var description: String {
        switch self {
        case .C: return "C"
        case .D: return "D"
        case .E: return "E"
        case .F: return "F"
        case .G: return "G"
        case .A: return "A"
        case .B: return "B"
        }
    }
}

public struct MusicalNote: Hashable, CustomDebugStringConvertible {
    let letter: MusicalLetter
    let accidentals: Int
    
    public var debugDescription: String {
        if accidentals == 0 {
            return letter.description
        } else if accidentals > 0 {
            return letter.description + String(repeating: "#", count: accidentals)
        } else {
            return letter.description + String(repeating: "b", count: -accidentals)
        }
    }
    
    
    
    var asPitch: Int {
        letter.rawValue + accidentals
    }
}

extension RangeReplaceableCollection {
    func rotatingLeft(positions: Int) -> SubSequence {
        let index = self.index(startIndex, offsetBy: positions, limitedBy: endIndex) ?? endIndex
        return self[index...] + self[..<index]
    }
    mutating func rotateLeft(positions: Int) {
        let index = self.index(startIndex, offsetBy: positions, limitedBy: endIndex) ?? endIndex
        let slice = self[..<index]
        removeSubrange(..<index)
        insert(contentsOf: slice, at: endIndex)
    }
}

func notes_in_major_key(rootNote: MusicalNote) -> [MusicalNote] {
    let rootPitch = rootNote.asPitch
    let pitches = [rootPitch, rootPitch+2, rootPitch+4, rootPitch+5, rootPitch+7, rootPitch+9, rootPitch+11].map { $0 }
        
    var letters = MusicalLetter.allCases
    
    while letters.first != rootNote.letter {
        letters.rotateLeft(positions: 1)
    }
    
    return zip(letters, pitches).map { r in
        var a = (r.1 - r.0.rawValue)
        while a >= 12 {
            a -= 12
        }
        if a > 3 {
            a -= 12
        }
        return MusicalNote(letter: r.0, accidentals: a)
    }
}

enum Modality: String {
    case major
    case minor
}

struct MusicalKey: Hashable, Identifiable {
    var id: Self { self }

    let rootNote: MusicalNote
    let modality: Modality

    var toString: String {
        "\(rootNote) \(modality)"
    }
    
    static let defaultKey = MusicalKey(rootNote: MusicalNote(letter: .C, accidentals: 0), modality: .major)
}

let allKeys: [MusicalKey] = MusicalLetter.allCases.flatMap { note in
    [
        MusicalKey(rootNote: MusicalNote(letter: note, accidentals: 0), modality: .major),
    ]
}
