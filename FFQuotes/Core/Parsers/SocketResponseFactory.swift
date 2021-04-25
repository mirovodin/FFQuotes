//
//  SocketResponseFactory.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 22.04.2021.
//

import Foundation

protocol SocketResponseFactoryProtocol {
    func makeModel(type: SocketResponse.DataType, data: [String: Any]) -> SocketResponse?
}

final class SocketResponseFactory: SocketResponseFactoryProtocol {

    func makeModel(type: SocketResponse.DataType, data: [String: Any]) -> SocketResponse? {
        switch type {
            case .quote:
                guard let model = QuoteResponseModel(json: data) else { return nil }
                return SocketResponse.quote(model: model)
            case .userData:
                guard let model = UserDataResponseModel(json: data) else { return nil }
                return SocketResponse.userData(model: model)
        }
    }
}
