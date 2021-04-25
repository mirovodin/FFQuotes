//
//  Palette.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import Foundation
import UIKit

enum Palette {

    enum FontSize {
        case size10
        case size13
        case size18
        case size20
    }

    enum Color {
        case background
        case foreground
        case disabled
        case accent1
        case accent2
    }

    static let current: PaletteProtocol = DefaultPalette()
}

protocol PaletteProtocol {
    func getFont(_ size: Palette.FontSize) -> UIFont
    func getMediumFont(_ size: Palette.FontSize) -> UIFont
    func getColor(_ color: Palette.Color) -> UIColor
}

