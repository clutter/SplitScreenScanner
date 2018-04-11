//
//  ScanToContinueViewController.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/10/18.
//

import UIKit

class ScanToContinueViewController: UIViewController {
    var viewModel: ScanToContinueViewModel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.scanToContinueTitleBinding = { [weak self] title in
            self?.titleLabel.text = title
        }

        viewModel.scanToContinueDescriptionBinding = { [weak self] description in
            self?.descriptionLabel.text = description
        }
    }
}
