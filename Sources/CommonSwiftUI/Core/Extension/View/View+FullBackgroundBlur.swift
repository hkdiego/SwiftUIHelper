//
//  View+FullBlurView.swift
//  Photo Translator
//
//  Created by Aleksandr Nesterov on 30.10.2020.
//

import SwiftUI

public extension View {
    var fullBackgroundBlur: some View {
        FullBackgroundBlur()
            .zIndex(1)
            .animation(.default)
            .transition(.opacity)
    }
}
