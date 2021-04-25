//
//  SocketJsonCommandBuilder.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 22.04.2021.
//

import Foundation

protocol SocketCommandBuilderProtocol {
    func makeQuotesSubscribe(tickers: [String]) -> SocketCommands.QuotesSubscribe?
}

final class SocketCommandBuilder {

    private func makeJsonStr(request: [Any]) -> String? {
        let data = try? JSONSerialization.data(withJSONObject: request, options: [])
        if let data = data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

extension SocketCommandBuilder: SocketCommandBuilderProtocol {

    func makeQuotesSubscribe(tickers: [String]) -> SocketCommands.QuotesSubscribe? {
        guard !tickers.isEmpty else { return nil }

        let request = [SocketCommands.QuotesSubscribeId, tickers] as [Any]
        guard let json = makeJsonStr(request: request) else { return nil }

        let command = SocketCommands.QuotesSubscribe(
            id: SocketCommands.QuotesSubscribeId,
            isRestorable: true,
            toJson: json)
        return command
    }
}
