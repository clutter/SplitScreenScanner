//
//  SplitScannerViewController.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/27/18.
//

import UIKit

class SplitScannerViewController: UIViewController {
    @IBOutlet weak var scannerTitleLabel: UILabel!
    @IBOutlet weak var torchButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var barcodeScannerContainerView: UIView!
    @IBOutlet weak var scanHistoryContainerView: UIView!

    var viewModel: SplitScannerViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.presentAlertBinding = { [weak self] alertVC in
            self?.present(alertVC, animated: true)
        }

        torchButton.addTarget(self, action: #selector(torchButtonPressed), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.scannerTitleBinding = { [weak self] scannerTitle in
            self?.scannerTitleLabel.text = scannerTitle
        }

        viewModel.scannerDismissTitleBinding = { [weak self] dismissTitle in
            self?.dismissButton.setTitle(dismissTitle, for: .normal)
        }

        viewModel.torchButtonImageBinding = { [weak self] isTorchOn in
            let torchImage = ScannerStyleKit.imageOfTorchSymbol(isTorchOn: isTorchOn)
            self?.torchButton.setImage(torchImage, for: .normal)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// MARK: - Button Actions
private extension SplitScannerViewController {
    @objc func torchButtonPressed() {
        viewModel.toggleTorch()
    }

    @objc func dismissButtonPressed() {
        viewModel.dismissButtonPressed()
    }
}
