//
//  IdentifierViewCell.swift
//  SplitScreenScanner
//
//  Created by Sean Machen on 4/5/18.
//

import Foundation

protocol IdentifierViewCell {
    static var identifier: String { get }
}

extension IdentifierViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
