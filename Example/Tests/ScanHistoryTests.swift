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
    func testScanNumberGeneration() {
        var scanNumberGenerator = ScanNumberGenerator()
        let firstScan = ScanHistory(barcode: "0000000001", scanResult: .success(description: nil), scanNumber: scanNumberGenerator.generate())
        let secondScan = ScanHistory(barcode: "0000000002", scanResult: .error(description: "Invalid Scan"), scanNumber: scanNumberGenerator.generate())
        let thirdScan = ScanHistory(barcode: "0000000345", scanResult: .success(description: nil), scanNumber: scanNumberGenerator.generate())

        XCTAssertEqual(firstScan.scanNumber, 1)
        XCTAssertEqual(secondScan.scanNumber, 2)
        XCTAssertEqual(thirdScan.scanNumber, 3)
    }
}
