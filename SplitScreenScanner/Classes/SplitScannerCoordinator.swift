//
//  SplitScannerCoordinator.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/28/18.
//

import UIKit
import AVFoundation

public protocol SplitScannerCoordinatorDelegate: class {
    func titleForScanner(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String?

    func didPressDoneButton(_ SplitScannerCoordinator: SplitScannerCoordinator)
}

public class SplitScannerCoordinator: RootCoordinator, Coordinator {
    var coordinators: [UUID: Coordinator] = [: ]
    var identifier: UUID = UUID()

    var viewModel: SplitScannerViewModel

    weak var rootCoordinator: RootCoordinator?
    public weak var delegate: SplitScannerCoordinatorDelegate?
    weak var navigation: UINavigationController!

    public init(navigation: UINavigationController) throws {
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            throw ContinuousBarcodeScannerError.noCamera
        }
        let deviceProvider = DeviceProvider(device: videoDevice)
        self.viewModel = SplitScannerViewModel(deviceProvider: deviceProvider)

        self.navigation = navigation
        self.rootCoordinator = self
    }

    public func start() {
        let bundle = Bundle(for: SplitScannerCoordinator.self)
        guard let resourceBundleURL = bundle.url(forResource: "SplitScreenScanner", withExtension: "bundle"),
            let resourceBundle = Bundle(url: resourceBundleURL) else { return }

        rootCoordinator?.pushCoordinator(self)

        let storyboard = UIStoryboard(name: "SplitScanner", bundle: resourceBundle)
        if let vc = storyboard.instantiateInitialViewController() as? SplitScannerViewController {
            viewModel.delegate = self
            vc.viewModel = viewModel

            navigation.present(vc, animated: true)
        }
    }
}

// MARK: - SplitScannerViewModelDelegate
extension SplitScannerCoordinator: SplitScannerViewModelDelegate {
    func titleForScanner(_ splitScreenScannerViewModel: SplitScannerViewModel) -> String? {
        return delegate?.titleForScanner(self)
    }

    func didPressDoneButton(_ splitScreenScannerViewModel: SplitScannerViewModel) {
        rootCoordinator?.popCoordinator(self)

        navigation?.dismiss(animated: true) { [weak self] in
            guard let sSelf = self else { return }

            sSelf.delegate?.didPressDoneButton(sSelf)
        }
    }
}
