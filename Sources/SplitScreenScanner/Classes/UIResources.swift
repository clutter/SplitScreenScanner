//
//  UIResources.swift
//  
//
//  Created by Michael Mattson on 8/9/22.
//

import Foundation

public final class UIResources {
    public static let resourceBundle: Bundle = {
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: UIResources.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL
        ]

        let bundleName = "SplitScreenScanner_SplitScreenScanner"

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        // Return whatever bundle this code is in as a last resort.
        return Bundle(for: UIResources.self)
    }()
}
