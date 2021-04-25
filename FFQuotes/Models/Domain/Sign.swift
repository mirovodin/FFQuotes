//
//  Sign.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

enum Sign {
    case positive
    case negative
    case zero
    case undefined
}


extension Sign {

    init(value: Double?) {
        if let value = value {
            if value.isZero {
                self = .zero
            } else if value > 0 {
                self = .positive
            } else {
                self = .negative
            }
        } else {
            self = .undefined
        }
    }
}
