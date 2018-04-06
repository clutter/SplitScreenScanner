//
//  ScanHistoryViewModel.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/4/18.
//

import Foundation
import Sections

class ScanHistoryViewModel {
    var scans: [ScanHistory]

    init(scans: [ScanHistory], tableViewHeader: String, noScanText: String) {
        self.scans = scans
        sections = TableModel.makeSectionBuilder([], tableViewHeader: tableViewHeader, noScanText: noScanText).sections
    }

    enum TableModel {
        case nothingScannedRow(noScanText: String)
        case historyRow(barcode: String, scanKind: ScanHistory.ScanKind, scanNumber: Int)

        static func makeSectionBuilder(_ scans: [ScanHistory], tableViewHeader: String, noScanText: String) -> SectionBuilder<TableModel> {
            return SectionBuilder<TableModel>(initialValues: [])
                .addSections { _ in
                    let rows: [TableModel]
                    if scans.isEmpty {
                        rows = [.nothingScannedRow(noScanText: noScanText)]
                    } else {
                        rows = scans.map { .historyRow(barcode: $0.barcode, scanKind: $0.scanKind, scanNumber: $0.scanNumber) }
                    }

                    return [Section(name: tableViewHeader, rows: rows)]
            }
        }
    }

    // MARK: - Bindings, Observers, Getters

    var reloadDataBinding: (() -> Void)?

    var insertRowBinding: ((IndexPath) -> Void)?

    // MARK: - Table Rows

    fileprivate(set) var sections: Sections<TableModel> = []
}
