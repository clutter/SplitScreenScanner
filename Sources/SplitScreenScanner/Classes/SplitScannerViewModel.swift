//
//  SplitScannerViewModel.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/27/18.
//

import UIKit

protocol SplitScannerViewModelDelegate: AnyObject {
    func didTapDismissButton(_ splitScreenScannerViewModel: SplitScannerViewModel)
}

class SplitScannerViewModel {
    let scannerTitle: String
    let scannerDismissTitle: String?
    var deviceProvider: DeviceProviding

    weak var delegate: SplitScannerViewModelDelegate?

    enum ScannerState {
        case notStarted
        case started
        case expired
    }
    var scannerState: ScannerState

    init(deviceProvider: DeviceProviding, scannerTitle: String, scannerDismissTitle: String?) {
        self.deviceProvider = deviceProvider
        self.scannerState = .notStarted
        self.scannerTitle = scannerTitle
        self.scannerDismissTitle = scannerDismissTitle
    }

    // MARK: - Bindings, Observers, Getters

    var scannerTitleBinding: ((String?) -> Void)? {
        didSet {
            scannerTitleBinding?(scannerTitle)
        }
    }

    var scannerDismissTitleBinding: ((String?) -> Void)? {
        didSet {
            scannerDismissTitleBinding?(scannerDismissTitle)
        }
    }

    var torchButtonImageBinding: ((Bool) -> Void)? {
        didSet {
            torchButtonImageBinding?(deviceProvider.isTorchOn)
        }
    }

    var presentAlertBinding: ((UIAlertController) -> Void)?
}

// MARK: - Public Methods
extension SplitScannerViewModel {
    func tappedDismissButton() {
        guard scannerDismissTitle != nil else { return }
        delegate?.didTapDismissButton(self)
    }

    func toggleTorch() {
        guard deviceProvider.hasTorch else { return }

        do {
            try deviceProvider.lockForConfiguration()

            let toggledIsTorchOn = !deviceProvider.isTorchOn
            deviceProvider.isTorchOn = toggledIsTorchOn
            deviceProvider.unlockForConfiguration()

            torchButtonImageBinding?(deviceProvider.isTorchOn)
        } catch {
            let alertVC = UIAlertController(title: "Failed to Toggle Torch", message: "Could not lock the device for current configuration.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertVC.addAction(cancelAction)

            presentAlertBinding?(alertVC)
        }
    }
}
