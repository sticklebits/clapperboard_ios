//
//  UIViewControllerContextTransitioning+Extensions.swift
//  Clapperboard
//
//  Created by Steve Johnson on 17/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

extension UIViewControllerContextTransitioning {
    
    var isPresenting: Bool {
        return meta.isPresenting
    }
    
    var meta: (from: UIViewController, to: UIViewController, container: UIView, isPresenting: Bool) {
        let from = viewController(forKey: .from)!
        let to = viewController(forKey: .to)!
        let isPresenting = to.presentedViewController != from
        return (from: from, to: to, container: containerView, isPresenting: isPresenting)
    }
}
