//
//  SocketInitializer.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 24.04.2021.
//

import Foundation

protocol SocketInitializerProtocol {
    var commands: [SocketCommand] { get }
    func add(command: SocketCommand)
    func removeAll()
}

final class SocketInitializer {

    private var store = [String: SocketCommand]()

    var commands: [SocketCommand] {
        return Array(store.values)
    }
}

extension SocketInitializer: SocketInitializerProtocol {

    func add(command: SocketCommand) {
        guard command.isRestorable else { return }
        store.removeValue(forKey: command.id)
        store[command.id] = command
    }

    func removeAll() {
        store.removeAll()
    }
}
