//
//  SplitScannerCoordinator.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/28/18.
//

import UIKit
import AVFoundation

public protocol SplitScannerCoordinatorDelegate: class {
    func didScanBarcode(_ SplitScannerCoordinator: SplitScannerCoordinator, barcode: String)

    func titleForScanner(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String?
    func headerForScanHistoryTableView(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String?
    func textForNothingScanned(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String?

    func didPressDoneButton(_ SplitScannerCoordinator: SplitScannerCoordinator)
}

public class SplitScannerCoordinator: RootCoordinator, Coordinator {
    var coordinators: [UUID: Coordinator] = [: ]
    var identifier: UUID = UUID()

    var viewModel: SplitScannerViewModel

    var barcodeScannerVC: BarcodeScannerViewController?
    var scanHistoryVC: ScanHistoryTableViewController?

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

    public func start() throws {
        let bundle = Bundle(for: SplitScannerCoordinator.self)
        guard let resourceBundleURL = bundle.url(forResource: "SplitScreenScanner", withExtension: "bundle"),
            let resourceBundle = Bundle(url: resourceBundleURL) else { return }

        rootCoordinator?.pushCoordinator(self)

        let storyboard = UIStoryboard(name: "SplitScanner", bundle: resourceBundle)
        if let splitScannerParentVC = storyboard.instantiateInitialViewController() as? SplitScannerViewController {

            viewModel.delegate = self
            splitScannerParentVC.viewModel = viewModel

            navigation.present(splitScannerParentVC, animated: true)

            if let barcodeScannerVC = storyboard.instantiateViewController(withIdentifier: "BarcodeScanner") as? BarcodeScannerViewController,
                let scanHistoryVC = storyboard.instantiateViewController(withIdentifier: "ScanHistory") as? ScanHistoryTableViewController {
                self.barcodeScannerVC = barcodeScannerVC
                self.scanHistoryVC = scanHistoryVC

                let barcodeScannerViewModel = try BarcodeScannerViewModel(view: barcodeScannerVC.view)
                barcodeScannerViewModel.delegate = self
                barcodeScannerVC.viewModel = barcodeScannerViewModel
                embed(childVC: barcodeScannerVC, in: splitScannerParentVC.barcodeScannerContainerView, withParent: splitScannerParentVC)

                let tableViewHeader = delegate?.headerForScanHistoryTableView(self) ?? "Scan History"
                let noScanText = delegate?.textForNothingScanned(self) ?? "Nothing yet scanned"
                let scanHistoryViewModel = ScanHistoryViewModel(scans: [], tableViewHeader: tableViewHeader, noScanText: noScanText)
                scanHistoryVC.viewModel = scanHistoryViewModel
                embed(childVC: scanHistoryVC, in: splitScannerParentVC.scanHistoryContainerView, withParent: splitScannerParentVC)
            }
        }
    }
}

// MARK: - Private Methods
private extension SplitScannerCoordinator {
    func embed(childVC: UIViewController, in containerView: UIView, withParent parentVC: UIViewController) {
        childVC.willMove(toParentViewController: parentVC)
        containerView.addSubview(childVC.view)
        parentVC.addChildViewController(childVC)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParentViewController: parentVC)
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

// MARK: - BarcodeScannerViewModelDelegate
extension SplitScannerCoordinator: BarcodeScannerViewModelDelegate {
    func didScanBarcode(_ barcodeScannerViewModel: BarcodeScannerViewModel, barcode: String) {
        delegate?.didScanBarcode(self, barcode: barcode)
    }
}
