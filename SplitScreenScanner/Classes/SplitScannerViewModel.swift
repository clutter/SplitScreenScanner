//
//  SplitScannerViewModel.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/27/18.
//

import AVFoundation

protocol SplitScannerViewModelDelegate: class {
    func titleForScanner(_ splitScreenScannerViewModel: SplitScannerViewModel) -> String?

    func didPressDoneButton(_ splitScreenScannerViewModel: SplitScannerViewModel)
}

enum SplitScannerError: Error {
    case noCamera
}

class SplitScannerViewModel {
    private let device: AVCaptureDevice

    weak var delegate: SplitScannerViewModelDelegate?

    init() throws {
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            throw SplitScannerError.noCamera
        }
        self.device = videoDevice
    }

    // MARK: - Bindings, Observers, Getters

    var scannerTitleBinding: ((String?) -> Void)? {
        didSet {
            scannerTitleBinding?(scannerTitle())
        }
    }

    var presentAlertBinding: ((UIAlertController) -> Void)?
}

// MARK: - Public Methods
extension SplitScannerViewModel {
    func doneButtonPressed() {
        delegate?.didPressDoneButton(self)
    }

    func toggleTorch() {
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            let isTorchOn = device.torchMode == .on
            device.torchMode = !isTorchOn ? .on : .off
            device.unlockForConfiguration()
        } catch {
            let alertVC = UIAlertController(title: "Failed to Toggle Torch", message: "Could not lock the device for current configuration.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertVC.addAction(cancelAction)

            presentAlertBinding?(alertVC)
        }
    }
}

// MARK: - Private Methods
private extension SplitScannerViewModel {
    func scannerTitle() -> String? {
        return delegate?.titleForScanner(self)
    }
}
