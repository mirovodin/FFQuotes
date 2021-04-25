//
//  SocketParser.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 22.04.2021.
//

import Foundation

protocol SocketParserProtocol {
    func makeResponseModel(data: Data) -> SocketResponse?
}

final class SocketParser {

    private let factory: SocketResponseFactoryProtocol

    init(factory: SocketResponseFactoryProtocol = SocketResponseFactory()) {
        self.factory = factory
    }
}

extension SocketParser: SocketParserProtocol {

    func makeResponseModel(data: Data) -> SocketResponse? {
        guard let items = (try? JSONSerialization.jsonObject(with: data)) as? [Any] else {
            print("> SocketParser: Unknown json format.")
            return nil
        }
        guard let dataTypeStr = items[0] as? String, let dataType = SocketResponse.DataType(rawValue: dataTypeStr) else {
            print("> SocketParser: Unknown data type.")
            return nil
        }

        guard let data = items[1] as? [String: Any] else {
            print("> SocketParser: Wrong data.")
            return nil
        }
        return factory.makeModel(type: dataType, data: data)
    }
}
