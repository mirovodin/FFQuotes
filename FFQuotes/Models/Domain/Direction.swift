//
//  Direction.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

enum Direction {
    case up
    case down
    case none
}

extension Direction {

    init(newValue: Double?, oldValue: Double?) {
        if let oldValue = oldValue, let newValue = newValue {
            if oldValue > newValue {
                self = .down
            } else if oldValue < newValue {
                self = .up
            } else {
                self = .none
            }
        } else {
            self = .none
        }
    }
}
