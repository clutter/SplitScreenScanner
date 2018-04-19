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
    private(set) var expireSessionTimer: Timer?
    private var scanNumberGenerator: ScanNumberGenerator

    weak var delegate: ScanHistoryViewModelDelegate?

    init(scans: [ScanHistory], tableViewHeader: String, noScanText: String, isScanningSessionExpirable: Bool) {
        let sortedScans = scans.sorted(by: { leftScan, rightScan in
            return leftScan.scanNumber > rightScan.scanNumber
        })
        let lastScanIndex = sortedScans.first?.scanNumber ?? 0
        scanNumberGenerator = ScanNumberGenerator(startIndex: lastScanIndex)

        self.scans = sortedScans
        sections = TableModel.makeSectionBuilder(sortedScans, tableViewHeader: tableViewHeader, noScanText: noScanText).sections

        self.isScanningSessionExpirable = isScanningSessionExpirable
    }

    enum TableModel: Equatable {
        case nothingScannedRow(noScanText: String)
        case historyRow(barcode: String, scanResult: ScanResult, scanNumber: Int)

        static func makeSectionBuilder(_ scans: [ScanHistory], tableViewHeader: String, noScanText: String) -> SectionBuilder<TableModel> {
            return SectionBuilder<TableModel>(initialValues: [])
                .addSections { _ in
                    let rows: [TableModel]
                    if scans.isEmpty {
                        rows = [.nothingScannedRow(noScanText: noScanText)]
                    } else {
                        rows = scans.map { .historyRow(barcode: $0.barcode, scanResult: $0.scanResult, scanNumber: $0.scanNumber) }
                    }

                    return [Section(name: tableViewHeader, rows: rows)]
            }
        }
    }

    // MARK: - Bindings, Observers, Getters

    var reloadRowBinding: ((IndexPath) -> Void)?

    var insertRowBinding: ((IndexPath) -> Void)?

    // MARK: - Table Rows

    private(set) var sections: Sections<TableModel> = []
}

// MARK: - Public Methods
extension ScanHistoryViewModel {
    func didScan(barcode: String, with result: ScanResult) {
        let scanNumber = scanNumberGenerator.generate()
        let scan = ScanHistory(barcode: barcode, scanResult: result, scanNumber: scanNumber)
        insert(newScan: scan)
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
}

// MARK: - Private Methods
private extension ScanHistoryViewModel {
    func insert(newScan: ScanHistory) {
        scans.insert(newScan, at: 0)

        let firstRowIndexPath = IndexPath(row: 0, section: 0)
        let historyRow: TableModel = .historyRow(barcode: newScan.barcode, scanResult: newScan.scanResult, scanNumber: newScan.scanNumber)

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
