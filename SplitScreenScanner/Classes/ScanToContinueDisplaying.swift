//
//  ScanToContinueDisplaying.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/19/18.
//

import Foundation

public protocol ScanToContinueDisplaying {
    var startingTitle: String { get }
    var startingDescription: String? { get }
    var continuingTitle: String { get }
    var continuingDescription: String? { get }

    func scan(startingBarcode: String) -> ScanResult
}
