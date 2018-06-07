//
//  ScanHistoryViewModel.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/4/18.
//

import Foundation
import Sections

protocol ScanHistoryViewModelDelegate: class {
    func expireScanningSession(_ scanHistoryViewModel: ScanHistoryViewModel)
}

class ScanHistoryViewModel {
    var scans: [ScanHistory]
    let isScanningSessionExpirable: Bool
    let scanHistoryDataSource: ScanHistoryDataSource

    private(set) var hapticFeedbackManager: ScannerHapticFeedbackManager?
    private(set) var expireSessionTimer: Timer?

    weak var delegate: ScanHistoryViewModelDelegate?

    init(scans: [ScanHistory], scanHistoryDataSource: ScanHistoryDataSource, isScanningSessionExpirable: Bool) {
        self.scans = scans
        self.scanHistoryDataSource = scanHistoryDataSource
        self.isScanningSessionExpirable = isScanningSessionExpirable

        createSections()
    }

    enum TableModel: Equatable {
        case nothingScannedRow(nothingScannedText: String)
        case historyRow(barcode: String, scanResult: ScanResult)

        static func makeSectionBuilder(_ scans: [ScanHistory], tableViewHeader: String, nothingScannedText: String) -> SectionBuilder<TableModel> {
            return SectionBuilder<TableModel>(initialValues: [])
                .addSections { _ in
                    let rows: [TableModel]
                    if scans.isEmpty {
                        rows = [.nothingScannedRow(nothingScannedText: nothingScannedText)]
                    } else {
                        rows = scans.map { .historyRow(barcode: $0.barcode, scanResult: $0.scanResult) }
                    }

                    return [Section(name: tableViewHeader, rows: rows)]
            }
        }
    }

    // MARK: - Bindings, Observers, Getters

    var reloadRowBinding: ((IndexPath) -> Void)?

    var insertRowBinding: ((IndexPath) -> Void)?

    var isHapticFeedbackEnabled: Bool {
        get {
            return hapticFeedbackManager != nil
        }
        set {
            if newValue {
                hapticFeedbackManager = ScannerHapticFeedbackManager()
            } else {
                hapticFeedbackManager = nil
            }
        }
    }

    // MARK: - Table Rows

    private(set) var sections: Sections<TableModel> = []
}

// MARK: - Public Methods
extension ScanHistoryViewModel {
    func didScan(barcode: String, with result: ScanResult) {
        let scan = ScanHistory(barcode: barcode, scanResult: result)
        insert(newScan: scan)
        hapticFeedbackManager?.didScan(with: result)
        resetExpireSessionTimer()
    }

    func createExpireSessionTimer() {
        guard isScanningSessionExpirable else { return }

        expireSessionTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false, block: { [weak self] _ in
            self?.expireScanningSession()
        })
    }

    func invalidateExpireSessionTimer() {
        expireSessionTimer?.invalidate()
        expireSessionTimer = nil
    }

    func resetExpireSessionTimer() {
        DispatchQueue.main.async { [weak self] in
            self?.invalidateExpireSessionTimer()
            self?.createExpireSessionTimer()
        }
    }

    func expireScanningSession() {
        guard isScanningSessionExpirable else { return }

        delegate?.expireScanningSession(self)
    }

    func createSections() {
        sections = TableModel.makeSectionBuilder(scans, tableViewHeader: scanHistoryDataSource.tableViewHeader, nothingScannedText: scanHistoryDataSource.nothingScannedText).sections
    }
}

// MARK: - Private Methods
private extension ScanHistoryViewModel {
    func insert(newScan: ScanHistory) {
        scans.insert(newScan, at: 0)

        let firstRowIndexPath = IndexPath(row: 0, section: 0)
        let historyRow: TableModel = .historyRow(barcode: newScan.barcode, scanResult: newScan.scanResult)

        // replace nothingScannedRow with historyRow if this is the first scan
        if scans.count == 1 {
            sections[firstRowIndexPath.section].rows[firstRowIndexPath.row] = historyRow
            reloadRowBinding?(firstRowIndexPath)
        } else {
            sections[firstRowIndexPath.section].rows.insert(historyRow, at: firstRowIndexPath.row)
            insertRowBinding?(firstRowIndexPath)
        }
    }
}
