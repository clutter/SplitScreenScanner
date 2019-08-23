//
//  BarcodeScannerViewController.swift
//  Pods-SplitScreenScanner_Example
//
//  Created by Sean Machen on 3/29/18.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController {
    @IBOutlet weak var blockingView: UIView!
    @IBOutlet weak var scannerOverlayView: UIView!
    @IBOutlet weak var scannerOverlayLabel: UILabel!

    var viewModel: BarcodeScannerViewModel! {
        didSet {
            guard let viewModel = viewModel else { return }

            viewModel.scannerOverlayObserver = { [weak self] scannerOverlayState in
                DispatchQueue.main.async { [weak self] in
                    guard let sSelf = self else { return }

                    switch scannerOverlayState {
                    case .displaying(let message):
                        UIView.transition(with: sSelf.view,
                                          duration: 0.25,
                                          options: .transitionCrossDissolve,
                                          animations: {
                                            sSelf.blockingView.backgroundColor = ScannerStyleKit.clutterMidGrey
                                            sSelf.scannerOverlayView.alpha = 0.95
                                            sSelf.scannerOverlayLabel.text = message
                        })
                    case .hidden:
                        UIView.transition(with: sSelf.view,
                                          duration: 0.75,
                                          options: .transitionCrossDissolve,
                                          animations: {
                                            sSelf.blockingView.backgroundColor = .clear
                                            sSelf.scannerOverlayView.alpha = 0
                        })
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        blockingView.backgroundColor = .clear
        scannerOverlayView.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.startRunningBarcodeScanner()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel.stopRunningBarcodeScanner()
    }
}
