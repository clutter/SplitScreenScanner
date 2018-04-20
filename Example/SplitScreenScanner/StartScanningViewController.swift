//
//  StartScanningViewController.swift
//  SplitScreenScannerTest
//
//  Created by Sean Machen on 3/27/18.
//  Copyright © 2018 Clutter. All rights reserved.
//

import UIKit
import SplitScreenScanner

class StartScanningViewController: UIViewController {
    let startingBarcode = "SO0000000001195"

    var splitScannerCoordinator: SplitScannerCoordinator?

    @IBAction func startScanningButtonPressed(_ sender: Any) {
        do {
            guard let navigation = navigationController else { return }

            let scannerTitle = "Test Barcode Scanner"
            splitScannerCoordinator = try SplitScannerCoordinator(navigation: navigation, scannerTitle: scannerTitle, scanToContinueDisplaying: self)
            splitScannerCoordinator?.delegate = self

            try splitScannerCoordinator?.start()
        } catch {
            print(error)
        }
    }
}

// MARK: - SplitScannerCoordinatorDelegate
extension StartScanningViewController: SplitScannerCoordinatorDelegate {
    func didScanBarcode(_ SplitScannerCoordinator: SplitScannerCoordinator, barcode: String) -> ScanResult {
        print("Scanned: " + barcode)
        switch Int(arc4random_uniform(4)) {
        case 0...1:
            return .success(description: "Nice scan!")
        case 2:
            return .warning(description: "Poor scan!")
        default:
            return .error(description: "Bogus scan!")
        }
    }

    func headerForScanHistoryTableView(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String? {
        return "Scanning Items to Truck"
    }

    func textForNothingScanned(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String? {
        return "Scan an Item to start loading"
    }

    func didExpireScanningSession(_ SplitScannerCoordinator: SplitScannerCoordinator) {
        // NOOP
    }

    func didPressDoneButton(_ splitScreenScannerViewModel: SplitScannerCoordinator) {
        // NOOP
    }
}

// MARK: - ScanToContinueDisplaying
extension StartScanningViewController: ScanToContinueDisplaying {
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
}
