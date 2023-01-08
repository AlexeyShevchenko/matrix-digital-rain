//
//  String+Extensions.swift
//  MatrixDigitalRain
//
//  Created by Aleksey Shevchenko on 08.01.2023.
//

import Foundation

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
