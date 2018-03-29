//
//  ScanHistory.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/28/18.
//

import Foundation

struct ScanHistory {
    private static var currentScanNumber = 1

    let barcode: String
    let scanKind: ScanKind
    let scanNumber: Int

    enum ScanKind {
        case success(description: String?)
        case warning(description: String)
        case Error(description: String)
    }

    init(barcode: String, scanKind: ScanKind) {
        self.barcode = barcode
        self.scanKind = scanKind

        self.scanNumber = ScanHistory.currentScanNumber
        ScanHistory.currentScanNumber += 1
    }
}


