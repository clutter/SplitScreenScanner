//
//  ScannerHapticFeedbackManager.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 6/7/18.
//

import UIKit

class ScannerHapticFeedbackManager {
    // Only supported on iPhone 7 or greater
    private let feedbackGenerator = UINotificationFeedbackGenerator()

    init() {
        feedbackGenerator.prepare()
    }
}

// MARK: - Public Methods
extension ScannerHapticFeedbackManager {
    func didScan(with result: ScanResult) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success, .pending:
                self?.feedbackGenerator.notificationOccurred(.success)
            case .warning:
                self?.feedbackGenerator.notificationOccurred(.warning)
            case .error:
                self?.feedbackGenerator.notificationOccurred(.error)
            }

            self?.feedbackGenerator.prepare()
        }
    }
}
