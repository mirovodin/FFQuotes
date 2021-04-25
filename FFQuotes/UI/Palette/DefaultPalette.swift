//
//  DefaultPalette.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import UIKit

final class DefaultPalette {

    private lazy var colorsByKeys: [Palette.Color: UIColor] =  {
        return getColorsMap()
    }()

    private func getColorsMap() -> [Palette.Color: UIColor] {
        var map = [Palette.Color: UIColor]()
        map[.background] = UIColor.white
        map[.foreground] = UIColor.black
        map[.disabled] = UIColor(hex: 0x6C6C78)
        map[.accent1] = UIColor(hex: 0xFE2D55)
        map[.accent2] = UIColor(hex: 0x72BF44)
        return map
    }

    func getFontSize(_ size: Palette.FontSize) -> CGFloat {
        switch size {
        case .size10:
            return 10
        case .size13:
            return 13
        case .size18:
            return 18
        case .size20:
            return 20
        }
    }
}

extension DefaultPalette: PaletteProtocol {

    func getMediumFont(_ size: Palette.FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: getFontSize(size), weight: UIFont.Weight.medium)
    }

    func getFont(_ size: Palette.FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: getFontSize(size), weight: UIFont.Weight.regular)
    }

    func getColor(_ color: Palette.Color) -> UIColor {
        return colorsByKeys[color] ?? UIColor.clear
    }

}
