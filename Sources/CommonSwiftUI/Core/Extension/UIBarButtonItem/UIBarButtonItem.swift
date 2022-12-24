//
//  UIBarButtonItem.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import Foundation
import UIKit

public extension UIBarButtonItem {
    static func close(text: String, action: @escaping () -> Void) -> UIBarButtonItem {
        return textButtonItem(title: text, action: action)
    }
    
    static func cancel(text: String, action: @escaping () -> Void) -> UIBarButtonItem {
        return textButtonItem(title: text, action: action)
    }
    
    static func next(text: String, action: @escaping () -> Void) -> UIBarButtonItem {
        return textButtonItem(title: text, action: action)
    }
    
    static func done(text: String, action: @escaping () -> Void) -> UIBarButtonItem {
        return textButtonItem(title: text, action: action)
    }
    
    static func textButtonItem(title: String, action: @escaping () -> Void) -> UIBarButtonItem {
        let normal = title.attributed
            .font(UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium))
            .color(UIColor.black)
        
        let highlighted = title.attributed
            .font(UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium))
            .color(UIColor.darkGray)
        
        let button = UIButton(type: .custom).then {
            $0.setAttributedTitle(normal, for: .normal)
            $0.setAttributedTitle(highlighted, for: .highlighted)
            $0.onTap { action() }
        }
        return UIBarButtonItem(customView: button)
    }
}

