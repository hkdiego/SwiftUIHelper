//
//  LottieAnimationView.swift
//  
//
//  Created by Aleksandr Nesterov on 16.11.2020.
//

import SwiftUI
import Lottie

public struct LottieAnimationView: UIViewRepresentable {
    
    let animation: String
    let completion: ((Bool) -> Bool)?
    let loopMode: LottieLoopMode
    
    public init(animation: String, completion: ((Bool) -> Bool)?, loopMode: LottieLoopMode) {
        self.animation = animation
        self.completion = completion
        self.loopMode = loopMode
    }
    
    public func makeUIView(context: Context) -> AnimationView {
        let view = AnimationView(animation: Animation.named(animation))
        view.loopMode = loopMode
        play(view: view)
        return view
    }
    
    private func play(view: AnimationView) {
        view.play { res in
            if completion?(res) == true {
                play(view: view)
            }
        }
    }
    
    public func updateUIView(_ uiView: AnimationView, context: Context) {
        
    }
}
