//
//  View+ResignKeyboard.swift
//  Photo Translator
//
//  Created by Aleksandr Nesterov on 30.10.2020.
//

import SwiftUI

public struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    public func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

public extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
