//
//  Formatter.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import Foundation

protocol FormattersProtocol {
    func formatPercent(value: Double?) -> String
    func formatPrice(value: Double?, minStep: Double?) -> String
}

final class Formatters {

    private enum Constants {
        static let noValue = "-"
    }

    lazy var percent: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .floor
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.positivePrefix = formatter.plusSign
        formatter.negativePrefix = formatter.minusSign
        return formatter
    }()

    lazy var price: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .floor
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = " "
        formatter.numberStyle = .none
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 5
        formatter.maximumSignificantDigits = 5
        formatter.minimumFractionDigits = 1
        return formatter
    }()
}

extension Formatters: FormattersProtocol {
    func formatPercent(value: Double?) -> String {
        guard let value = value,
              let formatted = percent.string(from: NSNumber(value: value)) else {
            return Constants.noValue
        }
        return "\(formatted)%"
    }

    func formatPrice(value: Double?, minStep: Double?) -> String {
        guard var value = value else { return Constants.noValue }
        if let minStep = minStep {
            value = value.rounded(stride: minStep)
        }

        guard let result = price.string(from: NSNumber(value: value)) else { return Constants.noValue }
        return result
    }
}
