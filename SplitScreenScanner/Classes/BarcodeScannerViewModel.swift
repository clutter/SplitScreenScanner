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

    enum ScannerOverlayState: Equatable {
        case displaying(message: String)
        case hidden
    }

    var scannerOverlayState: ScannerOverlayState {
        didSet {
            scannerOverlayObserver?(scannerOverlayState)
        }
    }

    init(view: UIView) throws {
        barcodeScanner = try ContinuousBarcodeScanner(previewView: view)
        scannerOverlayState = .hidden

        barcodeScanner.delegate = self
    }

    // MARK: - Bindings, Observers, Getters

    var scannerOverlayObserver: ((ScannerOverlayState) -> Void)?
}

// MARK: - Public Methods
extension BarcodeScannerViewModel {
    func startRunningBarcodeScanner() {
        guard scannerOverlayState == .hidden else { return }
        barcodeScanner.startRunning()
    }

    func stopRunningBarcodeScanner() {
        barcodeScanner.stopRunning()
    }

    func blockScanner(withMessage message: String) {
        guard case .hidden = scannerOverlayState else { return }

        barcodeScanner.stopRunning()
        scannerOverlayState = .displaying(message: message)
    }

    func unblockScanner() {
        guard case .displaying = scannerOverlayState else { return }

        barcodeScanner.startRunning()
        scannerOverlayState = .hidden
    }
}

// MARK: - ContinuousBarcodeScannerDelegate
extension BarcodeScannerViewModel: ContinuousBarcodeScannerDelegate {
    func didScan(barcode: String) {
        delegate?.didScanBarcode(self, barcode: barcode)
    }

    func resetLastScannedBarcode() {
        barcodeScanner.resetLastScannedBarcode()
    }
}
