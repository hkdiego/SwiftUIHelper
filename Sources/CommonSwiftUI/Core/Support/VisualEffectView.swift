//
//  VisualEffectView.swift
//  Photo Translator
//
//  Created by Aleksandr Nesterov on 28.10.2020.
//

import SwiftUI
import UIKit

public struct VisualEffectView: UIViewRepresentable {
    public var effect: UIVisualEffect?
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
