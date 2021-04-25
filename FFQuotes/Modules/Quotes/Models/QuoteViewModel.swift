//
//  QuoteViewModel.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import Foundation

struct QuoteViewModel {
    let ticker: String
    let tickerIconUrl: String
    let lastMarket: String?
    let name: String?
    let percentChange: String?
    let lastPrice: String?
    let pointChange: String?
    let percentSign: Sign
    let direction: Direction
}

extension QuoteViewModel {

    init(model: QuoteModel, tickerIconUrl: String, formatters: FormattersProtocol) {
        ticker = model.ticker
        lastMarket = model.lastMarket
        name = model.name
        percentChange = formatters.formatPercent(value: model.percentChange)
        lastPrice = formatters.formatPrice(value: model.lastPrice, minStep: model.minStep)
        pointChange = formatters.formatPrice(value: model.pointChange, minStep: model.minStep)
        percentSign = Sign(value: model.percentChange)
        direction = model.direction
        self.tickerIconUrl = tickerIconUrl
    }
}
