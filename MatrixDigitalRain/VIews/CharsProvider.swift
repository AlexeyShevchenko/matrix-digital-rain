//
//  CharsProvider.swift
//  MatrixDigitalRain
//
//  Created by Aleksey Shevchenko on 08.01.2023.
//

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
