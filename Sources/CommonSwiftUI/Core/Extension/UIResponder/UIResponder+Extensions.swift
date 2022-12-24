//
//  UIResponder.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import Foundation
import SwiftUI

// From https://stackoverflow.com/a/14135456/6870041
public extension UIResponder {
    static var currentResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    private static weak var _currentFirstResponder: UIResponder?

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}

public extension UIApplication {
    /// sends UIResponder.resignFirstResponder action
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
