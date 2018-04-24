//
//  ScanToContinueErrorViewController.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/24/18.
//

import UIKit

class ScanToContinueErrorViewController: UIViewController {
    @IBOutlet weak var incorrectScanImageView: UIImageView!
    @IBOutlet weak var incorrectScanLabel: UILabel!
}

extension ScanToContinueErrorViewController {
    func display(warningMessage: String) {
        let imageSize = incorrectScanImageView.bounds.size
        incorrectScanImageView.image = ScannerStyleKit.imageOfExclamationTriangleSymbol(imageSize: imageSize, isError: false)
        incorrectScanLabel.text = warningMessage
    }
}
