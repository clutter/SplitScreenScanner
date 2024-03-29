//
//  StartScanningViewController.swift
//  SplitScreenScannerTest
//
//  Created by Sean Machen on 3/27/18.
//  Copyright © 2018 Clutter Inc. All rights reserved.
//

import AVFoundation
import UIKit
import SplitScreenScanner

class StartScanningViewController: UIViewController {
    let startingBarcode = "START"

    @IBAction func startScanningButtonPressed(_ sender: Any) {
        do {
            guard let navigation = navigationController else { return }

            let scannerTitle = "Test Barcode Scanner"
            let scannerDismissTitle = "Done"
            let splitScannerCoordinator = try SplitScannerCoordinator(scannerTitle: scannerTitle, scannerDismissTitle: scannerDismissTitle, scanHistoryDataSource: self, scanToContinueDataSource: self)
            splitScannerCoordinator.delegate = self

            let scannerViewController = try splitScannerCoordinator.makeRootViewController()
            navigation.present(scannerViewController, animated: true)
        } catch {
            print(error)
        }
    }
}

// MARK: - SplitScannerCoordinatorDelegate
extension StartScanningViewController: SplitScannerCoordinatorDelegate {
    func didScanBarcode(_ splitScannerCoordinator: SplitScannerCoordinator, barcode: String) -> ScanResult {
        print("Scanned: " + barcode)
        switch Int.random(in: 0...4) {
        case 0...1:
            return .success(description: "Nice scan!")
        case 2:
            return .warning(description: "Poor scan!")
        default:
            return .error(description: "Bogus scan!")
        }
    }

    func didTapDismissButton(_ splitScannerCoordinator: SplitScannerCoordinator) {
        splitScannerCoordinator.popCoordinators()
        dismiss(animated: true)
    }
}

// MARK: - ScanHistoryDataSource
extension StartScanningViewController: ScanHistoryDataSource {
    var tableViewHeaderTitle: String {
        return "Scanning Barcodes"
    }

    var tableViewHeaderSubtitle: String? {
        let uncompletedItemCount = Int.random(in: 0...10)
        return "\(uncompletedItemCount) / 10"
    }

    var nothingScannedText: String {
        return "Start scanning"
    }

    func playBarcodeScanSound(for result: ScanResult) {
        // NOOP
    }
}

// MARK: - ScanToContinueDataSource
extension StartScanningViewController: ScanToContinueDataSource {
    var startingTitle: String {
        return "Scan Barcode #\(startingBarcode) to Begin"
    }

    var startingDescription: String? {
        return "Please scan my barcode"
    }

    var continuingTitle: String {
        return "Continue?"
    }

    var continuingDescription: String? {
        return "Scan barcode #\(startingBarcode)"
    }

    func scan(startingBarcode: String) -> ScanResult {
        if startingBarcode == self.startingBarcode {
            return .success(description: nil)
        } else {
            return .error(description: "Wrong Barcode Scanned")
        }
    }

    func playScanToContinueSound(for result: ScanResult) {
        // NOOP
    }

    func didExpireScanningSession() {
        // NOOP
    }
}
