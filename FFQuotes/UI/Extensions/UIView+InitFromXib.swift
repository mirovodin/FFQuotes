//
//  UIView+InitFromXib.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 24.04.2021.
//

import Foundation
import UIKit

protocol NibLoadable: class { }

extension NibLoadable where Self: UIView {

    static func initFromXib() -> Self {
        let dynamicMetatype = Self.self
        let bundle = Bundle(for: dynamicMetatype)
        let nib = UINib(nibName: "\(dynamicMetatype)", bundle: bundle)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }
}

extension UIView: NibLoadable { }
