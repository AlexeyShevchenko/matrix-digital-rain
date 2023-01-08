//
//  DownpourView.swift
//  MatrixDigitalRain
//
//  Created by Aleksey Shevchenko on 08.01.2023.
//

import SwiftUI

// MARK: - Model -

extension DownpourView {
    class ViewModel: ObservableObject {}
}

extension DownpourView.ViewModel {
    var randomOffset: CGSize {
        let x: CGFloat = CGFloat(Float.random(in: -20..<20))
        let y: CGFloat = CGFloat(Float.random(in: -20..<20))
        return .init(width: x, height: y)
    }
}

// MARK: - View -

struct DownpourView: View {
    @ObservedObject var viewModel: DownpourView.ViewModel
    init(_ viewModel: DownpourView.ViewModel) {
        self.viewModel = viewModel
    }
}

extension DownpourView {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ForEach(0..<7, id: \.self) { index in
                DigitalRainView(
                    .init(
                        sourceString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
                        dropHeight: 20,
                        columnsCount: 50,
                        startIn: 9 * Double(index),
                        verticalOffsetsProvider: VerticalOffsetsProvider(),
                        charsProvider: CharsProvider()
                    )
                )
                .offset(viewModel.randomOffset)
            }
        }
    }
}

struct DownpourView_Previews: PreviewProvider {
    static var previews: some View {
        DownpourView(.init())
    }
}
