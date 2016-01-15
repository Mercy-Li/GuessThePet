//
//  SwipeInteractionController.swift
//  GuessThePet
//
//  Created by 李潇 on 16/1/14.
//  Copyright © 2016年 Razeware LLC. All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!

    func wireToViewController(viewController: UIViewController!) {
        self.viewController = viewController
        prepareGestureRecognizerInView(viewController.view)
    }

    private func prepareGestureRecognizerInView(view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleGesture:")
        gesture.edges = UIRectEdge.Left
        view.addGestureRecognizer(gesture)
    }

    func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translationInView(gestureRecognizer.view!.superview!)
        var progress = translation.x / 200
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

        switch gestureRecognizer.state {
        case .Began:
            interactionInProgress = true
            viewController.dismissViewControllerAnimated(true, completion: nil)

        case .Changed:
            shouldCompleteTransition = progress > 0.5
            updateInteractiveTransition(progress)

        case .Cancelled:
            interactionInProgress = false
            cancelInteractiveTransition()

        case .Ended:
            interactionInProgress = false

            if !shouldCompleteTransition {
                cancelInteractiveTransition()
            } else {
                finishInteractiveTransition()
            }

        default:
            print("Unsuppported")
        }
    }
}
