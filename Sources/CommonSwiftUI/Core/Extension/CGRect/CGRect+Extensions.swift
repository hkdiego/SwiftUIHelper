//
//  CGRect.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import Foundation
import UIKit

extension CGRect {

    public init(size: CGSize) {
        self.init(origin: .zero, size: size)
    }

    public var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    public init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }
    
    public func insetBy(insets: UIEdgeInsets) -> CGRect {
        let x = origin.x + insets.left
        let y = origin.y + insets.top
        let w = size.width - insets.left - insets.right
        let h = size.height - insets.top - insets.bottom
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    public func insetBy(top: CGFloat = 0,
                        bottom: CGFloat = 0,
                        left: CGFloat = 0,
                        right: CGFloat = 0) -> CGRect {
        
        return CGRect(x: self.origin.x + left,
                      y: self.origin.y + top,
                      width: self.size.width - left - right,
                      height: self.size.height - top - bottom)
    }
}

