//
//  ZoomTransitionAnimator.swift
//  View Polish
//
//  Created by Stephen Anthony on 19/01/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import UIKit

/*!
The transition types that the animator can provide.
- ZoomIn:  A Zoom In animation
- ZoomOut: A Zoom Out animation
*/
enum ZoomTransitionAnimatorType {
    case zoomIn
    case zoomOut
}

/// The animator object responsible for providing zoom in and out transition animation
class ZoomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate let zoomRect: CGRect
    fileprivate let zoomType: ZoomTransitionAnimatorType
    
    init(zoomRect: CGRect, zoomType: ZoomTransitionAnimatorType) {
        self.zoomRect = zoomRect
        self.zoomType = zoomType
        super.init()
    }
    
    //MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        switch self.zoomType {
        case .zoomIn:
            animateZoomInFromView(fromView, toView: toView, transitionContext: transitionContext)
        case .zoomOut:
            animateZoomOutFromView(fromView, toView: toView, transitionContext: transitionContext)
        }
    }
    
    //MARK: Private Methods
    func animateZoomInFromView(_ fromView: UIView, toView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        // Configure the toView frame and centre
        toView.frame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!)
        toView.center = self.zoomRect.centre
        
        // Configure the toView transform and alpha
        toView.transform = CGAffineTransform.transformForTransitioningFromSize(zoomRect.size, toSize: toView.frame.size)
        toView.alpha = 0.0
        transitionContext.containerView.addSubview(toView)
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.78, initialSpringVelocity: 0.08, options: UIViewAnimationOptions(), animations: { () -> Void in
            toView.center = transitionContext.containerView.center
            toView.transform = CGAffineTransform.identity
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        // Perform the fade in of the toView
        UIView.animate(withDuration: animationDuration * 0.1, animations: { () -> Void in
            toView.alpha = 1.0;
        }) 
    }
    
    func animateZoomOutFromView(_ fromView: UIView, toView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        // Configure the to view frame
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        toView.frame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!)
        
        let zoomRectSize = zoomRect.size
        let animationDuration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.78, initialSpringVelocity: 0.08, options: UIViewAnimationOptions(), animations: { () -> Void in
            // Animate the fromView back to the zoomRect
            fromView.transform = CGAffineTransform.transformForTransitioningFromSize(zoomRectSize, toSize: fromView.frame.size)
            fromView.center = self.zoomRect.centre
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        // Perform the fade out of the fromView
        let alphaAnimationDuration = animationDuration * 0.7
        UIView.animate(withDuration: alphaAnimationDuration, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            fromView.alpha = 0.0;
            }, completion: nil)
    }
}

extension CGAffineTransform {
    static func transformForTransitioningFromSize(_ fromSize: CGSize, toSize: CGSize) -> CGAffineTransform {
        return CGAffineTransform(scaleX: fromSize.width / toSize.width, y: fromSize.height / toSize.height)
    }
}

extension CGRect {
    var centre: CGPoint {
        get {
            return CGPoint(x: self.origin.x + (self.width / 2), y: self.origin.y + (self.height / 2))
        }
    }
}
