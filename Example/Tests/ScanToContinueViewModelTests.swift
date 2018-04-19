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
    private var sink: DelegateSink!
    private var vm: ScanToContinueViewModel!

    private let scanToContinueTitle = "Unit Test Title"
    private let scanToContinueDescription = "Unit Test Description"

    private final class DelegateSink: ScanToContinueViewModelDelegate {
        var startingBarcodeScanned = false

        func didScanStartingBarcode(_ scanToContinueViewModel: ScanToContinueViewModel) {
            startingBarcodeScanned = true
        }
    }
    
    override func setUp() {
        sink = DelegateSink()
        vm = ScanToContinueViewModel(title: scanToContinueTitle, description: scanToContinueDescription, scanStartingBarcode: { barcode in
            if barcode == "0000000001" {
                return .success(description: nil)
            } else {
                return .error(description: "Unit Test Wrong Barcode Scanned Message")
            }
        })
        vm.delegate = sink
    }

    func testScanToContinueTitleBinding() {
        var title: String?
        vm.scanToContinueTitleBinding = { scanToContinueTitle in
            title = scanToContinueTitle
        }

        XCTAssertEqual(title, scanToContinueTitle)
    }

    func testScanToContinueDescriptionBinding() {
        var description: String?
        vm.scanToContinueDescriptionBinding = { scanToContinueDescription in
            description = scanToContinueDescription
        }

        XCTAssertEqual(description, scanToContinueDescription)
    }
    
    func testDidScanCorrectStartingBarcode() {
        XCTAssertFalse(sink.startingBarcodeScanned)

        vm.didScan(barcode: "0000000001")
        XCTAssertTrue(sink.startingBarcodeScanned)
    }

    func testDidScanIncorrectStartingBarcode() {
        var scanWarningState: ScanToContinueViewModel.ScanWarningState?
        vm.scanWarningBinding = { state in
            scanWarningState = state
        }

        vm.didScan(barcode: "0000000002")

        let wrongStartingBarcodeScannedMessage = "Unit Test Wrong Barcode Scanned Message"
        XCTAssertEqual(scanWarningState, ScanToContinueViewModel.ScanWarningState.displayWarning(incorrectScanMessage: wrongStartingBarcodeScannedMessage))
    }

    func testRemoveScanWarning() {
        var scanWarningState: ScanToContinueViewModel.ScanWarningState?
        vm.scanWarningBinding = { state in
            scanWarningState = state
        }

        vm.removeScanWarning()

        XCTAssertEqual(scanWarningState, ScanToContinueViewModel.ScanWarningState.removeWarning(title: scanToContinueTitle, description: scanToContinueDescription))
    }
}
