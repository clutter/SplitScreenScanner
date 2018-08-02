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

        viewModel.reloadRowObserver = { [weak self] indexPath in
            DispatchQueue.main.async {
                self?.tableView.reloadRows(at: [indexPath], with: .right)
            }
        }

        viewModel.insertRowObserver = { [weak self] indexPath in
            DispatchQueue.main.async {
                self?.tableView.insertRows(at: [indexPath], with: .left)
            }
        }

        viewModel.reloadSectionHeaderObserver = { [weak self] sectionIndex in
            DispatchQueue.main.async {
                guard let sSelf = self else { return }
                guard let sectionHeaderView = sSelf.tableView.headerView(forSection: sectionIndex)?.contentView.subviews.compactMap({ $0 as? SubtitleHeaderView }).first else { return }

                let headerTitle = sSelf.viewModel.sections[sectionIndex].name.uppercased()
                sectionHeaderView.reset(title: headerTitle, subtitle: sSelf.viewModel.scanHistoryDataSource.tableViewHeaderSubtitle)
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
        NotificationCenter.default.addObserver(self, selector: #selector(expire), name: .UIApplicationDidEnterBackground, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.isHapticFeedbackEnabled = true
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)

        if parent == nil {
            viewModel.invalidateExpireSessionTimer()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.isHapticFeedbackEnabled = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self)
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
            cell.textLabel?.textColor = ScannerStyleKit.clutterLightGrey
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            cell.textLabel?.text = noScanText
            return cell
        case let .historyRow(barcode, scanResult):
            let cell = tableView.dequeueReusableCell(withIdentifier: ScanHistoryCell.identifier, for: indexPath)
            guard let scanHistoryCell = cell as? ScanHistoryCell else { return cell }
            scanHistoryCell.reset(barcode: barcode, result: scanResult)
            scanHistoryCell.selectionStyle = .none
            return scanHistoryCell
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = SubtitleHeaderView.instantiateFromNib() else { return nil }

        let headerTitle = viewModel.sections[section].name.uppercased()
        headerView.reset(title: headerTitle, subtitle: viewModel.scanHistoryDataSource.tableViewHeaderSubtitle)

        let header = UITableViewHeaderFooterView(frame: headerView.frame)
        header.contentView.addSubview(headerView)
        return header
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.tintColor = ScannerStyleKit.clutterMoon
            headerView.textLabel?.textColor = ScannerStyleKit.clutterMidGrey
            headerView.textLabel?.font = UIFont.systemFont(ofSize: 13.0)

            if let textLabelBounds = headerView.textLabel?.bounds {
                let insets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 4.0, right: 16.0)
                let insetsRect = UIEdgeInsetsInsetRect(textLabelBounds, insets)
                headerView.bounds = insetsRect
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

private extension ScanHistoryTableViewController {
    @objc func expire() {
        viewModel.invalidateExpireSessionTimer()
        viewModel.expireScanningSession()
    }
}
