//
//  QuotesModuleViewHeaderView.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import UIKit

final class QuotesModuleViewHeaderView: UITableViewHeaderFooterView {

    static let nibName = QuotesModuleViewHeaderView.toIdentifier()
    static let identifier = nibName
    static let height = CGFloat(8)
    
    @IBOutlet var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = palette.getColor(.background)
    }
}
