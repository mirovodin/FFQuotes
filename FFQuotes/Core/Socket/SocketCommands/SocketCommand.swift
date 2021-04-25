//
//  SocketCommand.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 24.04.2021.
//

protocol SocketCommandSenderProtocol {
    func send(command: SocketCommand)
}

final class SocketCommandSender {

    private let socket: SocketProtocol
    private let initializer: SocketInitializerProtocol

    init(socket: SocketProtocol, initializer: SocketInitializerProtocol) {
        self.socket = socket
        self.initializer = initializer
    }
}

extension SocketCommandSender: SocketCommandSenderProtocol {

    func send(command: SocketCommand) {
        initializer.add(command: command)
        socket.write(string: command.toJson)
    }
}
