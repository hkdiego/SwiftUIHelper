//
//  UIWindow+Current.swift
//  
//
//  Created by Aleksandr Nesterov on 16.11.2020.
//

import Foundation
import UIKit

public extension UIWindow {

    func switchRootViewController(
        _ viewController: UIViewController,
        onSwitchRVC: (() -> Void)? = nil,
        completion: (() -> Void)? = nil,
        animated: Bool = true) {

        guard let previous = rootViewController, animated else {
            rootViewController = viewController
            completion?()
            onSwitchRVC?()
            return
        }

        let removePreviousController: () -> Void = { [weak previous] in
            // mpdal controller have strong reference to it presenting controller, to correct memory management we must dismiss it before replace parent controller.
            previous?.dismiss(animated: false, completion: nil)
            previous?.view.removeFromSuperview()
            previous?.removeFromParent()
        }

        guard let snapShot: UIView = subviews.last?.snapshotView() else {
            removePreviousController()
            delay(TimeInterval.oneFrame) {
                self.rootViewController = viewController
                onSwitchRVC?()
                completion?()
            }
            return
        }

        removePreviousController()
        addSubview(snapShot)

        delay(TimeInterval.oneFrame) { // fucking apple! if previous controller is dismissing modal controller it must be in window views hierarchy
            snapShot.removeFromSuperview()
            self.rootViewController = viewController

            onSwitchRVC?()

            viewController.view.addSubview(snapShot)
            UIView.animate(withDuration: 0.6, animations: { () -> Void in
                snapShot.layer.opacity = 0
                snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: { (_: Bool) -> Void in
                snapShot.removeFromSuperview()
                completion?()
            })
        }
    }
}

public extension UIWindow {
    
    static var safeInsets: UIEdgeInsets {
        return current?.safeAreaInsets ?? .zero
    }
        
    static var isFullScreen: Bool {
        return current?.frame == UIScreen.main.bounds
    }
}

public extension UIWindow {
     
    static var current: UIWindow? {
        //if scene is not connected will use first normal level key window
        return sceneActiveWindow ?? keyWindow
    }
    
    static var keyWindow: UIWindow? {
        var window = UIApplication.shared.windows.first { $0.isKeyWindow }
        if window == nil || window?.windowLevel != .normal {
            for w in UIApplication.shared.windows {
                if w.windowLevel == .normal {
                    window = w
                }
            }
        }
        return window
    }
    
    static var sceneActiveWindow: UIWindow? {
        let window = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows
            .filter({ $0.isKeyWindow }).first
        return window
    }
}

