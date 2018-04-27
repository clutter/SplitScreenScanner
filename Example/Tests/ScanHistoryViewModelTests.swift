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
    private var sink: DelegateSink!
    private var vm: ScanHistoryViewModel!

    private let testScanHistoryDisplayer = TestScanHistoryDisplayer()

    private final class DelegateSink: ScanHistoryViewModelDelegate {
        var scanningSessionExpired = false

        func expireScanningSession(_ scanHistoryViewModel: ScanHistoryViewModel) {
            scanningSessionExpired = true
        }
    }

    private struct TestScanHistoryDisplayer: ScanHistoryDisplaying {
        let tableViewHeader: String
        let nothingScannedText: String

        init() {
            tableViewHeader = "Test TableView Header"
            nothingScannedText = "Test no scan text"
        }
    }

    override func tearDown() {
        vm.invalidateExpireSessionTimer()
    }

    func testNoScansIndexing() {
        setUpVM(scans: [])

        XCTAssertEqual(vm.sections.count, 1)
        XCTAssertEqual(vm.sections[0].name, testScanHistoryDisplayer.tableViewHeader)

        XCTAssertEqual(vm.sections[0].rows, [.nothingScannedRow(nothingScannedText: testScanHistoryDisplayer.nothingScannedText)])
    }

    func testWithScansIndexing() {
        let secondScan = ScanHistory(barcode: "0000000002", scanResult: .error(description: "We no longer store abstract concepts of thought"))
        let firstScan = ScanHistory(barcode: "0000000001", scanResult: .success(description: nil))
        let scans = [secondScan, firstScan]

        setUpVM(scans: scans)

        XCTAssertEqual(vm.sections.count, 1)
        XCTAssertEqual(vm.sections[0].name, testScanHistoryDisplayer.tableViewHeader)

        XCTAssertEqual(vm.sections[0].rows.count, 2)
        XCTAssertEqual(vm.sections[0].rows[0], .historyRow(barcode: "0000000002", scanResult: .error(description: "We no longer store abstract concepts of thought")))
        XCTAssertEqual(vm.sections[0].rows[1], .historyRow(barcode: "0000000001", scanResult: .success(description: nil)))
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
        let firstScan = ScanHistory(barcode: "0000000001", scanResult: .success(description: nil))
        let secondScan = ScanHistory(barcode: "0000000002", scanResult: .error(description: "We no longer store abstract concepts of thought"))
        let scans = [firstScan, secondScan]

        setUpVM(scans: scans)

        var rowInsertedIndexPath: IndexPath?
        vm.insertRowBinding = { indexPath in
            rowInsertedIndexPath = indexPath
        }

        vm.didScan(barcode: "0000000003", with: .success(description: nil))
        XCTAssertEqual(rowInsertedIndexPath, IndexPath(row: 0, section: 0))
    }

    func testCreateExpireSessionTimer() {
        setUpVM(scans: [])

        vm.createExpireSessionTimer()

        XCTAssertNotNil(vm.expireSessionTimer)
    }

    func testInvalidateExpireSessionTimer() {
        setUpVM(scans: [])

        vm.createExpireSessionTimer()
        vm.invalidateExpireSessionTimer()

        XCTAssertNil(vm.expireSessionTimer)
    }

    func testExpireScanningSession() {
        setUpVM(scans: [])

        vm.expireScanningSession()
        XCTAssertTrue(sink.scanningSessionExpired)
    }

    func testUnexpirableScanningSessionTimer() {
        setUpVM(scans: [], isScanningSessionExpirable: false)

        vm.createExpireSessionTimer()

        XCTAssertNil(vm.expireSessionTimer)
    }

    func testUnexpirableScanningSessionExpiration() {
        setUpVM(scans: [], isScanningSessionExpirable: false)

        vm.expireScanningSession()

        XCTAssertFalse(sink.scanningSessionExpired)
    }
}

// MARK: - Private Methods
private extension ScanHistoryViewModelTests {
    func setUpVM(scans: [ScanHistory], isScanningSessionExpirable: Bool = true) {
        sink = DelegateSink()
        vm = ScanHistoryViewModel(scans: scans, scanHistoryDisplaying: testScanHistoryDisplayer, isScanningSessionExpirable: isScanningSessionExpirable)
        vm.delegate = sink
    }
}
