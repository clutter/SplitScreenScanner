//
//  ScanHistoryTableViewController.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/4/18.
//

import UIKit

class ScanHistoryTableViewController: UITableViewController {
    var viewModel: ScanHistoryViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.reloadRowBinding = { [weak self] indexPath in
            DispatchQueue.main.async {
                self?.tableView.reloadRows(at: [indexPath], with: .right)
            }
        }

        viewModel.insertRowBinding = { [weak self] indexPath in
            DispatchQueue.main.async {
                self?.tableView.insertRows(at: [indexPath], with: .left)
            }
        }

        let bundle = Bundle(for: SplitScannerCoordinator.self)
        if let resourceBundleURL = bundle.url(forResource: "SplitScreenScanner", withExtension: "bundle"),
            let resourceBundle = Bundle(url: resourceBundleURL) {
            let scanHistoryCellNib = UINib(nibName: ScanHistoryCell.identifier, bundle: resourceBundle)
            tableView.register(scanHistoryCellNib, forCellReuseIdentifier: ScanHistoryCell.identifier)
        }

        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero

        viewModel.createSections()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.createExpireSessionTimer()
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)

        if parent == nil {
            viewModel.invalidateExpireSessionTimer()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section].rows[indexPath.row] {
        case let .nothingScannedRow(noScanText):
            let cell = tableView.dequeueReusableCell(withIdentifier: "NothingScannedCell") ?? UITableViewCell(style: .default, reuseIdentifier: "NothingScannedCell")
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.darkGray
            cell.backgroundColor = ScannerStyleKit.historyCellBackgroundGrey
            cell.selectionStyle = .none
            cell.textLabel?.text = noScanText
            return cell
        case let .historyRow(barcode, scanResult, scanNumber):
            let cell = tableView.dequeueReusableCell(withIdentifier: ScanHistoryCell.identifier, for: indexPath)
            guard let scanHistoryCell = cell as? ScanHistoryCell else { return cell }
            scanHistoryCell.reset(barcode: barcode, result: scanResult, scanNumber: scanNumber)
            scanHistoryCell.selectionStyle = .none
            return scanHistoryCell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].name
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.tintColor = .black
            headerView.textLabel?.textColor = .lightText
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
