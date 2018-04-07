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
        case error(description: String)
    }

    init(barcode: String, scanKind: ScanKind) {
        self.barcode = barcode
        self.scanKind = scanKind

        self.scanNumber = ScanHistory.currentScanNumber
        ScanHistory.currentScanNumber += 1
    }
}

// MARK: - ScanKind Equatable
extension ScanHistory.ScanKind: Equatable {
    static func == (lhs: ScanHistory.ScanKind, rhs: ScanHistory.ScanKind) -> Bool {
        switch (lhs, rhs) {
        case let (.success(lhsDescription), .success(rhsDescription)):
            return lhsDescription == rhsDescription
        case let (.warning(lhsDescription), .warning(rhsDescription)):
            return lhsDescription == rhsDescription
        case let (.error(lhsDescription), .error(rhsDescription)):
            return lhsDescription == rhsDescription
        default:
            return false
        }
    }
}
