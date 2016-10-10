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
    
    static func withoutAnimation(block:(Void)->Void) {
        let animations = self.areAnimationsEnabled
        self.setAnimationsEnabled(false)
        block()
        self.setAnimationsEnabled(animations)
    }
    
    func pin(insideView view: UIView, insets: UIEdgeInsets) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: insets.left))
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -insets.right))
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: insets.top))
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -insets.bottom))
    }
    
    func underline(color: UIColor, height: CGFloat, leftInset: CGFloat) {
        let underlineView = UIView()
        addSubview(underlineView)
        underlineView.backgroundColor = color
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: underlineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: height))
        addConstraint(NSLayoutConstraint(item: underlineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: leftInset))
        addConstraint(NSLayoutConstraint(item: underlineView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: underlineView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
    }
}
