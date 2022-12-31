//
//  shapetest.swift
//  chordplayer
//
//  Created by Li Xuanji on 30/12/22.
//

import Foundation

protocol Shape2 {
    func draw() -> String
}

struct Triangle: Shape2 {
    var size: Int
    func draw() -> String {
        var result: [String] = []
        for length in 1...size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}

struct Square: Shape2 {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}

struct FlippedShape<T: Shape2>: Shape2 {
    var shape: T
    func draw() -> String {
        if shape is Square {
            return shape.draw()
        }
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

func protoFlip<T: Shape2>(_ shape: T) -> Shape2 {
    if shape is Square {
        return shape
    }

    return FlippedShape(shape: shape)
}

func makeThat() -> Shape2 {
    let smallTriangle = Triangle(size: 3)
    let r = protoFlip(protoFlip(smallTriangle))
    return r
}
