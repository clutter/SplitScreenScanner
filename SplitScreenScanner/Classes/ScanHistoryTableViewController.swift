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

        viewModel.reloadDataBinding = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.insertRowBinding = { [weak self] indexPath in
            self?.tableView.beginUpdates()
            self?.tableView.insertRows(at: [indexPath], with: .left)
            self?.tableView.endUpdates()
        }

        let bundle = Bundle(for: SplitScannerCoordinator.self)
        if let resourceBundleURL = bundle.url(forResource: "SplitScreenScanner", withExtension: "bundle"),
            let resourceBundle = Bundle(url: resourceBundleURL) {
            let scanHistoryCellNib = UINib(nibName: ScanHistoryCell.identifier, bundle: resourceBundle)
            tableView.register(scanHistoryCellNib, forCellReuseIdentifier: ScanHistoryCell.identifier)
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
            let cell = UITableViewCell(style: .default, reuseIdentifier: "NothingScannedCell")
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.darkGray
            cell.backgroundColor = ScannerStyleKit.historyCellBackgroundGrey
            cell.selectionStyle = .none
            cell.textLabel?.text = noScanText
            return cell
        case let .historyRow(barcode, scanKind, scanNumber):
            let cell = tableView.dequeueReusableCell(withIdentifier: ScanHistoryCell.identifier, for: indexPath)
            guard let scanHistoryCell = cell as? ScanHistoryCell else { return cell }
            scanHistoryCell.reset(barcode: barcode, kind: scanKind, scanNumber: scanNumber)
            scanHistoryCell.selectionStyle = .none
            return scanHistoryCell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[0].name
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
