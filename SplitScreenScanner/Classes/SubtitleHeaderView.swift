//
//  SubtitleHeaderView
//  SplitScreenScanner
//
//  Created by Sean Machen on 7/31/18.
//

import UIKit

class SubtitleHeaderView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    func reset(forTitle title: String, subtitle: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

// MARK: - Static Methods
extension SubtitleHeaderView {
    static func instantiateNIB() -> SubtitleHeaderView? {
        let bundle = Bundle(for: SplitScannerCoordinator.self)
        guard let resourceBundleURL = bundle.url(forResource: "SplitScreenScanner", withExtension: "bundle"),
            let resourceBundle = Bundle(url: resourceBundleURL) else { return nil }

        let subtitleHeaderViewNib = UINib(nibName: "SubtitleHeaderView", bundle: resourceBundle)
        let views = subtitleHeaderViewNib.instantiate(withOwner: nil, options: nil)

        return views.compactMap({ $0 as? SubtitleHeaderView }).first
    }
}
