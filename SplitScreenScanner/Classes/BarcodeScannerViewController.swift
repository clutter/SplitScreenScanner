//
//  BarcodeScannerViewController.swift
//  Pods-SplitScreenScanner_Example
//
//  Created by Sean Machen on 3/29/18.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController {
    var viewModel: BarcodeScannerViewModel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.startRunningBarcodeScanner()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.stopRunningBarcodeScanner()
    }
}
