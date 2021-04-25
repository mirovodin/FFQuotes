//
//  Double+Extensions.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 24.04.2021.
//

extension Double {

    func rounded(stride: Double, rule: FloatingPointRoundingRule = .toNearestOrEven) -> Double {
        return (self / stride).rounded(rule) * stride
    }
}
