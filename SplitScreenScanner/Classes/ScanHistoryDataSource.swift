//
//  ScanHistoryDataSource.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/20/18.
//

import Foundation

public protocol ScanHistoryDataSource {
    var tableViewHeader: String { get }
    var nothingScannedText: String { get }

    func playBarcodeScanSound(for result: ScanResult)
}
