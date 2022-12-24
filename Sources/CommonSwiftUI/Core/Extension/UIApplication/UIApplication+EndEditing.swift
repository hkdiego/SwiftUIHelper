//
//  UIApplication+EndEditing.swift
//  Photo Translator
//
//  Created by Aleksandr Nesterov on 30.10.2020.
//

import UIKit

public extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}
