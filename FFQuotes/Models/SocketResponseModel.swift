//
//  SocketResponseModel.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 22.04.2021.
//

enum SocketResponse {

    enum DataType: String, Codable {
        case userData = "userData"
        case quote = "q"
    }

    case userData(model: UserDataResponseModel)
    case quote(model: QuoteResponseModel)
}
