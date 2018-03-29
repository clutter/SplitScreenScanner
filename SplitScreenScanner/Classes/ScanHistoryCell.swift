//
//  ScanHistoryCell.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/28/18.
//

import UIKit

class ScanHistoryCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    func reset(barcode: String, kind: ScanHistory.ScanKind, scanNumber: Int) {
        barcodeLabel.text = "#\(barcode)"

        switch kind {
        case .success(let description):
            // assign success image
            descriptionLabel.text = description
        case .warning(let description):
            // assign warning image
            descriptionLabel.text = description
        case .Error(let description):
            // assign error image
            descriptionLabel.text = description
        }

        countLabel.text = String(scanNumber)
    }
}
