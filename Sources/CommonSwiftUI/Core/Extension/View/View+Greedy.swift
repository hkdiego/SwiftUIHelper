//
//  File.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import Foundation
import SwiftUI

extension View {
    public func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        return self.frame(width: size.width, height: size.height, alignment: alignment)
    }
    
    public func frame(minSize: CGSize? = nil,
                      idealSize: CGSize? = nil,
                      maxSize: CGSize? = nil,
                      alignment: Alignment = .center) -> some View {
        return self.frame(minWidth: minSize?.width, idealWidth: idealSize?.width, maxWidth: maxSize?.width, minHeight: minSize?.height, idealHeight: idealSize?.height, maxHeight: maxSize?.height, alignment: alignment)
    }
    
    public func offset(_ offset: CGPoint) -> some View {
        return self.offset(x: offset.x, y: offset.y)
    }
    
    public func greedyFrame(alignment: Alignment) -> some View {
        return self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
    
    public func greedyWidth(alignment: Alignment) -> some View {
        return self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    public func greedyHeight(alignment: Alignment) -> some View {
        return self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    public var asAnyView: AnyView {
        return AnyView(self)
    }
    
    public var screenSized: some View {
        return self.frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                   .edgesIgnoringSafeArea(.all)
    }
}

extension Edge.Set {
    static var none: Edge.Set {
        return []
    }
}

@inlinable
func VSpacer(_ height: CGFloat) -> some View {
    return Spacer(minLength: 0).frame(height: height)
}

@inlinable
func HSpacer(_ width: CGFloat) -> some View {
    return Spacer(minLength: 0).frame(width: width)
}

var WidthSpacer: some View {
    return HStack { Spacer(minLength: 0) }
}

var HeightSpacer: some View {
    return VStack { Spacer(minLength: 0) }
}

extension CGFloat {
    static let minAlowedScale: CGFloat = 0.001
}


struct Screen<Content>: View where Content: View {
    private let content: () -> Content
    private let backgoundColor: Color?
    private let backgroundImage: Image?
    private let ignoreKeyboard: Bool
    
    init(color: Color = .white,
         ignoreKeyboard: Bool = false,
         @ViewBuilder content: @escaping () -> Content) {
        
        self.content = content
        self.ignoreKeyboard = ignoreKeyboard
        self.backgoundColor = color
        self.backgroundImage = nil
    }
    
    init(background: Image,
         ignoreKeyboard: Bool = false,
         @ViewBuilder content: @escaping () -> Content) {
        
        self.content = content
        self.ignoreKeyboard = ignoreKeyboard
        self.backgroundImage = background
        self.backgoundColor = nil
    }
    
    var body: some View {
        ZStack {
            backgoundColor?.edgesIgnoringSafeArea(.all)
            backgroundImage?.resizable()
                .scaledToFill()
                .greedyFrame(alignment: .center)
            content()
        }
//        .applyIf(ignoreKeyboard) { view in
//            view.frame(size: CGSize.safeScreenSize)
//                .position(CGSize.safeScreenSize.center)
//                .ignoresSafeArea(.keyboard)
//        }
    }
}


extension HorizontalAlignment {
    init(textAlignment: NSTextAlignment) {
        switch textAlignment {
        case .left: self = .leading
        case .right: self = .trailing
        default: self = .center
        }
    }
}

