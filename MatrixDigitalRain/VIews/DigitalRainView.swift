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
    class ViewModel: ObservableObject {
        let sourceString: String
        let dropHeight: CGFloat
        let dropWidth: CGFloat
        let columnsCount: Int
        let rowsCount: Int
        
        @Published var chars: [[Character]]
        
        init(
            sourceString: String,
            dropHeight: CGFloat,
            columnsCount: Int
        ) {
            self.sourceString = sourceString
            self.dropHeight = dropHeight
            self.columnsCount = columnsCount
            self.rowsCount = Int(UIScreen.main.bounds.height / dropHeight)
            self.dropWidth = UIScreen.main.bounds.width / CGFloat(columnsCount)
            
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
        
        func char(_ x: Int, _ y: Int) -> String {
            String(chars[x][y])
        }
        
        func opacity(_ x: Int, _ y: Int) -> CGFloat {
            0.1
        }
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
                ForEach(0..<viewModel.rowsCount, id: \.self) { xIndex in
                    GridRow {
                        ForEach(0..<viewModel.columnsCount, id: \.self) { yIndex in
                            Text(viewModel.char(xIndex, yIndex))
                                .foregroundColor(Color.green)
                                .opacity(viewModel.opacity(xIndex, yIndex))
                                .frame(width: viewModel.dropWidth, height: viewModel.dropHeight)
                        }
                    }
                }
            }
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
