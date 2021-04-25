//
//  InformationView.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import UIKit

final class InformationView: UIView {
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.text = nil
        imageView.image = nil
        messageLabel.font = palette.getFont(.size13)
        messageLabel.textColor = palette.getColor(.foreground)
    }
    
    func configure(title: String, image: UIImage?) {
        messageLabel.text = title
        imageView.image = image
    }
}
