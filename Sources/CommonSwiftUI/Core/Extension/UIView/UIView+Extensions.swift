//
//  UIView.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import Foundation
import UIKit

public extension UIView {
  
  @discardableResult
    func add(to: UIView) -> Self {
    to.addSubview(self)
    return self
  }
  
  @discardableResult
    func insert(to superview: UIView, at index: Int) -> Self {
    superview.insertSubview(self, at: index)
    return self
  }
  
  @discardableResult
    func insert(to superview: UIView, above view: UIView) -> Self {
    superview.insertSubview(self, aboveSubview: view)
    return self
  }
  
  @discardableResult
    func insert(to superview: UIView, below view: UIView) -> Self {
    superview.insertSubview(self, belowSubview: view)
    return self
  }
  
    @discardableResult
    func add(toStackView: UIStackView, padding: CGFloat) -> Self {
        let stack = UIStackView(arrangedSubviews: [self]).then {
            $0.axis = toStackView.axis
            $0.alignment = toStackView.alignment
            $0.layoutMargins = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            $0.distribution = toStackView.distribution
            $0.spacing = toStackView.spacing
            $0.isLayoutMarginsRelativeArrangement = true
        }
        toStackView.addArrangedSubview(stack)
        return self
    }
    
    @discardableResult
    func add(to stackView: UIStackView) -> Self {
        stackView.addArrangedSubview(self)
        return self
    }
    
    convenience init(size: CGSize) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: size))
    }
}


extension UIView {
  
  public func removeSelfConstraints () {
    var superview = self.superview
    while superview != nil {
      for c in superview!.constraints {
        if c.firstItem as! NSObject == self || c.secondItem as! NSObject == self {
          superview?.removeConstraint(c)
        }
      }
      superview = superview?.superview
    }
    self.removeConstraints(self.constraints)
    self.translatesAutoresizingMaskIntoConstraints = true
  }
}

extension UIView {
  
  public func pauseLayerAnimations() {
    let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
    layer.speed = 0.0
    layer.timeOffset = pausedTime
  }
  
  public func resumeLayerAnimations() {
    let pausedTime = layer.timeOffset
    layer.speed = 1.0
    layer.timeOffset = 0.0
    layer.beginTime = 0.0
    let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    layer.beginTime = timeSincePause
  }
}


extension UIView {
    var globalFrame: CGRect? {
        return superview?.convert(frame, to: nil)
    }
}
