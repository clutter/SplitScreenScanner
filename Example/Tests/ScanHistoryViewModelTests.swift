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

    private let testScanHistoryDataSource = TestScanHistoryDataSource()

    private final class DelegateSink: ScanHistoryViewModelDelegate {
        var scanningSessionExpired = false

        func expireScanningSession(_ scanHistoryViewModel: ScanHistoryViewModel) {
            scanningSessionExpired = true
        }
    }

    private struct TestScanHistoryDataSource: ScanHistoryDataSource {
        let tableViewHeader: String
        let nothingScannedText: String

        init() {
            tableViewHeader = "Test TableView Header"
            nothingScannedText = "Test no scan text"
        }

        func playBarcodeScanSound(for result: ScanResult) {
            // NOOP
        }
    }

    override func tearDown() {
        vm.invalidateExpireSessionTimer()
    }

    func testNoScansIndexing() {
        setUpVM(scans: [], isScanningSessionExpirable: true)

        XCTAssertEqual(vm.sections.count, 1)
        XCTAssertEqual(vm.sections[0].name, testScanHistoryDataSource.tableViewHeader)

        XCTAssertEqual(vm.sections[0].rows, [.nothingScannedRow(nothingScannedText: testScanHistoryDataSource.nothingScannedText)])
    }

    func testWithScansIndexing() {
        let secondScan = ScanHistory(barcode: "0000000002", scanResult: .error(description: "We no longer store abstract concepts of thought"))
        let firstScan = ScanHistory(barcode: "0000000001", scanResult: .success(description: nil))
        let scans = [secondScan, firstScan]

        setUpVM(scans: scans, isScanningSessionExpirable: true)

        XCTAssertEqual(vm.sections.count, 1)
        XCTAssertEqual(vm.sections[0].name, testScanHistoryDataSource.tableViewHeader)

        XCTAssertEqual(vm.sections[0].rows.count, 2)
        XCTAssertEqual(vm.sections[0].rows[0], .historyRow(barcode: "0000000002", scanResult: .error(description: "We no longer store abstract concepts of thought")))
        XCTAssertEqual(vm.sections[0].rows[1], .historyRow(barcode: "0000000001", scanResult: .success(description: nil)))
    }

    func testFirstScan() {
        setUpVM(scans: [], isScanningSessionExpirable: true)

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

        setUpVM(scans: scans, isScanningSessionExpirable: true)

        var rowInsertedIndexPath: IndexPath?
        vm.insertRowBinding = { indexPath in
            rowInsertedIndexPath = indexPath
        }

        vm.didScan(barcode: "0000000003", with: .success(description: nil))
        XCTAssertEqual(rowInsertedIndexPath, IndexPath(row: 0, section: 0))
    }

    func testCreateExpireSessionTimer() {
        setUpVM(scans: [], isScanningSessionExpirable: true)

        vm.createExpireSessionTimer()
        XCTAssertNotNil(vm.expireSessionTimer)
    }

    func testInvalidateExpireSessionTimer() {
        setUpVM(scans: [], isScanningSessionExpirable: true)

        vm.createExpireSessionTimer()
        vm.invalidateExpireSessionTimer()

        XCTAssertNil(vm.expireSessionTimer)
    }

    func testExpireScanningSession() {
        setUpVM(scans: [], isScanningSessionExpirable: true)

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

    func testHapticFeedback() {
        setUpVM(scans: [], isScanningSessionExpirable: true)
        XCTAssertNil(vm.hapticFeedbackManager)

        vm.isHapticFeedbackEnabled = true
        XCTAssertNotNil(vm.hapticFeedbackManager)

        vm.isHapticFeedbackEnabled = false
        XCTAssertNil(vm.hapticFeedbackManager)
    }
}

// MARK: - Private Methods
private extension ScanHistoryViewModelTests {
    func setUpVM(scans: [ScanHistory], isScanningSessionExpirable: Bool) {
        sink = DelegateSink()
        vm = ScanHistoryViewModel(scans: scans, scanHistoryDataSource: testScanHistoryDataSource, isScanningSessionExpirable: isScanningSessionExpirable)
        vm.delegate = sink
    }
}
