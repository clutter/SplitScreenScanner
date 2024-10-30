//
//  ScanHistoryDataSource.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/20/18.
//

import Foundation

public protocol ScanHistoryDataSource {
    var tableViewHeaderTitle: String { get }
    var tableViewHeaderSubtitle: String? { get }
    var nothingScannedText: String { get }
    var scanningSessionDurationInSeconds: TimeInterval { get }

    func playBarcodeScanSound(for result: ScanResult)
}

public extension ScanHistoryDataSource {
    var scanningSessionDurationInSeconds: TimeInterval { 45.0 }
}
