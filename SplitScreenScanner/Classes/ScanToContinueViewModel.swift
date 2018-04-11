//
//  ScanToContinueViewModel.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/10/18.
//

import Foundation

protocol ScanToContinueViewModelDelegate: class {
    func startingBarcode(_ scanToContinueViewModel: ScanToContinueViewModel) -> String
    func scanToBeginTitle(_ scanToContinueViewModel: ScanToContinueViewModel) -> String
    func scanToBeginDescription(_ scanToContinueViewModel: ScanToContinueViewModel) -> String?
}

class ScanToContinueViewModel {
    weak var delegate: ScanToContinueViewModelDelegate?

    // MARK: - Bindings, Observers, Getters

    var scanToContinueTitleBinding: ((String) -> Void)? {
        didSet {
            scanToContinueTitleBinding?(scanToContinueTitle())
        }
    }

    var scanToContinueDescriptionBinding: ((String?) -> Void)? {
        didSet {
            scanToContinueDescriptionBinding?(scanToContinueDescription())
        }
    }
}

// MARK: - Private Methods
private extension ScanToContinueViewModel {
    func scanToContinueTitle() -> String {
        return delegate?.scanToBeginTitle(self) ?? "Scan QR code to continue"
    }

    func scanToContinueDescription() -> String? {
        return delegate?.scanToBeginDescription(self)
    }
}
