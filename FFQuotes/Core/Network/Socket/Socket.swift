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
        case onDataReceived(data: Data)
    }

    enum Status {
        case onInitialized
        case onConnected
        case onDisconnected
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

protocol SocketStatusProvider {
    var status: Observable<Socket.Status> { get }
    var isConnected: Bool { get }
}

protocol SocketPublisherProtocol {
    var events: Observable<Socket.Event> { get }
}

protocol SocketProtocol: SocketPublisherProtocol, SocketStatusProvider {
    var isConnected: Bool { get }
    func open(config: Socket.Config)
    func close()
    func write(string: String)
}
