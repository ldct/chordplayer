//
//  chordplayerTests.swift
//  chordplayerTests
//
//  Created by Li Xuanji on 27/12/22.
//

import XCTest
@testable import chordplayer

final class chordplayerTests: XCTestCase {
    func testExample() throws {
        let F = MusicalNote(letter: .F, accidentals: 0)
        let G = MusicalNote(letter: .G, accidentals: 0)

        print(notes_in_major_key(rootNote: MusicalNote(letter: .C, accidentals: 0)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .G, accidentals: 0)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .D, accidentals: 0)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .A, accidentals: 0)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .E, accidentals: 0)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .B, accidentals: 0)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .F, accidentals: 1)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .C, accidentals: 1)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .G, accidentals: 1)))


        print(notes_in_major_key(rootNote: MusicalNote(letter: .F, accidentals: 0)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .B, accidentals: -1)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .E, accidentals: -1)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .A, accidentals: -1)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .D, accidentals: -1)))
        print(notes_in_major_key(rootNote: MusicalNote(letter: .G, accidentals: -1)))





    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
