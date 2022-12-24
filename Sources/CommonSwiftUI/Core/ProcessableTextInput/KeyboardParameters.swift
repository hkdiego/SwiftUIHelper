//
//  ResponderParameters.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import SwiftUI
import Combine
import UIKit

public struct ResponderParameters {
    /// Will be used as responder height in keyboard avoidance offset calculation
    let customHeight: CGFloat
}

public protocol ParameterizedResponder {
    var responderParameters: ResponderParameters? { get }
}

public extension ParameterizedResponder {
    func responderFrame(_ source: CGRect) -> CGRect {
        guard let parameters = responderParameters else { return source }
        let size = CGSize(width: source.width, height: parameters.customHeight)
        return CGRect(center: source.center, size: size)
    }
}

public extension View {
    func keyboardAdaptive(extraPadding: CGFloat) -> some View {
        self.modifier(KeyboardAdaptive(extraPadding: extraPadding))
    }
}

public struct KeyboardAdaptive: ViewModifier {
    @State private var offset: CGFloat = 0
    private let additionalPadding: CGFloat
    
    public init(extraPadding: CGFloat) {
        self.additionalPadding = extraPadding
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(x: 0, y: -self.offset)
            .onReceive(Publishers.keyboardFrame) { keyboardFrame in
                guard let input = UIResponder.currentResponder as? UIView else { return }
                guard let frame = input.globalFrame else { return }
                let inputFrame = (input as? ParameterizedResponder)?.responderFrame(frame) ?? frame
                
                let keyboardTop = keyboardFrame.minY
                let inputBottom = inputFrame.maxY + self.offset + additionalPadding
                
                let disposition = max(0, inputBottom - keyboardTop)
                let offset = keyboardTop > 0 ? disposition : 0
                
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.offset = offset
                }
            }
    }
}

