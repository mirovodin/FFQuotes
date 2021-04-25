//
//  SocketActions.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import Foundation

protocol SocketCommand {
    var id: String { get }
    var isRestorable: Bool { get }
    var toJson: String { get }
}

enum SocketCommands {

    static let QuotesSubscribeId = "quotes"

    struct QuotesSubscribe: SocketCommand {
        let id: String
        let isRestorable: Bool
        let toJson: String
    }
}
