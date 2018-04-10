//
//  ScanHistory.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/28/18.
//

import Foundation

struct ScanNumberGenerator {
    private(set) var currentScanNumber: Int

    mutating func generate() -> Int {
        self.currentScanNumber += 1
        return currentScanNumber
    }

    init() {
        currentScanNumber = 0
    }

    init(startIndex: Int) {
        currentScanNumber = startIndex
    }
}

public enum ScanResult: Equatable {
    case success(description: String?)
    case warning(description: String)
    case error(description: String)
}

struct ScanHistory {
    let barcode: String
    let scanResult: ScanResult
    let scanNumber: Int
}
