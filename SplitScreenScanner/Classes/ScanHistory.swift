//
//  ScanHistory.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/28/18.
//

import Foundation

public enum ScanResult: Equatable {
    case success(description: String?)
    case warning(description: String)
    case error(description: String)
}

struct ScanHistory {
    let barcode: String
    let scanResult: ScanResult
}
