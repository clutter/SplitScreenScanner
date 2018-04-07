//
//  ScanHistoryViewModelTests.swift
//  SplitScreenScanner_Tests
//
//  Created by Sean Machen on 4/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import SplitScreenScanner

class ScanHistoryViewModelTests: XCTestCase {
    let testTableViewHeader = "Test TableView Header"
    let testNoScanText = "Test no scan text"

    var vm: ScanHistoryViewModel!
    
    func testNoScansIndexing() {
        setupVM(scans: [])

        XCTAssertEqual(vm.sections.count, 1)
        XCTAssertEqual(vm.sections[0].name, testTableViewHeader)

        XCTAssertEqual(vm.sections[0].rows.count, 1)
        XCTAssertEqual(vm.sections[0].rows[0], .nothingScannedRow(noScanText: testNoScanText))
    }

    func testWithScansIndexing() {
        let firstScan = ScanHistory(barcode: "0000000001", scanKind: .success(description: nil))
        let secondScan = ScanHistory(barcode: "0000000002", scanKind: .error(description: "We no longer store abstract concepts of thought"))
        let scans = [firstScan, secondScan]

        setupVM(scans: scans)

        XCTAssertEqual(vm.sections.count, 1)
        XCTAssertEqual(vm.sections[0].name, testTableViewHeader)

        XCTAssertEqual(vm.sections[0].rows.count, 2)
        XCTAssertEqual(vm.sections[0].rows[0], .historyRow(barcode: "0000000002", scanKind: .error(description: "We no longer store abstract concepts of thought"), scanNumber: 2))
        XCTAssertEqual(vm.sections[0].rows[1], .historyRow(barcode: "0000000001", scanKind: .success(description: nil), scanNumber: 1))
    }
}

// MARK: - Private Methods
private extension ScanHistoryViewModelTests {
    func setupVM(scans: [ScanHistory]) {
        vm = ScanHistoryViewModel(scans: scans, tableViewHeader: testTableViewHeader, noScanText: testNoScanText)
    }
}
