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
    var splitScannerCoordinator: SplitScannerCoordinator?

    @IBAction func startScanningButtonPressed(_ sender: Any) {
        do {
            guard let navigation = navigationController else { return }
            splitScannerCoordinator = try SplitScannerCoordinator(navigation: navigation)
            splitScannerCoordinator?.delegate = self

            try splitScannerCoordinator?.start()
        } catch {
            print(error)
        }
    }
}

// MARK: - SplitScannerCoordinatorDelegate
extension StartScanningViewController: SplitScannerCoordinatorDelegate {
    func didScanBarcode(_ SplitScannerCoordinator: SplitScannerCoordinator, barcode: String) {
        print("Scanned: " + barcode)
    }
    
    func titleForScanner(_ splitScreenScannerViewModel: SplitScannerCoordinator) -> String? {
        return "Test Barcode Scanner"
    }

    func headerForScanHistoryTableView(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String? {
        return "Scanning Items to Truck"
    }

    func textForNothingScanned(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String? {
        return "Scan an Item to start loading"
    }

    func didPressDoneButton(_ splitScreenScannerViewModel: SplitScannerCoordinator) {
        // NOOP
    }
}
