//
//  SplitScannerCoordinator.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/28/18.
//

import UIKit
import AVFoundation

public protocol SplitScannerCoordinatorDelegate: class {
    func didScanBarcode(_ splitScannerCoordinator: SplitScannerCoordinator, barcode: String) -> (result: ScanResult, blocking: Bool)
    func didPressDoneButton(_ splitScannerCoordinator: SplitScannerCoordinator)
}

enum SplitScannerError: Error {
    case missingBundle(name: String)
    case couldNotInstantiateInitialViewController
    case couldNotInstantiateViewController(identifier: String)
}

public class SplitScannerCoordinator: RootCoordinator, Coordinator {
    var coordinators: [UUID: Coordinator] = [: ]
    var identifier: UUID = UUID()

    var viewModel: SplitScannerViewModel
    var barcodeScannerViewModel: BarcodeScannerViewModel?
    var scanHistoryViewModel: ScanHistoryViewModel?

    var scanToContinueViewModel: ScanToContinueViewModel?

    var splitScannerParentVC: SplitScannerViewController?
    var barcodeScannerVC: BarcodeScannerViewController?
    var scanHistoryVC: ScanHistoryTableViewController?
    var scanToContinueVC: ScanToContinueViewController?

    private var currentlyDisplayedInfoVC: UIViewController?

    let scanToContinueDataSource: ScanToContinueDataSource?
    let scanHistoryDataSource: ScanHistoryDataSource

    weak var rootCoordinator: RootCoordinator?
    public weak var delegate: SplitScannerCoordinatorDelegate?

    public init(scannerTitle: String, scanHistoryDataSource: ScanHistoryDataSource, scanToContinueDataSource: ScanToContinueDataSource?) throws {
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            throw ContinuousBarcodeScannerError.noCamera
        }
        let deviceProvider = DeviceProvider(device: videoDevice)
        self.viewModel = SplitScannerViewModel(deviceProvider: deviceProvider, scannerTitle: scannerTitle)

        self.scanHistoryDataSource = scanHistoryDataSource
        self.scanToContinueDataSource = scanToContinueDataSource
        self.rootCoordinator = self
    }

    public func makeRootViewController() throws -> UIViewController {
        let bundle = Bundle(for: SplitScannerCoordinator.self)
        guard let resourceBundleURL = bundle.url(forResource: "SplitScreenScanner", withExtension: "bundle"),
            let resourceBundle = Bundle(url: resourceBundleURL) else {
                throw SplitScannerError.missingBundle(name: "SplitScreenScanner")
        }

        let storyboard = UIStoryboard(name: "SplitScanner", bundle: resourceBundle)
        guard let splitScannerParentVC = storyboard.instantiateInitialViewController() as? SplitScannerViewController else {
            throw SplitScannerError.couldNotInstantiateInitialViewController
        }
        guard let barcodeScannerVC = storyboard.instantiateViewController(withIdentifier: "BarcodeScanner") as? BarcodeScannerViewController else {
            throw SplitScannerError.couldNotInstantiateViewController(identifier: "BarcodeScanner")
        }

        rootCoordinator?.pushCoordinator(self)
        self.splitScannerParentVC = splitScannerParentVC
        self.barcodeScannerVC = barcodeScannerVC

        viewModel.delegate = self
        splitScannerParentVC.viewModel = viewModel

        barcodeScannerViewModel = try BarcodeScannerViewModel(view: barcodeScannerVC.view)
        barcodeScannerViewModel?.delegate = self
        barcodeScannerVC.viewModel = barcodeScannerViewModel

        splitScannerParentVC.loadViewIfNeeded()
        embed(childVC: barcodeScannerVC, in: splitScannerParentVC.barcodeScannerContainerView)
        displayScanToContinueView()

        return splitScannerParentVC
    }
}

// MARK: - Public Methods
extension SplitScannerCoordinator {
    public func unblockScanner() {
        barcodeScannerViewModel?.unblockScanner()
    }
}

