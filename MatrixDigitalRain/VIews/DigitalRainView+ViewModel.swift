//
//  DigitalRainView+ViewModel.swift
//  MatrixDigitalRain
//
//  Created by Aleksey Shevchenko on 08.01.2023.
//

import SwiftUI

extension DigitalRainView {
    class ViewModel: ObservableObject {
        private let columnsCount: Int
        private let dropHeight: CGFloat
        private let dropWidth: CGFloat
        private let rowsCount: Int
        private let sourceString: String
        private let startIn: TimeInterval
        private let visibleDropLength: Int
        private let wholeRowsCount: Int
        
        private let verticalOffsetsProvider: VerticalOffsetsProviding
        private let charsProvider: CharsProviding
        
        private var verticalOffsets: [Int]
        private var chars: [[Character]]
        
        let dropSize: CGSize
        let font: Font
        let matrix: Matrix

        @Published private var currentYIndex = 0

        init(
            sourceString: String,
            dropHeight: CGFloat,
            columnsCount: Int,
            startIn: TimeInterval,
            verticalOffsetsProvider: VerticalOffsetsProviding,
            charsProvider: CharsProviding
        ) {
            self.sourceString = sourceString
            self.dropHeight = dropHeight
            self.columnsCount = columnsCount
            self.startIn = startIn
            self.verticalOffsetsProvider = verticalOffsetsProvider
            self.charsProvider = charsProvider

            rowsCount = .init(UIScreen.main.bounds.height / dropHeight)
            dropWidth = UIScreen.main.bounds.width / CGFloat(columnsCount)
            dropSize = .init(width: dropWidth, height: dropHeight)
            matrix = .init(columnsCount: columnsCount, rowsCount: rowsCount)
            visibleDropLength = Int(CGFloat(matrix.rowsCount) * 0.75)
            wholeRowsCount = rowsCount + visibleDropLength * 2 + columnsCount * 2
            
            let fontSize: CGFloat = .init(Float.random(in: 15.0...19.0))
            font = .init(UIFont(name: "Matrix Code NFI", size: fontSize) ?? .systemFont(ofSize: fontSize))
            
            verticalOffsets = verticalOffsetsProvider.verticalOffsets(columnsCount)
            chars = charsProvider.chars(rowsCount, columnsCount, sourceString)
        }
    }
}

// MARK: - UI -

extension DigitalRainView.ViewModel {
    func char(_ rowIndex: Int, _ columnIndex: Int) -> String {
        String(chars[rowIndex][columnIndex])
    }

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
        DispatchQueue.main.asyncAfter(deadline: .now() + startIn) {
            Timer.scheduledTimer(
                withTimeInterval: 0.01,
                repeats: true
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateCurrentIndex()
            }
        }
    }
    
    private func updateCurrentIndex() {
        if currentYIndex == wholeRowsCount {
            self.resetCurrentIndex()
        } else {
            self.incrementCurrentIndex()
        }
    }
    
    private func resetCurrentIndex() {
        withAnimation {
            chars = charsProvider.chars(rowsCount, columnsCount, sourceString)
            verticalOffsets = verticalOffsetsProvider.verticalOffsets(columnsCount)
            currentYIndex = 0
        }
    }
    
    private func incrementCurrentIndex() {
        withAnimation { currentYIndex += 1 }
    }
}
