//
//  FlipDismissAnimationController.swift
//  GuessThePet
//
//  Created by 李潇 on 16/1/14.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

import UIKit

class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var destinatonFrame = CGRect.zero

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }

        let initialFrame = transitionContext.initialFrameForViewController(fromVC)
        let finalFrame = destinatonFrame

        let snapshot = fromVC.view.snapshotViewAfterScreenUpdates(false)
        snapshot.layer.cornerRadius = 25
        snapshot.layer.masksToBounds = true

        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        fromVC.view.hidden = true

        AnimationHelper.perspectiveTransformForContainerView(containerView)

        toVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)

        let duration = transitionDuration(transitionContext)

        UIView.animateKeyframesWithDuration(duration, delay: 0, options: .CalculationModeCubic, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1/3, animations: { () -> Void in
                snapshot.frame = finalFrame
            })
            UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: { () -> Void in
                snapshot.layer.transform = AnimationHelper.yRotation(M_PI_2)
            })
            UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: { () -> Void in
                toVC.view.layer.transform = AnimationHelper.yRotation(0)
            })
            }) { (_) -> Void in
                fromVC.view.hidden = false
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}
