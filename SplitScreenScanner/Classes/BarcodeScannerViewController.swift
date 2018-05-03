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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.startRunningBarcodeScanner()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel.stopRunningBarcodeScanner()
    }
}
