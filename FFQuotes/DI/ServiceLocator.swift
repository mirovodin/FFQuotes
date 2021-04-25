//
//  ServiceLocator.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 24.04.2021.
//

protocol ServiceLocatorProtocol {
    func getQuotesRepository() -> QuotesRepositoryProtocol
    func getFormatters() -> FormattersProtocol
    func getSocketManager() -> SocketManagerProtocol
    func getNetworkConfig() -> NetworkConfigProtocol
    func getTickerIconsFactory() -> TickerIconsFactoryProtocol
}

final class ServiceLocator {
    static let shared = ServiceLocator()

    private lazy var formatters = Formatters()
    private lazy var socket = WebSocketImpl()
    private lazy var socketInitializer = SocketInitializer()
    private lazy var socketManager = SocketManager(
        socket: socket,
        sender: SocketCommandSender(socket: socket, initializer: socketInitializer),
        initializer: socketInitializer,
        networkReachability: NetworkReachabilityService())

    private init() { }
}

extension ServiceLocator: ServiceLocatorProtocol {

    func getFormatters() -> FormattersProtocol {
        return formatters
    }

    func getSocketManager() -> SocketManagerProtocol {
        return socketManager
    }
    
    func getQuotesRepository() -> QuotesRepositoryProtocol {
        let dependencies = QuotesRepository.Dependencies(
            storage: QuotesStorage(),
            commandBuilder: SocketCommandBuilder(),
            socketSender: SocketCommandSender(socket: socket, initializer: socketInitializer),
            socketPublisher: socket,
            socketParser: SocketParser()
        )
        let repository = QuotesRepository(dependencies: dependencies)
        return repository
    }

    func getNetworkConfig() -> NetworkConfigProtocol {
        return NetworkConfig()
    }

    func getTickerIconsFactory() -> TickerIconsFactoryProtocol {
        return TickerIconsFactory()
    }
}
