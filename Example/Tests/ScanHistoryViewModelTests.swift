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
        setUpVM(scans: [])

        XCTAssertEqual(vm.sections.count, 1)
        XCTAssertEqual(vm.sections[0].name, testTableViewHeader)

        XCTAssertEqual(vm.sections[0].rows, [.nothingScannedRow(noScanText: testNoScanText)])
    }

    func testWithScansIndexing() {
        let firstScan = ScanHistory(barcode: "0000000001", scanResult: .success(description: nil), scanNumber: 1)
        let secondScan = ScanHistory(barcode: "0000000002", scanResult: .error(description: "We no longer store abstract concepts of thought"), scanNumber: 2)
        let scans = [firstScan, secondScan]

        setUpVM(scans: scans)

        XCTAssertEqual(vm.sections.count, 1)
        XCTAssertEqual(vm.sections[0].name, testTableViewHeader)

        XCTAssertEqual(vm.sections[0].rows.count, 2)
        XCTAssertEqual(vm.sections[0].rows[0], .historyRow(barcode: "0000000002", scanResult: .error(description: "We no longer store abstract concepts of thought"), scanNumber: 2))
        XCTAssertEqual(vm.sections[0].rows[1], .historyRow(barcode: "0000000001", scanResult: .success(description: nil), scanNumber: 1))
    }

    func testFirstScan() {
        setUpVM(scans: [])

        var rowReloadedIndexPath: IndexPath?
        vm.reloadRowBinding = { indexPath in
            rowReloadedIndexPath = indexPath
        }

        vm.didScan(barcode: "0000000001", with: .success(description: nil))
        XCTAssertEqual(rowReloadedIndexPath, IndexPath(row: 0, section: 0))
    }

    func testSubsequentScan() {
        let firstScan = ScanHistory(barcode: "0000000001", scanResult: .success(description: nil), scanNumber: 1)
        let secondScan = ScanHistory(barcode: "0000000002", scanResult: .error(description: "We no longer store abstract concepts of thought"), scanNumber: 2)
        let scans = [firstScan, secondScan]

        setUpVM(scans: scans)

        var rowInsertedIndexPath: IndexPath?
        vm.insertRowBinding = { indexPath in
            rowInsertedIndexPath = indexPath
        }

        vm.didScan(barcode: "0000000003", with: .success(description: nil))
        XCTAssertEqual(rowInsertedIndexPath, IndexPath(row: 0, section: 0))
    }
}

// MARK: - Private Methods
private extension ScanHistoryViewModelTests {
    func setUpVM(scans: [ScanHistory]) {
        vm = ScanHistoryViewModel(scans: scans, tableViewHeader: testTableViewHeader, noScanText: testNoScanText)
    }
}
