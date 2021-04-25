//
//  NSObject+Identifier.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import Foundation

extension NSObject {
    static func toIdentifier() -> String {
        return String(describing: self)
    }
}

