//
//  ScanToContinueViewController.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/10/18.
//

import UIKit

class ScanToContinueViewController: UIViewController {
    var viewModel: ScanToContinueViewModel!

    private var scanToContinueErrorVC: ScanToContinueErrorViewController?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.scanWarningBinding = { [weak self] scanWarningState in
            DispatchQueue.main.async { [weak self] in
                guard let sSelf = self else { return }

                switch scanWarningState {
                case let .displayWarning(incorrectScanMessage):
                    UIView.transition(with: sSelf.view,
                                      duration: 0.25,
                                      options: .transitionCrossDissolve,
                                      animations: { [weak self] in
                                        self?.displayWarningView(withWarningMessage: incorrectScanMessage)
                                      },
                                      completion: { [weak self] _ in
                                        self?.viewModel.setRemoveScanWarningTimer()
                    })
                case .removeWarning:
                    UIView.transition(with: sSelf.view,
                                      duration: 0.75,
                                      options: .transitionCrossDissolve,
                                      animations: { [weak self] in
                                        self?.removeWarningView()
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.isHapticFeedbackEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.isHapticFeedbackEnabled = false
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)

        if parent == nil {
            viewModel.invalidateRemoveScanWarningTimer()
        }
    }
}

// MARK: - Private Methods
private extension ScanToContinueViewController {
    func displayWarningView(withWarningMessage warningMessage: String) {
        let storyboard = UIStoryboard(name: "SplitScanner", bundle: UIResources.resourceBundle)
        guard let scanToContinueErrorVC = storyboard.instantiateViewController(withIdentifier: "ScanToContinueError") as? ScanToContinueErrorViewController else { return }

        addChild(scanToContinueErrorVC)
        view.addSubview(scanToContinueErrorVC.view)
        scanToContinueErrorVC.didMove(toParent: self)
        scanToContinueErrorVC.display(warningMessage: warningMessage)

        self.scanToContinueErrorVC = scanToContinueErrorVC
    }

    func removeWarningView() {
        scanToContinueErrorVC?.willMove(toParent: nil)
        scanToContinueErrorVC?.removeFromParent()
        scanToContinueErrorVC?.view.removeFromSuperview()
        scanToContinueErrorVC = nil
    }
}
