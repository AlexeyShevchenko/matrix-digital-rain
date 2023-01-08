//
//  VerticalOffsetsProvider.swift
//  MatrixDigitalRain
//
//  Created by Aleksey Shevchenko on 08.01.2023.
//

protocol VerticalOffsetsProviding: AnyObject {
    func verticalOffsets(_ columnsCount: Int) -> [Int]
}

class VerticalOffsetsProvider: VerticalOffsetsProviding {
    func verticalOffsets(_ columnsCount: Int) -> [Int] {
        var offsetsArray: [Int] = []
        for i in 0..<columnsCount {
            offsetsArray.append(i)
        }
        var shuffledOffsets = offsetsArray
        for index in 0..<shuffledOffsets.count {
            let randomIndex = Int.random(in: 0..<shuffledOffsets.count)
            let temp = shuffledOffsets[index]
            shuffledOffsets[index] = shuffledOffsets[randomIndex]
            shuffledOffsets[randomIndex] = temp
        }
        return shuffledOffsets
    }
}
