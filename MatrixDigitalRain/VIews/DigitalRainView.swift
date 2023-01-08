//
//  DigitalRainView.swift
//  MatrixDigitalRain
//
//  Created by Aleksey Shevchenko on 03.01.2023.
//

import SwiftUI

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
                                .font(viewModel.font)
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
