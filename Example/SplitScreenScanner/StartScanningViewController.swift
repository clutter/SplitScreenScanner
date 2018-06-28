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
    let startingBarcode = "SO0000000001195"

    @IBAction func startScanningButtonPressed(_ sender: Any) {
        do {
            guard let navigation = navigationController else { return }

            let scannerTitle = "Test Barcode Scanner"
            let splitScannerCoordinator = try SplitScannerCoordinator(scannerTitle: scannerTitle, scanHistoryDataSource: self, scanToContinueDataSource: self)
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
    func didScanBarcode(_ splitScannerCoordinator: SplitScannerCoordinator, barcode: String) -> (result: ScanResult, blocking: Bool) {
        print("Scanned: " + barcode)
        switch Int(arc4random_uniform(4)) {
        case 0...1:
            return (result: .success(description: "Nice scan!"), blocking: false)
        case 2:
            return (result: .warning(description: "Poor scan!"), blocking: false)
        default:
            return (result: .error(description: "Bogus scan!"), blocking: false)
        }
    }

    func didPressDoneButton(_ splitScannerCoordinator: SplitScannerCoordinator) {
        dismiss(animated: true)
    }
}

// MARK: - ScanHistoryDataSource
extension StartScanningViewController: ScanHistoryDataSource {
    var tableViewHeader: String {
        return "Scanning Items to Truck"
    }

    var nothingScannedText: String {
        return "Scan an item to start loading"
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
