//
//  TickerIconsFactory.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 25.04.2021.
//

import Foundation

protocol TickerIconsFactoryProtocol {
    func makeTickerIconUrl(ticker: String) -> String
}

final class TickerIconsFactory: TickerIconsFactoryProtocol {
    
    func makeTickerIconUrl(ticker: String) -> String {
        return "https://tradernet.ru/logos/get-logo-by-ticker?ticker=" + ticker.lowercased()
    }

}
