//
//  UI+Palette.swift
//  FFQuotes
//
//  Created by Dmitriy Mirovodin on 23.04.2021.
//

import Foundation
import UIKit

extension UIView {
    var palette: PaletteProtocol {
        return Palette.current
    }
}

extension UIViewController {
    var palette: PaletteProtocol {
        return Palette.current
    }
}
