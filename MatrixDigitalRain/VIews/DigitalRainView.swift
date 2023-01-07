//
//  DigitalRainView.swift
//  MatrixDigitalRain
//
//  Created by Aleksey Shevchenko on 03.01.2023.
//

import SwiftUI
import Foundation

extension DigitalRainView {
    func drow(_ charsInDrop: [String]) -> some View {
        VStack {
            HStack {
                ForEach(0..<charsInDrop.count, id: \.self) { index in
                    Text(charsInDrop[index])
                }
            }
        }
    }
}

extension DigitalRainView {
    struct Matrix {
        let columnsCount: Int
        let rowsCount: Int
    }
}

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

protocol CharsProviding: AnyObject {
    func chars(_ rowsCount: Int, _ columnsCount: Int, _ sourceString: String) -> [[Character]]
}

class CharsProvider: CharsProviding {
    func chars(_ rowsCount: Int, _ columnsCount: Int, _ sourceString: String) -> [[Character]] {
        var result: [[Character]] = []
        for _ in 0..<rowsCount {
            let s = String.randomSubstring(
                ofLength: columnsCount,
                from: sourceString
            ).map { $0 }
            result.append(s)
        }
        return result
    }
}

extension DigitalRainView {
    class ViewModel: ObservableObject {
        private let dropHeight: CGFloat
        private let dropWidth: CGFloat
        private let columnsCount: Int
        private let rowsCount: Int
        private let visibleDropLength: Int
        private let sourceString: String
        private let wholeRowsCount: Int
        
        private let verticalOffsetsProvider: VerticalOffsetsProviding
        private let charsProvider: CharsProviding
        
        private var verticalOffsets: [Int]
        private var chars: [[Character]]
        
        let dropSize: CGSize
        let matrix: Matrix
        
        @Published private var currentYIndex: Int = 0

        init(
            sourceString: String,
            dropHeight: CGFloat,
            columnsCount: Int,
            verticalOffsetsProvider: VerticalOffsetsProviding,
            charsProvider: CharsProviding
        ) {
            self.sourceString = sourceString
            self.dropHeight = dropHeight
            self.columnsCount = columnsCount
            self.verticalOffsetsProvider = verticalOffsetsProvider
            self.charsProvider = charsProvider
            
            rowsCount = .init(UIScreen.main.bounds.height / dropHeight)
            dropWidth = UIScreen.main.bounds.width / CGFloat(columnsCount)
            dropSize = .init(width: dropWidth, height: dropHeight)
            matrix = .init(columnsCount: columnsCount, rowsCount: rowsCount)
            visibleDropLength = Int(CGFloat(matrix.rowsCount) / 2.5)
            wholeRowsCount = rowsCount + visibleDropLength + visibleDropLength

            verticalOffsets = verticalOffsetsProvider.verticalOffsets(columnsCount)
            chars = charsProvider.chars(rowsCount, columnsCount, sourceString)
        }
        
        func shuffleArray(array: [Int]) -> [Int] {
            var shuffledArray = array
            for index in 0..<shuffledArray.count {
                let randomIndex = Int.random(in: 0..<shuffledArray.count)
                let temp = shuffledArray[index]
                shuffledArray[index] = shuffledArray[randomIndex]
                shuffledArray[randomIndex] = temp
            }
            return shuffledArray
        }
    }
}

// MARK: - UI -

extension DigitalRainView.ViewModel {
    func char(_ rowIndex: Int, _ columnIndex: Int) -> String {
        String(chars[rowIndex][columnIndex])
    }
    
    // MARK: - should be a bit difficulty
    func opacity(_ rowIndex: Int, _ columnIndex: Int) -> CGFloat {
        let verticalOffset = verticalOffsets[columnIndex]
        if currentYIndex < (rowIndex + verticalOffset) {
            return 0
        } else {
            return getOpacity(rowIndex, columnIndex)
        }
    }
    
    private func getOpacity(_ rowIndex: Int, _ columnIndex: Int) -> CGFloat {
        let verticalOffset = verticalOffsets[columnIndex]
        
        let proprotion = CGFloat((currentYIndex - rowIndex - verticalOffset)) / CGFloat(visibleDropLength)
        return 1 - proprotion
    }
}

// MARK: - Timer -

extension DigitalRainView.ViewModel {
    func startTimer() {
        Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ) { [weak self] timer in
            guard let self = self else { return }
            self.updateCurrentIndex()
        }
    }
    
    private func updateCurrentIndex() {
        if currentYIndex == wholeRowsCount - 1 {
            self.resetCurrentIndex()
        } else {
            self.incrementCurrentIndex()
        }
    }
    
    private func resetCurrentIndex() {
        currentYIndex = 0
    }
    
    private func incrementCurrentIndex() {
        currentYIndex += 1
    }
}

struct DigitalRainView: View {
    @ObservedObject var viewModel: ViewModel
    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

extension DigitalRainView {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0..<viewModel.matrix.rowsCount, id: \.self) { rowIndex in
                    GridRow {
                        ForEach(0..<viewModel.matrix.columnsCount, id: \.self) { columnIndex in
                            Text(viewModel.char(rowIndex, columnIndex))
                                .foregroundColor(Color.green)
                                .opacity(viewModel.opacity(rowIndex, columnIndex))
                                .frame(width: viewModel.dropSize.width, height: viewModel.dropSize.height)
                        }
                    }
                }
            }
        }.onAppear {
            viewModel.startTimer()
        }
    }
}


extension String {
    static func randomSubstring(ofLength length: Int, from string: String) -> String {
        var result = ""
        let indices = string.indices
        while result.count < length {
            if let randomIndex = indices.randomElement() {
                result.append(string[randomIndex])
            }
        }
        return result
    }
}
