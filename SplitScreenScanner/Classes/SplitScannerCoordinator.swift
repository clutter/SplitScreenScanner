//
//  SplitScannerCoordinator.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 3/28/18.
//

import UIKit
import AVFoundation

public protocol SplitScannerCoordinatorDelegate: class {
    func didScanBarcode(_ SplitScannerCoordinator: SplitScannerCoordinator, barcode: String) -> ScanResult

    func titleForScanner(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String?
    func startingBarcode(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String
    func scanToBeginTitle(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String
    func scanToBeginDescription(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String?
    func wrongStartingBarcodeScannedMessage(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String

    func headerForScanHistoryTableView(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String?
    func textForNothingScanned(_ SplitScannerCoordinator: SplitScannerCoordinator) -> String?

    func didPressDoneButton(_ SplitScannerCoordinator: SplitScannerCoordinator)
}

public class SplitScannerCoordinator: RootCoordinator, Coordinator {
    var coordinators: [UUID: Coordinator] = [: ]
    var identifier: UUID = UUID()

    var viewModel: SplitScannerViewModel
    var scanHistoryViewModel: ScanHistoryViewModel?
    var scanToContinueViewModel: ScanToContinueViewModel?

    var splitScannerParentVC: SplitScannerViewController?
    var barcodeScannerVC: BarcodeScannerViewController?
    var scanHistoryVC: ScanHistoryTableViewController?
    var scanToContinueVC: ScanToContinueViewController?

    private var currentlyDisplayedInfoVC: UIViewController?

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

            self.splitScannerParentVC = splitScannerParentVC
            viewModel.delegate = self
            splitScannerParentVC.viewModel = viewModel

            navigation.present(splitScannerParentVC, animated: true)

            if let barcodeScannerVC = storyboard.instantiateViewController(withIdentifier: "BarcodeScanner") as? BarcodeScannerViewController {
                self.barcodeScannerVC = barcodeScannerVC

                let barcodeScannerViewModel = try BarcodeScannerViewModel(view: barcodeScannerVC.view)
                barcodeScannerViewModel.delegate = self
                barcodeScannerVC.viewModel = barcodeScannerViewModel
                embed(childVC: barcodeScannerVC, in: splitScannerParentVC.barcodeScannerContainerView)

                displayScanToContinueView()
            }
        }
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

            let tableViewHeader = delegate?.headerForScanHistoryTableView(self) ?? "Scan History"
            let noScanText = delegate?.textForNothingScanned(self) ?? "Nothing yet scanned"
            scanHistoryViewModel = ScanHistoryViewModel(scans: [], tableViewHeader: tableViewHeader, noScanText: noScanText)
            scanHistoryVC.viewModel = scanHistoryViewModel
            switchInfoView(to: scanHistoryVC)
        }
    }

    func displayScanToContinueView() {
        if let scanToContinueVC = scanToContinueVC {
            switchInfoView(to: scanToContinueVC)
        } else {
            let bundle = Bundle(for: SplitScannerCoordinator.self)
            guard let resourceBundleURL = bundle.url(forResource: "SplitScreenScanner", withExtension: "bundle"),
                let resourceBundle = Bundle(url: resourceBundleURL) else { return }

            let storyboard = UIStoryboard(name: "SplitScanner", bundle: resourceBundle)
            guard let scanToContinueVC = storyboard.instantiateViewController(withIdentifier: "ScanToContinue") as? ScanToContinueViewController else { return }

            let scanToContinueTitle = delegate?.scanToBeginTitle(self)
            let scanToContinueDescription = delegate?.scanToBeginDescription(self)
            scanToContinueViewModel = ScanToContinueViewModel(title: scanToContinueTitle, description: scanToContinueDescription)
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
        if currentlyDisplayedInfoVC is ScanHistoryTableViewController {
            guard let scanResult = delegate?.didScanBarcode(self, barcode: barcode) else { return }
            scanHistoryViewModel?.didScan(barcode: barcode, with: scanResult)
        } else {
            scanToContinueViewModel?.didScan(barcode: barcode)
        }
    }
}

// MARK: - ScanToContinueViewModelDelegate
extension SplitScannerCoordinator: ScanToContinueViewModelDelegate {
    func startingBarcode(_ scanToContinueViewModel: ScanToContinueViewModel) -> String? {
        return delegate?.startingBarcode(self)
    }

    func wrongStartingBarcodeScannedMessage(_ scanToContinueViewModel: ScanToContinueViewModel) -> String? {
        return delegate?.wrongStartingBarcodeScannedMessage(self)
    }

    func didScanStartingBarcode(_ scanToContinueViewModel: ScanToContinueViewModel) {
        displayScanHistoryView()
    }
}
