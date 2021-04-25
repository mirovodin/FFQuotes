//
//  QuoteModel.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

struct QuoteModel {
    let ticker: String
    let lastMarket: String?
    let name: String?
    let percentChange: Double?
    let lastPrice: Double?
    let pointChange: Double?
    let direction: Direction
    let minStep: Double?
}

extension QuoteModel {

    init(response: QuoteResponseModel, model: QuoteModel?) {
        ticker = response.ticker
        lastMarket = response.lastMarket ?? model?.lastMarket
        name = response.name ?? model?.name
        lastPrice = response.lastPrice ?? model?.lastPrice
        percentChange = response.percentChange ?? model?.percentChange
        pointChange = response.pointChange ?? model?.pointChange
        minStep = response.minStep ?? model?.minStep
        direction = .init(newValue: response.percentChange, oldValue: model?.percentChange)
    }
}

extension QuoteModel: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(ticker)
    }
}
