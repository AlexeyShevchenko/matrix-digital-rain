//
//  ContentView.swift
//  MatrixDigitalRain
//
//  Created by Aleksey Shevchenko on 03.01.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DownpourView(.init())
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
