//
//  NetworkConfig.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 25.04.2021.
//

import Foundation

protocol NetworkConfigProtocol {
    func makeSocketConfig() -> Socket.Config?
}

final class NetworkConfig: NetworkConfigProtocol {

    func makeSocketConfig() -> Socket.Config? {
        return Socket.Config(url: "https://wss.tradernet.ru/")
    }
}
