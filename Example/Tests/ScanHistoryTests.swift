//
//  ScanHistoryTests.swift
//  SplitScreenScanner_Tests
//
//  Created by Sean Machen on 4/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import SplitScreenScanner

class ScanHistoryTests: XCTestCase {
    
    func testCurrentScanNumber() {
        let firstScan = ScanHistory(barcode: "0000000001", scanKind: .success(description: nil))
        let secondScan = ScanHistory(barcode: "0000000002", scanKind: .error(description: "Invalid Scan"))
        let thirdScan = ScanHistory(barcode: "0000000345", scanKind: .success(description: nil))

        XCTAssertEqual(firstScan.scanNumber, 1)
        XCTAssertEqual(secondScan.scanNumber, 2)
        XCTAssertEqual(thirdScan.scanNumber, 3)
    }
}
