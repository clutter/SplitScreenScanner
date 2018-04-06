//
//  BarcodeScannerViewModel.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/6/18.
//

import Foundation

protocol BarcodeScannerViewModelDelegate: class {
    func didScanBarcode(_ barcodeScannerViewModel: BarcodeScannerViewModel, barcode: String)
}

class BarcodeScannerViewModel {
    var barcodeScanner: ContinuousBarcodeScanner

    weak var delegate: BarcodeScannerViewModelDelegate?

    init(view: UIView) throws {
        barcodeScanner = try ContinuousBarcodeScanner(previewView: view)
        barcodeScanner.delegate = self
    }
}

// MARK: - Public Methods
extension BarcodeScannerViewModel {
    func startRunningBarcodeScanner() {
        barcodeScanner.startRunning()
    }

    func stopRunningBarcodeScanner() {
        barcodeScanner.stopRunning()
    }
}

// MARK: - ContinuousBarcodeScannerDelegate
extension BarcodeScannerViewModel: ContinuousBarcodeScannerDelegate {
    func didScan(barcode: String) {
        delegate?.didScanBarcode(self, barcode: barcode)
    }
}
