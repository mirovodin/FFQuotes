//
//  QuoteResponseModel.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 22.04.2021.
//

struct QuoteResponseModel: Codable {

    private enum CodingKeys : String, CodingKey {
        case ticker = "c"           // Тикер
        case percentChange = "pcp"  // Изменение в процентах относительно цены закрытия предыдущей торговой сессии
        case lastMarket = "ltr"     // Биржа последней сделки
        case name                   // Название бумаги
        case lastPrice = "ltp"      // Цена последней сделки
        case pointChange = "chg"    // Изменение цены последней сделки в пунктах относительно цены закрытия предыдущей торговой сессии
        case minStep = "min_step"   // Минимальный шаг цены
    }

    let ticker: String
    let percentChange: Double?
    let lastMarket: String?
    let name: String?
    let lastPrice: Double?
    let pointChange: Double?
    let minStep: Double?
}
