//
//  FullBackgroundBlur.swift
//  Photo Translator
//
//  Created by Aleksandr Nesterov on 30.10.2020.
//

import SwiftUI

public struct FullBackgroundBlur: View {
    public var body: some View {
        VisualEffectView(effect: UIBlurEffect(style: .dark))
            .edgesIgnoringSafeArea(.all)
    }
}
