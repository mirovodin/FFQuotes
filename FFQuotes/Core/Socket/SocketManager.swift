//
//  SocketManager.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 24.04.2021.
//

import Foundation
import Observable

protocol SocketStatus {
    var isNetworkReachable: Bool { get }
    var isSocketConnected: Bool { get }
}

protocol SocketManagerProtocol {
    func start(config: Socket.Config)
    func pause()
    func restore()
    func stop()
}

final class SocketManager {

    private enum Constants {
        static let reconnectInterval = TimeInterval(5)
    }

    private let socket: SocketProtocol
    private let socketSender: SocketCommandSenderProtocol
    private let networkReachability: NetworkReachabilityProtocol
    private let socketInitializer: SocketInitializerProtocol
    private var config: Socket.Config?
    private var reconnectTimer: Timer?
    private var isPaused = true
    private var disposal = Disposal()

    init(socket: SocketProtocol, sender: SocketCommandSenderProtocol, initializer: SocketInitializerProtocol, networkReachability: NetworkReachabilityProtocol) {
        self.socket = socket
        self.socketSender = sender
        self.networkReachability = networkReachability
        self.socketInitializer = initializer
    }

    deinit {
        stop()
    }

    private func processConnected() {
        print("> Socket: connected.")
        stopReconnectTimer()

        socketInitializer.commands.forEach { command in
            socketSender.send(command: command)
        }
    }

    private func processDisconnected() {
        print("> Socket: disconnected.")
        startReconnectTimer()
    }

    private func startReconnectTimer() {
        guard reconnectTimer == nil, !isPaused, !isSocketConnected else { return }

        reconnectTimer = Timer.scheduledTimer(withTimeInterval: Constants.reconnectInterval, repeats: true) { [weak self] _ in
            self?.restore()
        }
    }

    private func stopReconnectTimer() {
        reconnectTimer?.invalidate()
        reconnectTimer = nil
    }

    private func unsubscribe() {
        disposal.dispose()
    }

    private func subscribe() {
        socket.events.observe(DispatchQueue.main) { [weak self] (event: Socket.Event, _) in
            switch event {
                case .onConnected:
                    self?.processConnected()
                case .onDisconnected:
                    self?.processDisconnected()
                default:
                    break
            }
        }.add(to: &disposal)
    }

    private func closeSocket() {
        if socket.isConnected {
            socket.close()
        }
    }
}

extension SocketManager: SocketStatus {
    var isSocketConnected: Bool {
        return socket.isConnected
    }

    var isNetworkReachable: Bool {
        return networkReachability.isNetworkReachable()
    }
}

extension SocketManager: SocketManagerProtocol {

    func start(config: Socket.Config) {
        self.config = config
        isPaused = false
        restore()
    }

    func pause() {
        isPaused = true
        closeSocket()
    }

    func restore() {
        guard let config = config else { return }
        isPaused = false
        unsubscribe()
        subscribe()
        socket.open(config: config)
    }

    func stop() {
        isPaused = true
        unsubscribe()
        closeSocket()
    }
}
