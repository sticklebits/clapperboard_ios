//
//  UIView+Extensions.swift
//  Segmentum Imaging
//
//  Created by Steve Johnson on 07/09/2016.
//  Copyright © 2016 Brightec. All rights reserved.
//

import UIKit
import QuartzCore

extension UIView {
    
    typealias ReturnConstraints = (leading: NSLayoutConstraint?, trailing: NSLayoutConstraint?, top: NSLayoutConstraint?, bottom: NSLayoutConstraint?)
    
    static func withoutAnimation(block:(Void)->Void) {
        let animations = self.areAnimationsEnabled
        self.setAnimationsEnabled(false)
        block()
        self.setAnimationsEnabled(animations)
    }
    
    @discardableResult func pin(insideView view: UIView, insets: UIEdgeInsets) -> ReturnConstraints {
        return pin(insideView: view, toBottomOfView: view, insets: insets)
    }
    
    @discardableResult func pin(insideView view: UIView, toBottomOfView: UIView?, insets: UIEdgeInsets) -> ReturnConstraints {
                
        translatesAutoresizingMaskIntoConstraints = false
        let leading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: insets.left)
        let trailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -insets.right)
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -insets.bottom)
        
        var top: NSLayoutConstraint?
        
        if toBottomOfView != nil {
            let topAttribute: NSLayoutAttribute = view == toBottomOfView ? .top : .bottom
            top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: toBottomOfView, attribute: topAttribute, multiplier: 1.0, constant: insets.top)
            view.addConstraints([leading, trailing, top!, bottom])
        } else {
            view.addConstraints([leading, trailing, bottom])
        }
        return (leading: leading, trailing: trailing, top: top, bottom: bottom)
    }
    
    @discardableResult func underline(color: UIColor, height: CGFloat, leftInset: CGFloat) -> ReturnConstraints {
        let underlineView = UIView()
        addSubview(underlineView)
        underlineView.backgroundColor = color
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: underlineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: height))
        return underlineView.pin(insideView: self, toBottomOfView: nil, insets: UIEdgeInsets(top: 0.0, left: leftInset, bottom: 0.0, right: 0.0))
    }
}
