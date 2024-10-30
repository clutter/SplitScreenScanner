//
//  ScanHistoryViewModel.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/4/18.
//

import Foundation
import Sections

protocol ScanHistoryViewModelDelegate: AnyObject {
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

    enum RowUpdate {
        case insertRow(IndexPath)
        case reloadRow(IndexPath)
    }

    var rowUpdateObserver: ((RowUpdate) -> Void)?

    var reloadSectionHeaderObserver: ((_ sectionIndex: Int) -> Void)?

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
    func didScan(barcode: String, with result: ScanResult, hapticFeedbackEnabled: Bool = true, soundEnabled: Bool = true) {
        resetExpireSessionTimer()

        if hapticFeedbackEnabled {
            hapticFeedbackManager?.didScan(with: result)
        }

        if soundEnabled {
            scanHistoryDataSource.playBarcodeScanSound(for: result)
        }

        switch result {
        case .success, .error, .warning:
            let scan = ScanHistory(barcode: barcode, scanResult: result)
            insert(newScan: scan)
            reloadSectionHeaderObserver?(0)
        case .pending:
            break
        }
    }

    func cancelScannedBarcode(_ barcode: String) {
        cancelScan(with: barcode)
    }

    func createExpireSessionTimer() {
        guard isScanningSessionExpirable else { return }

        expireSessionTimer = Timer.scheduledTimer(withTimeInterval: scanHistoryDataSource.scanningSessionDurationInSeconds, repeats: false, block: { [weak self] _ in
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
        sections = TableModel.makeSectionBuilder(scans, tableViewHeader: scanHistoryDataSource.tableViewHeaderTitle, nothingScannedText: scanHistoryDataSource.nothingScannedText).sections
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
            rowUpdateObserver?(.reloadRow(firstRowIndexPath))
        } else {
            sections[firstRowIndexPath.section].rows.insert(historyRow, at: firstRowIndexPath.row)
            rowUpdateObserver?(.insertRow(firstRowIndexPath))
        }
    }

    func cancelScan(with barcode: String) {
        let firstIndex = scans.firstIndex { scan in
            if case .success = scan.scanResult, scan.barcode == barcode {
                return true
            }
            return false
        }

        guard let index = firstIndex else { return }

        let scan = scans[index]
        let newScan = ScanHistory(barcode: scan.barcode, scanResult: .warning(description: "Scan Canceled"))
        scans[index] = newScan

        let indexPath = IndexPath(row: index, section: 0)
        sections[indexPath.section].rows[indexPath.row] = .historyRow(barcode: newScan.barcode, scanResult: newScan.scanResult)
        rowUpdateObserver?(.reloadRow(indexPath))
    }
}
