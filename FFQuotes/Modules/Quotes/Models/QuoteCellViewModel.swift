//
//  QuoteCellViewModel.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

struct QuoteCellViewModel {
    let ticker: String
    let tickerIconUrl: String
    let headDescription: String?
    let tailDescription: String?
    let percentChangeValue: String?
    let percentSign: Sign
    let direction: Direction
    let isUpdated: Bool
}

extension QuoteCellViewModel {

    init(model: QuoteViewModel, isUpdated: Bool) {
        ticker = model.ticker
        tickerIconUrl = model.tickerIconUrl
        headDescription = "\(model.lastMarket ?? "") | \(model.name ?? "")"
        tailDescription = "\(model.lastPrice ?? "") ( \(model.pointChange ?? "") )"
        percentChangeValue = model.percentChange
        percentSign = model.percentSign
        direction = model.direction
        self.isUpdated = isUpdated
    }
}
