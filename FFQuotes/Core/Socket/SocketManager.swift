//
//  SocketManager.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 24.04.2021.
//

import Foundation
import Observable

protocol SocketManagerProtocol {
    func start(config: Socket.Config)
    func pause()
    func restore()
    func stop()
}

final class SocketManager {

    private enum Constants {
        static let reconnectInterval = TimeInterval(3)
    }

    private let socket: SocketProtocol
    private let socketSender: SocketCommandSenderProtocol
    private let socketInitializer: SocketInitializerProtocol
    private let internalStatus = MutableObservable(Socket.Status.onInitialized)
    private var config: Socket.Config?
    private var reconnectTimer: Timer?
    private var isPaused = true
    private var disposal = Disposal()

    init(socket: SocketProtocol, sender: SocketCommandSenderProtocol, initializer: SocketInitializerProtocol) {
        self.socket = socket
        self.socketSender = sender
        self.socketInitializer = initializer
    }

    deinit {
        stop()
    }

    private func processConnected() {
        print("> Socket: connected.")
        internalStatus.wrappedValue = .onConnected
        stopReconnectTimer()

        socketInitializer.commands.forEach { command in
            socketSender.send(command: command)
        }
    }

    private func processDisconnected() {
        print("> Socket: disconnected.")
        internalStatus.wrappedValue = .onDisconnected
        startReconnectTimer()
    }

    private func startReconnectTimer() {
        guard reconnectTimer == nil, !isPaused, !isConnected else { return }
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
        socket.status.observe(DispatchQueue.main) { [weak self] (event: Socket.Status, _) in
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

extension SocketManager: SocketStatusProvider {

    var status: Observable<Socket.Status> {
        return internalStatus
    }

    var isConnected: Bool {
        return socket.isConnected
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