// MARK: - Private Methods
private extension SplitScannerCoordinator {
    func displayScanHistoryView() {
        if let scanHistoryVC = scanHistoryVC {
            switchInfoView(to: scanHistoryVC)
        } else {
            let bundle = Bundle(for: SplitScannerCoordinator.self)
            guard let resourceBundleURL = bundle.url(forResource: "SplitScreenScanner", withExtension: "bundle"),
                let resourceBundle = Bundle(url: resourceBundleURL) else { return }

            let storyboard = UIStoryboard(name: "SplitScanner", bundle: resourceBundle)
            guard let scanHistoryVC = storyboard.instantiateViewController(withIdentifier: "ScanHistory") as? ScanHistoryTableViewController else { return }

            let isScanningSessionExpirable = scanToContinueDataSource != nil
            scanHistoryViewModel = ScanHistoryViewModel(scans: [], scanHistoryDataSource: scanHistoryDataSource, isScanningSessionExpirable: isScanningSessionExpirable)
            scanHistoryViewModel?.delegate = self
            scanHistoryVC.viewModel = scanHistoryViewModel
            switchInfoView(to: scanHistoryVC)
        }
    }

    func displayScanToContinueView() {
        guard let scanToContinueDataSource = scanToContinueDataSource else {
            displayScanHistoryView()
            return
        }

        if let scanToContinueVC = scanToContinueVC {
            switchInfoView(to: scanToContinueVC)
        } else {
            let bundle = Bundle(for: SplitScannerCoordinator.self)
            guard let resourceBundleURL = bundle.url(forResource: "SplitScreenScanner", withExtension: "bundle"),
                let resourceBundle = Bundle(url: resourceBundleURL) else { return }

            let storyboard = UIStoryboard(name: "SplitScanner", bundle: resourceBundle)
            guard let scanToContinueVC = storyboard.instantiateViewController(withIdentifier: "ScanToContinue") as? ScanToContinueViewController else { return }
            scanToContinueViewModel = ScanToContinueViewModel(scanToContinueDataSource: scanToContinueDataSource, isScannerExpired: viewModel.scannerState == .expired)
            scanToContinueViewModel?.delegate = self
            scanToContinueVC.viewModel = scanToContinueViewModel
            switchInfoView(to: scanToContinueVC)
        }
    }

    func switchInfoView(to viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.currentlyDisplayedInfoVC?.willMove(toParentViewController: nil)
            self?.currentlyDisplayedInfoVC?.view.removeFromSuperview()
            self?.currentlyDisplayedInfoVC?.removeFromParentViewController()

            self?.currentlyDisplayedInfoVC = viewController

            if let splitScannerParentVC = self?.splitScannerParentVC {
                self?.embed(childVC: viewController, in: splitScannerParentVC.scanHistoryContainerView)
            }
        }
    }

    func embed(childVC: UIViewController, in containerView: UIView) {
        guard let splitScannerParentVC = splitScannerParentVC else { return }

        childVC.willMove(toParentViewController: splitScannerParentVC)
        containerView.addSubview(childVC.view)
        splitScannerParentVC.addChildViewController(childVC)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParentViewController: splitScannerParentVC)
    }
}

// MARK: - SplitScannerViewModelDelegate
extension SplitScannerCoordinator: SplitScannerViewModelDelegate {
    func didPressDoneButton(_ splitScreenScannerViewModel: SplitScannerViewModel) {
        rootCoordinator?.popCoordinator(self)
        delegate?.didPressDoneButton(self)
    }
}

// MARK: - BarcodeScannerViewModelDelegate
extension SplitScannerCoordinator: BarcodeScannerViewModelDelegate {
    func didScanBarcode(_ barcodeScannerViewModel: BarcodeScannerViewModel, barcode: String) {
        if currentlyDisplayedInfoVC is ScanHistoryTableViewController {
            guard let (scanResult, blocking) = delegate?.didScanBarcode(self, barcode: barcode) else { return }
            scanHistoryViewModel?.didScan(barcode: barcode, with: scanResult)

            if blocking {
                barcodeScannerViewModel.blockScanner(withMessage: barcode)
            }
        } else {
            scanToContinueViewModel?.didScan(barcode: barcode)
        }
    }
}

// MARK: - ScanToContinueViewModelDelegate
extension SplitScannerCoordinator: ScanToContinueViewModelDelegate {
    func scanToContinueViewModel(_ scanToContinueViewModel: ScanToContinueViewModel, didScanStartingBarcode: String) {
        viewModel.scannerState = .started
        displayScanHistoryView()
    }
}

// MARK: - ScanHistoryViewModelDelegate
extension SplitScannerCoordinator: ScanHistoryViewModelDelegate {
    func expireScanningSession(_ scanHistoryViewModel: ScanHistoryViewModel) {
        viewModel.scannerState = .expired
        displayScanToContinueView()
        barcodeScannerViewModel?.resetLastScannedBarcode()
        scanToContinueDataSource?.didExpireScanningSession()
    }
}
