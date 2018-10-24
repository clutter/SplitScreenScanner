//
//  SplitScannerViewModelTests.swift
//  SplitScreenScanner_Tests
//
//  Created by Sean Machen on 4/4/18.
//  Copyright © 2018 Clutter Inc. All rights reserved.
//

import XCTest
@testable import SplitScreenScanner

class SplitScannerViewModelTests: XCTestCase {
    private var deviceProvider: TestDeviceProvider!
    private var sink: DelegateSink!
    private var viewModel: SplitScannerViewModel!

    private final class DelegateSink: SplitScannerViewModelDelegate {
        var doneButtonPressed = false

        func didPressDoneButton(_ splitScreenScannerViewModel: SplitScannerViewModel) {
            doneButtonPressed = true
        }
    }

    override func setUp() {
        deviceProvider = TestDeviceProvider()
        sink = DelegateSink()

        viewModel = SplitScannerViewModel(deviceProvider: deviceProvider, scannerTitle: "Unit Test Title")
        viewModel.delegate = sink
    }

    func testScannerTitle() {
        var scannerTitle: String?
        viewModel.scannerTitleBinding = { title in
            scannerTitle = title
        }

        XCTAssertEqual(scannerTitle, "Unit Test Title")
    }

    func testTorchButtonImage() {
        XCTAssertFalse(deviceProvider.isTorchOn)

        viewModel.toggleTorch()
        XCTAssertTrue(deviceProvider.isTorchOn)

        viewModel.toggleTorch()
        XCTAssertFalse(deviceProvider.isTorchOn)
    }

    func testDoneButtonPressed() {
        XCTAssertFalse(sink.doneButtonPressed)

        viewModel.doneButtonPressed()
        XCTAssertTrue(sink.doneButtonPressed)
    }
}

private final class TestDeviceProvider: DeviceProviding {
    var isTorchOn: Bool = false

    var hasTorch: Bool {
        return true
    }

    func lockForConfiguration() throws {
        // NOOP
    }

    func unlockForConfiguration() {
        // NOOP
    }
}
