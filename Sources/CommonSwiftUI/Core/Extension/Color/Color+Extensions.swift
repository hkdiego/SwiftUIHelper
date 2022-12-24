//
//  Color.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
    
    static var uniformRandom: Color {
        let random: Double = .random(in: 0...1)
        return Color(red: random,
                     green: random,
                     blue: random)
    }
    
    /// returns UIColor(self)
    @available(iOS 14.0, *)
    var uiColor: UIColor {
        return UIColor(self)
    }
}

extension UIColor {
    /// returns Color(self)
    var swui: Color {
        return Color(self)
    }
}
