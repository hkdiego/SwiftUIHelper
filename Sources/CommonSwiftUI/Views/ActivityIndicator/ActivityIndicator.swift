//
//  ActivityIndicator.swift
//  
//
//  Created by Aleksandr Nesterov on 19.11.2020.
//

import Foundation
import SwiftUI

public struct ActivityIndicator: UIViewRepresentable {
    
    private let shouldAnimate: Binding<Bool>
    private let style: UIActivityIndicatorView.Style
    private let color: UIColor
    
    public init(
        shouldAnimate: Binding<Bool> = .constant(true),
        style: UIActivityIndicatorView.Style = .medium,
        color: UIColor = .white
    ) {
        self.shouldAnimate = shouldAnimate
        self.style = style
        self.color = color
    }
    
    public func makeUIView(
        context: Context
    ) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.color = color
        return view
    }

    public func updateUIView(
        _ uiView: UIActivityIndicatorView,
        context: Context
    ) {
        if self.shouldAnimate.wrappedValue {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
