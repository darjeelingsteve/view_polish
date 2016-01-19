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
    case ZoomIn
    case ZoomOut
}

/// The animator object responsible for providing zoom in and out transition animation
class ZoomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let zoomRect: CGRect
    private let zoomType: ZoomTransitionAnimatorType
    
    init(zoomRect: CGRect, zoomType: ZoomTransitionAnimatorType) {
        self.zoomRect = zoomRect
        self.zoomType = zoomType
        super.init()
    }
    
    //MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        switch self.zoomType {
        case .ZoomIn:
            animateZoomInFromView(fromView, toView: toView, transitionContext: transitionContext)
        case .ZoomOut:
            animateZoomOutFromView(fromView, toView: toView, transitionContext: transitionContext)
        }
    }
    
    //MARK: Private Methods
    func animateZoomInFromView(fromView: UIView, toView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        // Configure the toView frame and centre
        toView.frame = transitionContext.finalFrameForViewController(transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        toView.center = self.zoomRect.centre
        
        // Configure the toView transform and alpha
        toView.transform = CGAffineTransform.transformForTransitioningFromSize(zoomRect.size, toSize: toView.frame.size)
        toView.alpha = 0.0
        transitionContext.containerView()!.addSubview(toView)
        
        let animationDuration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.78, initialSpringVelocity: 0.08, options: .CurveEaseInOut, animations: { () -> Void in
            toView.center = transitionContext.containerView()!.center
            toView.transform = CGAffineTransformIdentity
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
        // Perform the fade in of the toView
        UIView.animateWithDuration(animationDuration * 0.1) { () -> Void in
            toView.alpha = 1.0;
        }
    }
    
    func animateZoomOutFromView(fromView: UIView, toView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        // Configure the to view frame
        transitionContext.containerView()?.insertSubview(toView, belowSubview: fromView)
        toView.frame = transitionContext.finalFrameForViewController(transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        let zoomRectSize = zoomRect.size
        let animationDuration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.78, initialSpringVelocity: 0.08, options: .CurveEaseInOut, animations: { () -> Void in
            // Animate the fromView back to the zoomRect
            fromView.transform = CGAffineTransform.transformForTransitioningFromSize(zoomRectSize, toSize: fromView.frame.size)
            fromView.center = self.zoomRect.centre
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
        // Perform the fade out of the fromView
        let alphaAnimationDuration = animationDuration * 0.7
        UIView.animateWithDuration(alphaAnimationDuration, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            fromView.alpha = 0.0;
            }, completion: nil)
    }
}

extension CGAffineTransform {
    static func transformForTransitioningFromSize(fromSize: CGSize, toSize: CGSize) -> CGAffineTransform {
        return CGAffineTransformMakeScale(fromSize.width / toSize.width, fromSize.height / toSize.height)
    }
}

extension CGRect {
    var centre: CGPoint {
        get {
            return CGPoint(x: self.origin.x + (CGRectGetWidth(self) / 2), y: self.origin.y + (CGRectGetHeight(self) / 2))
        }
    }
}