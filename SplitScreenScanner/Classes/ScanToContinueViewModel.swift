//
//  ScanToContinueViewModel.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/10/18.
//

import Foundation

protocol ScanToContinueViewModelDelegate: class {
    func scanToContinueViewModel(_ scanToContinueViewModel: ScanToContinueViewModel, didScanStartingBarcode: String)
}

class ScanToContinueViewModel {
    var removeScanWarningTimer: Timer?

    let scanToContinueDisplaying: ScanToContinueDisplaying
    let isScannerExpired: Bool

    weak var delegate: ScanToContinueViewModelDelegate?

    var scanToContinueTitle: String {
        return isScannerExpired ? scanToContinueDisplaying.continuingTitle : scanToContinueDisplaying.startingTitle
    }

    var scanToContinueDescription: String? {
        return isScannerExpired ? scanToContinueDisplaying.continuingDescription : scanToContinueDisplaying.startingDescription
    }

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

    init(scanToContinueDisplaying: ScanToContinueDisplaying, isScannerExpired: Bool) {
        self.scanToContinueDisplaying = scanToContinueDisplaying
        self.isScannerExpired = isScannerExpired
    }
}

// MARK: - Public Methods
extension ScanToContinueViewModel {
    func didScan(barcode: String) {
        let scanResult = scanToContinueDisplaying.scan(startingBarcode: barcode)
        switch scanResult {
        case .success:
            delegate?.scanToContinueViewModel(self, didScanStartingBarcode: barcode)
        case let .warning(description), let .error(description):
            displayScanWarning(description)
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

// MARK: - Private Methods
private extension ScanToContinueViewModel {
    func displayScanWarning(_ description: String) {
        guard removeScanWarningTimer == nil else { return }

        let scanWarning: ScanWarningState = .displayWarning(incorrectScanMessage: description)
        scanWarningBinding?(scanWarning)
    }
}
