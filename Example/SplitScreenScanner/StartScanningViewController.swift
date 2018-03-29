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

            splitScannerCoordinator?.start()
        } catch {
            print(error)
        }
    }
}

extension StartScanningViewController: SplitScannerCoordinatorDelegate {
    func titleForScanner(_ splitScreenScannerViewModel: SplitScannerCoordinator) -> String? {
        return "Test Barcode Scanner"
    }

    func didPressDoneButton(_ splitScreenScannerViewModel: SplitScannerCoordinator) {
        // NOOP
    }
}
