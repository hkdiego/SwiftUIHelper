//
//  KeyboardAccessoryView.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import Foundation
import UIKit

public enum KeyboardAccessoryView {
        
    static func returnButton(
        text: String,
        type: UIReturnKeyType = .done,
        action: @escaping () -> Void
    ) -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.barStyle = .default
        toolbar.tintColor = UIColor.blue
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let button = UIBarButtonItem.textButtonItem(title: text, action: action)
        toolbar.items = [flexSpace, button]
        toolbar.sizeToFit()
        return toolbar
    }
}
