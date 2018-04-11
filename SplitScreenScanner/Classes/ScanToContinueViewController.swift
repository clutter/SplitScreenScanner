//
//  ScanToContinueViewController.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/10/18.
//

import UIKit

class ScanToContinueViewController: UIViewController {
    var viewModel: ScanToContinueViewModel!

    @IBOutlet weak var incorrectScanImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.scanWarningBinding = { [weak self] scanWarningState in
            DispatchQueue.main.async { [weak self] in
                guard let sSelf = self else { return }

                switch scanWarningState {
                case let .displayWarning(incorrectScanMessage):
                    let imageSize = sSelf.incorrectScanImageView.bounds.size
                    UIView.transition(with: sSelf.view,
                                      duration: 0.25,
                                      options: .transitionCrossDissolve,
                                      animations: { [weak self] in
                                        self?.incorrectScanImageView.image = ScannerStyleKit.imageOfExclamationTriangleSymbol(imageSize: imageSize, isError: false)
                                        self?.titleLabel.text = incorrectScanMessage
                                        self?.descriptionLabel.text = nil
                                      },
                                      completion: { [weak self] _ in
                                        self?.viewModel.setRemoveScanWarningTimer()
                    })
                case let .removeWarning(title, description):
                    UIView.transition(with: sSelf.view,
                                      duration: 0.75,
                                      options: .transitionCrossDissolve,
                                      animations: { [weak self] in
                                        self?.incorrectScanImageView.image = nil
                                        self?.titleLabel.text = title
                                        self?.descriptionLabel.text = description
                                      },
                                      completion: nil)
                }
            }
        }

        viewModel.scanToContinueTitleBinding = { [weak self] title in
            self?.titleLabel.text = title
        }

        viewModel.scanToContinueDescriptionBinding = { [weak self] description in
            self?.descriptionLabel.text = description
        }
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)

        if parent == nil {
            viewModel.invalidateRemoveScanWarningTimer()
        }
    }
}
