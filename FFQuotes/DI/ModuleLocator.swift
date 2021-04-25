//
//  ModuleLocator.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

protocol ModuleLocatorProtocol {
    func getQuotesModule() -> QuotesModuleProtocol
}

final class ModuleLocator {
    static let shared = ModuleLocator()
    private init() { }
}

extension ModuleLocator: ModuleLocatorProtocol {

    func getQuotesModule() -> QuotesModuleProtocol {
        let repository = ServiceLocator.shared.getQuotesRepository()
        let formatters = ServiceLocator.shared.getFormatters()
        let tickerIconsFactory = ServiceLocator.shared.getTickerIconsFactory()
        let module = QuotesModule(repository: repository, formatters: formatters, tickerIconsFactory: tickerIconsFactory)
        return module
    }
}
