//
//  ScanToContinueViewModelTests.swift
//  SplitScreenScanner_Tests
//
//  Created by Sean Machen on 4/11/18.
//  Copyright © 2018 Clutter Inc. All rights reserved.
//

import XCTest
@testable import SplitScreenScanner

class ScanToContinueViewModelTests: XCTestCase {
    private let testScanToContinueDataSource = TestScanToContinueDataSource()

    private var sink: DelegateSink!
    private var viewModel: ScanToContinueViewModel!

    private final class DelegateSink: ScanToContinueViewModelDelegate {
        var startingBarcodeScanned = false

        func scanToContinueViewModel(_ scanToContinueViewModel: ScanToContinueViewModel, didScanStartingBarcode: String) {
            startingBarcodeScanned = true
        }
    }

    private struct TestScanToContinueDataSource: ScanToContinueDataSource {
        let startingTitle: String
        let startingDescription: String?
        let continuingTitle: String
        let continuingDescription: String?

        init() {
            startingTitle = "Unit Test Starting Title"
            startingDescription = "Unit Test Starting Description"
            continuingTitle = "Unit Test Continuing Title"
            continuingDescription = "Unit Test Continuing Description"
        }

        func scan(startingBarcode: String) -> ScanResult {
            if startingBarcode == "0000000001" {
                return .success(description: nil)
            } else {
                return .error(description: "Unit Test Wrong Barcode Scanned Message")
            }
        }

        func playScanToContinueSound(for result: ScanResult) {
            // NOOP
        }

        func didExpireScanningSession() {
            // NOOP
        }
    }

    func testStartingTitle() {
        setupVM(isScannerExpired: false)

        var startingTitle: String?
        viewModel.scanToContinueTitleBinding = { title in
            startingTitle = title
        }

        XCTAssertEqual(startingTitle, testScanToContinueDataSource.startingTitle)
    }

    func testContinuingTitle() {
        setupVM(isScannerExpired: true)

        var continuingTitle: String?
        viewModel.scanToContinueTitleBinding = { title in
            continuingTitle = title
        }

        XCTAssertEqual(continuingTitle, testScanToContinueDataSource.continuingTitle)
    }

    func testStartingDescription() {
        setupVM(isScannerExpired: false)

        var starrtingDescription: String?
        viewModel.scanToContinueDescriptionBinding = { description in
            starrtingDescription = description
        }

        XCTAssertEqual(starrtingDescription, testScanToContinueDataSource.startingDescription)
    }

    func testContinuingDescription() {
        setupVM(isScannerExpired: true)

        var continuingDescription: String?
        viewModel.scanToContinueDescriptionBinding = { description in
            continuingDescription = description
        }

        XCTAssertEqual(continuingDescription, testScanToContinueDataSource.continuingDescription)
    }

    func testDidScanCorrectStartingBarcode() {
        setupVM(isScannerExpired: false)

        XCTAssertFalse(sink.startingBarcodeScanned)

        viewModel.didScan(barcode: "0000000001")
        XCTAssertTrue(sink.startingBarcodeScanned)
    }

    func testDidScanIncorrectStartingBarcode() {
        setupVM(isScannerExpired: false)

        var scanWarningState: ScanToContinueViewModel.ScanWarningState?
        viewModel.scanWarningBinding = { state in
            scanWarningState = state
        }

        viewModel.didScan(barcode: "0000000002")

        let wrongStartingBarcodeScannedMessage = "Unit Test Wrong Barcode Scanned Message"
        XCTAssertEqual(scanWarningState, ScanToContinueViewModel.ScanWarningState.displayWarning(incorrectScanMessage: wrongStartingBarcodeScannedMessage))
    }

    func testRemoveScanWarning() {
        setupVM(isScannerExpired: false)

        var scanWarningState: ScanToContinueViewModel.ScanWarningState?
        viewModel.scanWarningBinding = { state in
            scanWarningState = state
        }

        viewModel.removeScanWarning()

        XCTAssertEqual(scanWarningState, ScanToContinueViewModel.ScanWarningState.removeWarning)
    }

    func testeHapticFeedback() {
        setupVM(isScannerExpired: false)
        XCTAssertNil(viewModel.hapticFeedbackManager)

        viewModel.isHapticFeedbackEnabled = true
        XCTAssertNotNil(viewModel.hapticFeedbackManager)

        viewModel.isHapticFeedbackEnabled = false
        XCTAssertNil(viewModel.hapticFeedbackManager)
    }
}

// MARK: - Private Methods
private extension ScanToContinueViewModelTests {
    func setupVM(isScannerExpired: Bool) {
        sink = DelegateSink()
        viewModel = ScanToContinueViewModel(scanToContinueDataSource: testScanToContinueDataSource, isScannerExpired: isScannerExpired)
        viewModel.delegate = sink
    }
}
