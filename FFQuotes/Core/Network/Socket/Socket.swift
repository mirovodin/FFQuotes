//
//  SocketChannel.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 22.04.2021.
//

import Observable

enum Socket {

    enum Event {
        case onInitialized
        case onConnected
        case onDisconnected
        case onDataReceived(data: Data)
    }

    struct Config {
        let urlRequest: URLRequest
    }
}

extension Socket.Config {

    init?(url: String) {
        guard let url = URL(string: url)  else { return nil }
        urlRequest = URLRequest(url: url)
    }
}

protocol SocketPublisherProtocol {
    var events: Observable<Socket.Event> { get }
}

protocol SocketProtocol: SocketPublisherProtocol {
    var isConnected: Bool { get }
    func open(config: Socket.Config)
    func close()
    func write(string: String)
}
