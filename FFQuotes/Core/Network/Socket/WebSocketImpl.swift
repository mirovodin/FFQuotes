//
//  WebSocketImpl.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 22.04.2021.
//

import Starscream
import Observable

final class WebSocketImpl {

    private var webSocket: WebSocket?
    private let queue = DispatchQueue(label: "socket-component.queue")
    private let internalEvents = MutableObservable(Socket.Event.onInitialized)

    deinit {
        close()
    }
}

extension WebSocketImpl: SocketProtocol {

    var events: Observable<Socket.Event> {
        return internalEvents
    }

    var isConnected: Bool {
        guard let webSocket = webSocket else { return false }
        return webSocket.isConnected
    }

    func open(config: Socket.Config) {
        close()

        webSocket = WebSocket(request: config.urlRequest)
        webSocket?.callbackQueue = queue
        webSocket?.delegate = self
        webSocket?.connect()
    }

    func close() {
        webSocket?.disconnect(forceTimeout: TimeInterval(0))
    }

    func write(string: String) {
        if let webSocket = webSocket,
            webSocket.isConnected {
            webSocket.write(string: string)
        }
    }
}

extension WebSocketImpl: WebSocketDelegate {

    func websocketDidConnect(socket: WebSocketClient) {
        internalEvents.wrappedValue = Socket.Event.onConnected
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        internalEvents.wrappedValue = Socket.Event.onDisconnected
        webSocket?.delegate = nil
        webSocket = nil
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let data = text.data(using: .utf8) else { return }
        internalEvents.wrappedValue = Socket.Event.onDataReceived(data: data)
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        internalEvents.wrappedValue = Socket.Event.onDataReceived(data: data)
    }
}
