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

public struct MusicalNote: Hashable, Identifiable, CustomDebugStringConvertible {
    public var id: Self { self }

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

public struct MusicalTriad: Hashable, Identifiable, CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(rootNote) \(modality)"
    }
    
    let rootNote: MusicalNote
    let modality: Modality
    
    public var id: String {
        debugDescription
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


func triads_in_major_key(rootNote: MusicalNote) -> [MusicalTriad] {
    let notes = notes_in_major_key(rootNote: rootNote)
    let modalities: [Modality] = [.major, .minor, .minor, .major, .major, .minor, .diminished]
    
    return zip(notes, modalities).map { r in
        MusicalTriad(rootNote: r.0, modality: r.1)
    }
}

enum Modality: String {
    case major = ""
    case minor = "m"
    case diminished = "dim"
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

let allNotes: [MusicalNote] = MusicalLetter.allCases.flatMap { note in
    [
        MusicalNote(letter: note, accidentals: 0),
        MusicalNote(letter: note, accidentals: 1),
        MusicalNote(letter: note, accidentals: -1)
    ]
}

let twelveNotes: [MusicalNote] = [
    MusicalNote(letter: .C, accidentals: 0),
    MusicalNote(letter: .D, accidentals: -1),
    MusicalNote(letter: .D, accidentals: 0),
    MusicalNote(letter: .E, accidentals: -1),
    MusicalNote(letter: .E, accidentals: 0),
    MusicalNote(letter: .F, accidentals: 0),
    MusicalNote(letter: .F, accidentals: 1),
    MusicalNote(letter: .G, accidentals: 0),
    MusicalNote(letter: .A, accidentals: -1),
    MusicalNote(letter: .A, accidentals: 0),
    MusicalNote(letter: .B, accidentals: -1),
    MusicalNote(letter: .B, accidentals: 0),




]

let allKeys: [MusicalKey] = MusicalLetter.allCases.flatMap { note in
    [
        MusicalKey(rootNote: MusicalNote(letter: note, accidentals: 0), modality: .major),
        MusicalKey(rootNote: MusicalNote(letter: note, accidentals: 1), modality: .major),
        MusicalKey(rootNote: MusicalNote(letter: note, accidentals: -1), modality: .major),

    ]
}
