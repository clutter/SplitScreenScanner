//
//  ScanToContinueDataSource.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/19/18.
//

import Foundation

public protocol ScanToContinueDataSource {
    var startingTitle: String { get }
    var startingDescription: String? { get }
    var continuingTitle: String { get }
    var continuingDescription: String? { get }

    func scan(startingBarcode: String) -> ScanResult
    func playScanToContinueSound(for result: ScanResult)
    func didExpireScanningSession()
}
