//
//  SplitScannerViewController.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/27/18.
//

import UIKit

class SplitScannerViewController: UIViewController {
    @IBOutlet var scannerTitleLabel: UILabel!
    @IBOutlet var torchButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var viewModel: SplitScannerViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.presentAlertBinding = { [weak self] alertVC in
            self?.present(alertVC, animated: true)
        }

        torchButton.addTarget(self, action: #selector(torchButtonPressed), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.scannerTitleBinding = { [weak self] scannerTitle in
            self?.scannerTitleLabel.text = scannerTitle
        }
    }
}

// MARK: - Button Actions
private extension SplitScannerViewController {
    @objc func torchButtonPressed() {
        viewModel.toggleTorch()
    }

    @objc func doneButtonPressed() {
        viewModel.doneButtonPressed()
    }
}
