//
//  ScanHistoryViewModelTests.swift
//  SplitScreenScanner_Tests
//
//  Created by Sean Machen on 4/6/18.
//  Copyright © 2018 Clutter Inc. All rights reserved.
//

import XCTest
@testable import SplitScreenScanner

class ScanHistoryViewModelTests: XCTestCase {
    private var sink: DelegateSink!
    private var viewModel: ScanHistoryViewModel!

    private let testScanHistoryDataSource = TestScanHistoryDataSource()

    private final class DelegateSink: ScanHistoryViewModelDelegate {
        var scanningSessionExpired = false

        func expireScanningSession(_ scanHistoryViewModel: ScanHistoryViewModel) {
            scanningSessionExpired = true
        }
    }

    private struct TestScanHistoryDataSource: ScanHistoryDataSource {
        let tableViewHeaderTitle: String
        let tableViewHeaderSubtitle: String?
        let nothingScannedText: String

        init() {
            tableViewHeaderTitle = "Test TableView Header"
            tableViewHeaderSubtitle = "1 / 10"
            nothingScannedText = "Test no scan text"
        }

        func playBarcodeScanSound(for result: ScanResult) {
            // NOOP
        }
    }

    override func tearDown() {
        viewModel.invalidateExpireSessionTimer()
    }

    func testNoScansIndexing() {
        setUpVM(scans: [], isScanningSessionExpirable: true)

        XCTAssertEqual(viewModel.sections.count, 1)
        XCTAssertEqual(viewModel.sections[0].name, testScanHistoryDataSource.tableViewHeaderTitle)

        XCTAssertEqual(viewModel.sections[0].rows, [.nothingScannedRow(nothingScannedText: testScanHistoryDataSource.nothingScannedText)])
    }

    func testWithScansIndexing() {
        let secondScan = ScanHistory(barcode: "0000000002", scanResult: .error(description: "We no longer store abstract concepts of thought"))
        let firstScan = ScanHistory(barcode: "0000000001", scanResult: .success(description: nil))
        let scans = [secondScan, firstScan]

        setUpVM(scans: scans, isScanningSessionExpirable: true)

        XCTAssertEqual(viewModel.sections.count, 1)
        XCTAssertEqual(viewModel.sections[0].name, testScanHistoryDataSource.tableViewHeaderTitle)

        XCTAssertEqual(viewModel.sections[0].rows.count, 2)
        XCTAssertEqual(viewModel.sections[0].rows[0], .historyRow(barcode: "0000000002", scanResult: .error(description: "We no longer store abstract concepts of thought")))
        XCTAssertEqual(viewModel.sections[0].rows[1], .historyRow(barcode: "0000000001", scanResult: .success(description: nil)))
    }

    func testFirstScan() {
        setUpVM(scans: [], isScanningSessionExpirable: true)

        var rowReloadedIndexPath: IndexPath?
        viewModel.reloadRowObserver = { indexPath in
            rowReloadedIndexPath = indexPath
        }

        var reloadedSectionHeader = false
        viewModel.reloadSectionHeaderObserver = { _ in
            reloadedSectionHeader = true
        }

        viewModel.didScan(barcode: "0000000001", with: .success(description: nil))
        XCTAssertEqual(rowReloadedIndexPath, IndexPath(row: 0, section: 0))
        XCTAssertTrue(reloadedSectionHeader)
    }

    func testSubsequentScan() {
        let firstScan = ScanHistory(barcode: "0000000001", scanResult: .success(description: nil))
        let secondScan = ScanHistory(barcode: "0000000002", scanResult: .error(description: "We no longer store abstract concepts of thought"))
        let scans = [firstScan, secondScan]

        setUpVM(scans: scans, isScanningSessionExpirable: true)

        var rowInsertedIndexPath: IndexPath?
        viewModel.insertRowObserver = { indexPath in
            rowInsertedIndexPath = indexPath
        }

        var reloadedSectionHeader = false
        viewModel.reloadSectionHeaderObserver = { _ in
            reloadedSectionHeader = true
        }

        viewModel.didScan(barcode: "0000000003", with: .success(description: nil))
        XCTAssertEqual(rowInsertedIndexPath, IndexPath(row: 0, section: 0))
        XCTAssertTrue(reloadedSectionHeader)
    }

    func testPendingScan() {
        setUpVM(scans: [], isScanningSessionExpirable: true)

        var rowReloadedIndexPath: IndexPath?
        viewModel.reloadRowObserver = { indexPath in
            rowReloadedIndexPath = indexPath
        }

        var reloadedSectionHeader = false
        viewModel.reloadSectionHeaderObserver = { _ in
            reloadedSectionHeader = true
        }

        viewModel.didScan(barcode: "0000000001", with: .pending)
        XCTAssertNil(rowReloadedIndexPath)
        XCTAssertFalse(reloadedSectionHeader)
    }

    func testCreateExpireSessionTimer() {
        setUpVM(scans: [], isScanningSessionExpirable: true)

        viewModel.createExpireSessionTimer()
        XCTAssertNotNil(viewModel.expireSessionTimer)
    }

    func testInvalidateExpireSessionTimer() {
        setUpVM(scans: [], isScanningSessionExpirable: true)

        viewModel.createExpireSessionTimer()
        viewModel.invalidateExpireSessionTimer()

        XCTAssertNil(viewModel.expireSessionTimer)
    }

    func testExpireScanningSession() {
        setUpVM(scans: [], isScanningSessionExpirable: true)

        viewModel.expireScanningSession()
        XCTAssertTrue(sink.scanningSessionExpired)
    }

    func testUnexpirableScanningSessionTimer() {
        setUpVM(scans: [], isScanningSessionExpirable: false)

        viewModel.createExpireSessionTimer()
        XCTAssertNil(viewModel.expireSessionTimer)
    }

    func testUnexpirableScanningSessionExpiration() {
        setUpVM(scans: [], isScanningSessionExpirable: false)

        viewModel.expireScanningSession()
        XCTAssertFalse(sink.scanningSessionExpired)
    }

    func testHapticFeedback() {
        setUpVM(scans: [], isScanningSessionExpirable: true)
        XCTAssertNil(viewModel.hapticFeedbackManager)

        viewModel.isHapticFeedbackEnabled = true
        XCTAssertNotNil(viewModel.hapticFeedbackManager)

        viewModel.isHapticFeedbackEnabled = false
        XCTAssertNil(viewModel.hapticFeedbackManager)
    }
}

// MARK: - Private Methods
private extension ScanHistoryViewModelTests {
    func setUpVM(scans: [ScanHistory], isScanningSessionExpirable: Bool) {
        sink = DelegateSink()
        viewModel = ScanHistoryViewModel(scans: scans, scanHistoryDataSource: testScanHistoryDataSource, isScanningSessionExpirable: isScanningSessionExpirable)
        viewModel.delegate = sink
    }
}
