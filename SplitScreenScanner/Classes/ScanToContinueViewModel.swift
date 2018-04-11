//
//  ScanToContinueViewModel.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/10/18.
//

import Foundation

protocol ScanToContinueViewModelDelegate: class {
    func startingBarcode(_ scanToContinueViewModel: ScanToContinueViewModel) -> String?
    func wrongStartingBarcodeScannedMessage(_ scanToContinueViewModel: ScanToContinueViewModel) -> String?

    func didScanStartingBarcode(_ scanToContinueViewModel: ScanToContinueViewModel)
}

class ScanToContinueViewModel {
    var removeScanWarningTimer: Timer?

    let scanToContinueTitle: String
    let scanToContinueDescription: String?

    weak var delegate: ScanToContinueViewModelDelegate?

    enum ScanWarningState: Equatable {
        case displayWarning(incorrectScanMessage: String)
        case removeWarning(title: String, description: String?)
    }

    // MARK: - Bindings, Observers, Getters

    var scanWarningBinding: ((ScanWarningState) -> Void)?

    var scanToContinueTitleBinding: ((String) -> Void)? {
        didSet {
            scanToContinueTitleBinding?(scanToContinueTitle)
        }
    }

    var scanToContinueDescriptionBinding: ((String?) -> Void)? {
        didSet {
            scanToContinueDescriptionBinding?(scanToContinueDescription)
        }
    }

    init(title: String?, description: String?) {
        scanToContinueTitle = title ?? "Scan QR code to continue"
        scanToContinueDescription = description
    }
}

// MARK: - Public Methods
extension ScanToContinueViewModel {
    func didScan(barcode: String) {
        if barcode == delegate?.startingBarcode(self) {
            delegate?.didScanStartingBarcode(self)
        } else {
            guard removeScanWarningTimer == nil else { return }

            let wrongBarcodeScannedMessage = delegate?.wrongStartingBarcodeScannedMessage(self) ?? "Wrong QR code scanned"
            scanWarningBinding?(.displayWarning(incorrectScanMessage: wrongBarcodeScannedMessage))
        }
    }

    func setRemoveScanWarningTimer() {
        removeScanWarningTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { [weak self] _ in
            self?.removeScanWarning()
        })
    }

    func invalidateRemoveScanWarningTimer() {
        removeScanWarningTimer?.invalidate()
        removeScanWarningTimer = nil
    }

    func removeScanWarning() {
        scanWarningBinding?(.removeWarning(title: scanToContinueTitle, description: scanToContinueDescription))
        invalidateRemoveScanWarningTimer()
    }
}
