//
//  ScanHistoryCell.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/28/18.
//

import UIKit

class ScanHistoryCell: UITableViewCell, IdentifierViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func reset(barcode: String, result: ScanResult) {
        barcodeLabel.text = "#\(barcode)"

        let imageSize = iconImageView.bounds.size
        switch result {
        case .success(let description):
            iconImageView.image = ScannerStyleKit.imageOfCheckMarkSymbol(imageSize: imageSize)
            descriptionLabel.text = description
        case .warning(let description):
            iconImageView.image = ScannerStyleKit.imageOfExclamationTriangleSymbol(imageSize: imageSize, isError: false)
            descriptionLabel.text = description
        case .error(let description):
            iconImageView.image = ScannerStyleKit.imageOfExclamationTriangleSymbol(imageSize: imageSize, isError: true)
            descriptionLabel.text = description
        }
    }
}
