//
//  SocketActions.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//


protocol SocketAction {
    var id: Int { get }
    var isRestorable: Bool { get }
    var toJson: String { get }
}


enum SocketCommands {
    struct QuotesSubscribe: SocketAction {
        let id = 1
        let isRestorable = true
        let toJson: String

        init?(factory: SocketCommandBuilderProtocol = SocketCommandBuilder(), tickers: [String]) {
            guard let json = factory.makeSubscribeToQuotes(tickers: tickers) else {
                return nil
            }
            toJson = json
        }
    }
}
