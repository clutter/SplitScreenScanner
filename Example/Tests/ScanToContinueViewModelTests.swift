//
//  ScanToContinueViewModelTests.swift
//  SplitScreenScanner_Tests
//
//  Created by Sean Machen on 4/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import SplitScreenScanner

class ScanToContinueViewModelTests: XCTestCase {
    private let testScanToContinueDisplayer = TestScanToContinueDisplayer()

    private var sink: DelegateSink!
    private var vm: ScanToContinueViewModel!

    private final class DelegateSink: ScanToContinueViewModelDelegate {
        var startingBarcodeScanned = false

        func scanToContinueViewModel(_ scanToContinueViewModel: ScanToContinueViewModel, didScanStartingBarcode: String) {
            startingBarcodeScanned = true
        }
    }

    private struct TestScanToContinueDisplayer: ScanToContinueDisplaying {
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
    }

    func testStartingTitle() {
        setupVM(isScannerExpired: false)

        var startingTitle: String?
        vm.scanToContinueTitleBinding = { title in
            startingTitle = title
        }

        XCTAssertEqual(startingTitle, testScanToContinueDisplayer.startingTitle)
    }

    func testContinuingTitle() {
        setupVM(isScannerExpired: true)

        var continuingTitle: String?
        vm.scanToContinueTitleBinding = { title in
            continuingTitle = title
        }

        XCTAssertEqual(continuingTitle, testScanToContinueDisplayer.continuingTitle)
    }

    func testStartingDescription() {
        setupVM(isScannerExpired: false)

        var starrtingDescription: String?
        vm.scanToContinueDescriptionBinding = { description in
            starrtingDescription = description
        }

        XCTAssertEqual(starrtingDescription, testScanToContinueDisplayer.startingDescription)
    }

    func testContinuingDescription() {
        setupVM(isScannerExpired: true)

        var continuingDescription: String?
        vm.scanToContinueDescriptionBinding = { description in
            continuingDescription = description
        }

        XCTAssertEqual(continuingDescription, testScanToContinueDisplayer.continuingDescription)
    }
    
    func testDidScanCorrectStartingBarcode() {
        setupVM(isScannerExpired: false)

        XCTAssertFalse(sink.startingBarcodeScanned)

        vm.didScan(barcode: "0000000001")
        XCTAssertTrue(sink.startingBarcodeScanned)
    }

    func testDidScanIncorrectStartingBarcode() {
        setupVM(isScannerExpired: false)

        var scanWarningState: ScanToContinueViewModel.ScanWarningState?
        vm.scanWarningBinding = { state in
            scanWarningState = state
        }

        vm.didScan(barcode: "0000000002")

        let wrongStartingBarcodeScannedMessage = "Unit Test Wrong Barcode Scanned Message"
        XCTAssertEqual(scanWarningState, ScanToContinueViewModel.ScanWarningState.displayWarning(incorrectScanMessage: wrongStartingBarcodeScannedMessage))
    }

    func testRemoveScanWarning() {
        setupVM(isScannerExpired: false)

        var scanWarningState: ScanToContinueViewModel.ScanWarningState?
        vm.scanWarningBinding = { state in
            scanWarningState = state
        }

        vm.removeScanWarning()

        XCTAssertEqual(scanWarningState, ScanToContinueViewModel.ScanWarningState.removeWarning)
    }

    func testeHapticFeedback() {
        setupVM(isScannerExpired: false)
        XCTAssertNil(vm.hapticFeedbackManager)

        vm.isHapticFeedbackEnabled = true
        XCTAssertNotNil(vm.hapticFeedbackManager)

        vm.isHapticFeedbackEnabled = false
        XCTAssertNil(vm.hapticFeedbackManager)
    }
}

// MARK: - Private Methods
private extension ScanToContinueViewModelTests {
    func setupVM(isScannerExpired: Bool) {
        sink = DelegateSink()
        vm = ScanToContinueViewModel(scanToContinueDisplaying: testScanToContinueDisplayer, isScannerExpired: isScannerExpired)
        vm.delegate = sink
    }
}
