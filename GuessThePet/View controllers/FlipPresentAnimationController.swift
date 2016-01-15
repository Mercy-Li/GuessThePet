//
//  FlipPresentAnimationController.swift
//  GuessThePet
//
//  Created by 李潇 on 16/1/14.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

import UIKit

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var originFrame = CGRect.zero

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }

        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrameForViewController(toVC)

        let snapshot = toVC.view.snapshotViewAfterScreenUpdates(true)
        snapshot.frame = initialFrame
        snapshot.layer.cornerRadius = 25
        snapshot.layer.masksToBounds = true

        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.hidden = true

        AnimationHelper.perspectiveTransformForContainerView(containerView)
        snapshot.layer.transform = AnimationHelper.yRotation(M_PI_2)

        let duration = transitionDuration(transitionContext)

        UIView.animateKeyframesWithDuration(duration, delay: 0, options: .CalculationModeCubic, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/3, animations: { () -> Void in
                fromVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)
            })

            UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: { () -> Void in
                snapshot.layer.transform = AnimationHelper.yRotation(0.0)
            })

            UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: { () -> Void in
                snapshot.frame = finalFrame
            })
            }) { (_) -> Void in
                toVC.view.hidden = false
                fromVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}
