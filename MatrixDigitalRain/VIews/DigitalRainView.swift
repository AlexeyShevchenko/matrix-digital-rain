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

extension DigitalRainView {
    class ViewModel: ObservableObject {
        private let dropHeight: CGFloat
        private let dropWidth: CGFloat
        private let columnsCount: Int
        private let rowsCount: Int
        private let visibleDropLength: Int
        
        let sourceString: String
        let dropSize: CGSize
        let matrix: Matrix
        
        @Published private var currentIndex: Int = 0
        @Published var chars: [[Character]]
        
        init(
            sourceString: String,
            dropHeight: CGFloat,
            columnsCount: Int
        ) {
            self.sourceString = sourceString
            self.dropHeight = dropHeight
            self.columnsCount = columnsCount
            self.rowsCount = .init(UIScreen.main.bounds.height / dropHeight)
            self.dropWidth = UIScreen.main.bounds.width / CGFloat(columnsCount)
            self.dropSize = .init(width: dropWidth, height: dropHeight)
            self.matrix = .init(columnsCount: columnsCount, rowsCount: rowsCount)
            self.visibleDropLength = matrix.rowsCount / 3
            
            var result: [[Character]] = []
            for _ in 0..<rowsCount {
                let s = String.randomSubstring(
                    ofLength: columnsCount,
                    from: sourceString
                ).map { $0 }
                result.append(s)
            }
            chars = result
        }
    }
}

// MARK: - UI -

extension DigitalRainView.ViewModel {
    func char(_ x: Int, _ y: Int) -> String {
        String(chars[x][y])
    }
    
    // MARK: - should be a bit difficulty
    func opacity(_ x: Int, _ y: Int) -> CGFloat {
        if x > currentIndex {
            return 0
        } else {
            return getOpacity(x, y)
        }
    }
    
    private func getOpacity(_ x: Int, _ y: Int) -> CGFloat {
        let proprotion = CGFloat((currentIndex - x)) / CGFloat(visibleDropLength)
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
            if self.currentIndex == self.rowsCount - 1 {
                self.resetCurrentIndex()
            } else {
                self.incrementCurrentIndex()
            }
        }
    }
    
    private func resetCurrentIndex() {
        currentIndex = 0
    }
    
    private func incrementCurrentIndex() {
        currentIndex += 1
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
                ForEach(0..<viewModel.matrix.rowsCount, id: \.self) { xIndex in
                    GridRow {
                        ForEach(0..<viewModel.matrix.columnsCount, id: \.self) { yIndex in
                            Text(viewModel.char(xIndex, yIndex))
                                .foregroundColor(Color.green)
                                .opacity(viewModel.opacity(xIndex, yIndex))
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
