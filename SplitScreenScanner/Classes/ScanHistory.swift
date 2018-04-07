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
}

struct ScanHistory {
    let barcode: String
    let scanKind: ScanKind
    let scanNumber: Int

    enum ScanKind {
        case success(description: String?)
        case warning(description: String)
        case error(description: String)
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
