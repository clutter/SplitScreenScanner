//
//  BarcodeScannerViewController.swift
//  Pods-SplitScreenScanner_Example
//
//  Created by Sean Machen on 3/29/18.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController {
    var barcodeScanner: ContinuousBarcodeScanner?

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            barcodeScanner = try ContinuousBarcodeScanner(previewView: view)
            barcodeScanner?.delegate = self
        } catch {
            let alertVC = UIAlertController(title: "Error Initializing Barcode Scanner", message: error.localizedDescription, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel)
            alertVC.addAction(alertAction)
            present(alertVC, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        barcodeScanner?.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        barcodeScanner?.stopRunning()
    }
}

// MARK: - ContinuousBarcodeScannerDelegate
extension BarcodeScannerViewController: ContinuousBarcodeScannerDelegate {
    func didScan(barcode: String) {
        print(barcode)
    }
}
