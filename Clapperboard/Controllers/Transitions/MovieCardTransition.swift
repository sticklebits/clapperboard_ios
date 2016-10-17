//
//  MovieCardTransition.swift
//  Clapperboard
//
//  Created by Steve Johnson on 17/10/2016.
//  Copyright © 2016 Sticklebits. All rights reserved.
//

import UIKit

class MovieCardTransition: NSObject {

    var startFrame: CGRect
    var insets: UIEdgeInsets
    var image: UIImage
    var imageView = UIImageView()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.33)
        return view
    }()

    required init(image: UIImage, startFrame: CGRect, insets: UIEdgeInsets) {
        self.startFrame = startFrame
        self.insets = insets
        self.image = image
        super.init()
    }
}

extension MovieCardTransition: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension MovieCardTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
 
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let context = transitionContext.meta
 
        let screenBounds = UIScreen.main.bounds
        
        let toViewStartFrame = CGRect(x: screenBounds.minX + self.insets.left + 48.0,
                                      y: screenBounds.minY + self.insets.top + 48.0,
                                      width: screenBounds.width - self.insets.left - self.insets.right - 96.0,
                                      height: screenBounds.height - self.insets.top - self.insets.bottom - 96.0)
        
        if context.isPresenting {
        
            context.container.addSubview(shadowView)
            shadowView.frame = context.from.view.frame
            shadowView.alpha = 0.0
            
            context.container.addSubview((context.to.view)!)
            

            
            context.to.view.frame = toViewStartFrame
            context.to.view.alpha = 0.0
            
            imageView.frame = startFrame
            imageView.layer.cornerRadius = 8.0
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            context.container.addSubview(imageView)
            
            context.to.view.layoutIfNeeded()
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0.0,
                           usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0001,
                           options: .curveEaseInOut, animations: {
                            
                    let newFrame = CGRect(x: screenBounds.minX + self.insets.left,
                                      y: screenBounds.minY + self.insets.top,
                                      width: screenBounds.width - self.insets.left - self.insets.right,
                                      height: screenBounds.height - self.insets.top - self.insets.bottom)
                
                    context.to.view.frame = newFrame
                    context.to.view.alpha = 1.0
                    context.to.view.layer.cornerRadius = 8.0
                    context.to.view.layer.masksToBounds = true
                    self.shadowView.alpha = 1.0
                
                    context.to.view.layoutIfNeeded()
                
                    if let movieCard = (context.to as? MovieCardViewController) {
                        let imageView = movieCard.moviePosterImageView!
                        let newImageFrame = imageView.convert(imageView.bounds, to: UIApplication.shared.keyWindow!)
                        self.imageView.frame = newImageFrame
                }
                }, completion: { (finished) in
                    if let movieCard = (context.to as? MovieCardViewController) {
                        movieCard.moviePosterImageView.image = self.image
                    }
                    self.imageView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })

            return
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            context.from.view.alpha = 0.0
            self.shadowView.alpha = 0.0
            }) { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
