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
        var tappedDismissButton = false
        func didTapDismissButton(_ splitScreenScannerViewModel: SplitScannerViewModel) {
            tappedDismissButton = true
        }
    }

    override func setUp() {
        deviceProvider = TestDeviceProvider()
        sink = DelegateSink()

        viewModel = SplitScannerViewModel(deviceProvider: deviceProvider, scannerTitle: "Unit Test Title", scannerDismissTitle: "Done")
        viewModel.delegate = sink
    }

    func testScannerTitle() {
        var scannerTitle: String?
        viewModel.scannerTitleBinding = { title in
            scannerTitle = title
        }

        XCTAssertEqual(scannerTitle, "Unit Test Title")
    }

    func testScannerDismissTitle() {
        var scannerDismissTitle: String?
        viewModel.scannerDismissTitleBinding = { title in
            scannerDismissTitle = title
        }

        XCTAssertEqual(scannerDismissTitle, "Done")
    }

    func testTorchButtonImage() {
        XCTAssertFalse(deviceProvider.isTorchOn)

        viewModel.toggleTorch()
        XCTAssertTrue(deviceProvider.isTorchOn)

        viewModel.toggleTorch()
        XCTAssertFalse(deviceProvider.isTorchOn)
    }

    func testTappedDismissButtonWhenDismissTitleNotNil() {
        XCTAssertFalse(sink.tappedDismissButton)
        viewModel.tappedDismissButton()
        XCTAssertTrue(sink.tappedDismissButton)
    }

    func testTappedDismissButtonWhenDismissTitleNil() {
        viewModel = SplitScannerViewModel(deviceProvider: deviceProvider, scannerTitle: "Unit Test Title", scannerDismissTitle: nil)
        viewModel.delegate = sink

        XCTAssertFalse(sink.tappedDismissButton)
        viewModel.tappedDismissButton()
        XCTAssertFalse(sink.tappedDismissButton)
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
