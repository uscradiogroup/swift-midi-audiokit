//
//  MDFadeAnimator.swift
//  Moodles
//
//  Created by VladislavEmets on 12/16/16.
//  Copyright © 2016 USC Radio Group. All rights reserved.
//

import Foundation


class MDFadeInAnimator:
    NSObject,
    UIViewControllerAnimatedTransitioning {

    static let fadeoutDuration = 0.5
    static let fadeinDuration = 0.3
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toVC = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.to)
        let fromVC = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.from)
        
        toVC?.view.frame = transitionContext.finalFrame(for: toVC!)
        toVC!.view.alpha = 0.0
        fromVC!.view.alpha = 1.0
        
        UIView.animate(withDuration: MDFadeInAnimator.fadeoutDuration, animations: {
            fromVC!.view.alpha = 0.0
        }, completion: { finished in
            containerView.addSubview(toVC!.view)
            UIView.animate(withDuration: MDFadeInAnimator.fadeinDuration, animations: {
                toVC!.view.alpha = 1.0
            }, completion: { finished in
                let cancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!cancelled)
            })
            
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }

}
