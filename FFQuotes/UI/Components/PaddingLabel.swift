//
//  PaddingLabel.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import UIKit

class PaddingLabel: UILabel {

    var padding: UIEdgeInsets

    required init(padding: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)) {
        self.padding = padding
        super.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        padding = UIEdgeInsets.zero
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        padding = UIEdgeInsets.zero
        super.init(coder: aDecoder)
    }

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (padding.left + padding.right)
        }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let height = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: height)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let height = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: height)
    }
}
