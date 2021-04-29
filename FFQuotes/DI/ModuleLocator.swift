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
        let dependencies = QuotesModule.Dependencies(
            repository: ServiceLocator.shared.getQuotesRepository(),
            formatters: ServiceLocator.shared.getFormatters(),
            iconsFactory: ServiceLocator.shared.getTickerIconsFactory(),
            socketStatus: ServiceLocator.shared.getSocketStatus(),
            networkStatus: ServiceLocator.shared.getNetworkStatus())
        let module = QuotesModule(dependencies: dependencies)
        return module
    }
}
