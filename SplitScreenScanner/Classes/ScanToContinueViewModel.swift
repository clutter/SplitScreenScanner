//
//  ScanToContinueViewModel.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/10/18.
//

import Foundation

protocol ScanToContinueViewModelDelegate: class {
    func didScanStartingBarcode(_ scanToContinueViewModel: ScanToContinueViewModel)
}

class ScanToContinueViewModel {
    var removeScanWarningTimer: Timer?

    let scanToContinueTitle: String
    let scanToContinueDescription: String?
    let scanStartingBarcode: ((String) -> ScanResult)

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

    init(title: String?, description: String?, scanStartingBarcode: @escaping ((String) -> ScanResult)) {
        self.scanToContinueTitle = title ?? "Scan QR code to continue"
        self.scanToContinueDescription = description
        self.scanStartingBarcode = scanStartingBarcode
    }
}

// MARK: - Public Methods
extension ScanToContinueViewModel {
    func didScan(barcode: String) {
        let scanResult = scanStartingBarcode(barcode)
        switch scanResult {
        case .success:
            delegate?.didScanStartingBarcode(self)
        case let .warning(description):
            displayScanWarning(description)
        case let .error(description):
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
