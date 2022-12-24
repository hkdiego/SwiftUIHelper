//
//  ActivityView.swift
//  
//
//  Created by Aleksandr Nesterov on 19.11.2020.
//

import SwiftUI

public struct ActivityView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    public init(isShowing: Binding<Bool>, content: @escaping (() -> Content)) {
        self._isShowing = isShowing
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                content()
                
                VStack {
                    ActivityIndicator(shouldAnimate: $isShowing, style: .large, color: .black)
                }
                .opacity(isShowing ? 1 : 0)
                .edgesIgnoringSafeArea(.all)
            }.zIndex(.greatestFiniteMagnitude)
        }
    }
}
