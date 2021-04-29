//
//  QuotesModuleViewQuoteCell.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import UIKit
import Nuke

final class QuotesModuleViewQuoteCell: UITableViewCell {

    static let nibName = QuotesModuleViewQuoteCell.toIdentifier()
    static let identifier = nibName

    private enum Constants {
        static let tickerWithIconLeadingPadding = CGFloat(40)
        static let tickerLeadingPadding = CGFloat(16)
    }
    
    @IBOutlet private var tickerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var tickerImageView: UIImageView!
    @IBOutlet private var symbolLabel: UILabel!
    @IBOutlet private var percentChangeLabel: PaddingLabel!
    @IBOutlet private var headDescriptionLabel: UILabel!
    @IBOutlet private var tailDescriptionLabel: UILabel!
    @IBOutlet private var lineViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var lineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = palette.getColor(.background)

        lineView.backgroundColor = palette.getColor(.disabled).withAlphaComponent(0.2)
        lineViewHeightConstraint.constant = 1.0 / UIScreen.main.scale

        percentChangeLabel.padding = .init(top: 0, left: 4, bottom: 0, right: 4)
        percentChangeLabel.layer.masksToBounds = true
        percentChangeLabel.layer.cornerRadius = 4
        percentChangeLabel.font = palette.getFont(.size20)

        symbolLabel.font = palette.getMediumFont(.size18)
        symbolLabel.textColor = palette.getColor(.foreground)

        headDescriptionLabel.font = palette.getFont(.size10)
        headDescriptionLabel.textColor = palette.getColor(.disabled)

        tailDescriptionLabel.font = palette.getFont(.size13)
        tailDescriptionLabel.textColor = palette.getColor(.foreground)

        selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        headDescriptionLabel.text = nil
        tailDescriptionLabel.text = nil
        percentChangeLabel.text = nil
//        percentChangeLabel.layer.backgroundColor = palette.getColor(.background).cgColor
//        percentChangeLabel.layer.removeAllAnimations()
        tickerImageView.isHidden = true
        tickerLeadingConstraint.constant = Constants.tickerLeadingPadding
    }
    
    func configure(model: QuoteCellViewModel) {
        symbolLabel.text = model.ticker
        headDescriptionLabel.text = model.headDescription
        tailDescriptionLabel.text = model.tailDescription
        configurePercentChangeLabel(model: model)
        configureTickerImage(tickerIconUrl: model.tickerIconUrl)
    }
    
    // MARK: - Private methods
    private func configureTickerImage(tickerIconUrl: String) {
        guard let url = URL(string: tickerIconUrl) else { return }
        Nuke.loadImage(with: url, into: tickerImageView) { [weak self] (result: Result<ImageResponse, ImagePipeline.Error>) in
            if case let .success(response) = result {
                if response.image.size.height > 1.0 && response.image.size.width > 1.0 {
                    self?.tickerImageView?.isHidden = false
                    self?.tickerLeadingConstraint.constant = Constants.tickerWithIconLeadingPadding
                }
            }
        }
    }

    private func setPercentBadgeEnable(direction: Direction) {
        let color: UIColor
        switch direction {
            case .down:
                color = palette.getColor(.accent1)
            case .up:
                color = palette.getColor(.accent2)
            case .none:
            color = palette.getColor(.foreground)
        }
        percentChangeLabel.layer.backgroundColor = color.cgColor
    }

    private func setPercentBadgeDisable() {
        percentChangeLabel.layer.backgroundColor = palette.getColor(.background).cgColor
        percentChangeLabel.layer.removeAllAnimations()
    }

    private func updatePercentChangeColor(sign: Sign) {
        switch sign {
            case .undefined, .zero:
                percentChangeLabel.textColor = palette.getColor(.foreground)
            case .negative:
                percentChangeLabel.textColor = palette.getColor(.accent1)
            case .positive:
                percentChangeLabel.textColor = palette.getColor(.accent2)
        }
    }

    private func configurePercentChangeLabel(model: QuoteCellViewModel) {
        percentChangeLabel.text = model.percentChangeValue
        updatePercentChangeColor(sign: model.percentSign)
        if model.direction != .none && model.isUpdated {
            percentChangeLabel.textColor = palette.getColor(.background)
            UIView.animate(withDuration: 0.3) {
                self.setPercentBadgeEnable(direction: model.direction)
            } completion: { (f: Bool) in
                self.setPercentBadgeDisable()
                self.updatePercentChangeColor(sign: model.percentSign)
            }
        }
    }
}
