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

    func reset(title: String, subtitle: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

// MARK: - Static Methods
extension SubtitleHeaderView {
    static func instantiateFromNib() -> SubtitleHeaderView? {
        let subtitleHeaderViewNib = UINib(nibName: "SubtitleHeaderView", bundle: UIResources.resourceBundle)
        let views = subtitleHeaderViewNib.instantiate(withOwner: nil, options: nil)

        return views.compactMap({ $0 as? SubtitleHeaderView }).first
    }
}
