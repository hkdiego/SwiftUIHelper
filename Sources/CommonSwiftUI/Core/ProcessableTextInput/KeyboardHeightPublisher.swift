//
//  KeyboardHeightPublisher.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import Combine
import UIKit

extension Publishers {
    static var keyboardFrame: AnyPublisher<CGRect, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardFrame }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { $0.keyboardFrame }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

fileprivate extension Notification {
    var keyboardFrame: CGRect {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? .zero
    }
}

