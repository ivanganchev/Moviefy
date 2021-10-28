//
//  TransitionAnimator.swift
//  Moviefy
//
//  Created by A-Team Intern on 10.09.21.
//

import UIKit

enum PresentationType {
    case present
    case dismiss

    var isPresenting: Bool {
        return self == .present
    }
}

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    static let duration: TimeInterval = 0.5

    private let presentationType: PresentationType
    private let initialAnimatableContent: InitialTransitionAnimatableContent
    private let presentedAnimatableContent: PresentedTransitionAnimatableContent
    private var selectedCellImageViewSnapshot: UIView
    private let cellImageViewRect: CGRect

    init?(type: PresentationType, initialAnimatableContent: InitialTransitionAnimatableContent, presentedAnimatableContent: PresentedTransitionAnimatableContent, selectedCellImageViewSnapshot: UIView) {
        self.presentationType = type
        self.initialAnimatableContent = initialAnimatableContent
        self.presentedAnimatableContent = presentedAnimatableContent
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot

        guard let window = initialAnimatableContent.view.window ?? presentedAnimatableContent.view.window,
            let selectedCellImageView = initialAnimatableContent.selectedCellImageView
            else { return nil }

        self.cellImageViewRect = selectedCellImageView.convert(selectedCellImageView.bounds, to: window)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = self.presentedAnimatableContent.view
            else {
                transitionContext.completeTransition(false)
                return
        }

        containerView.addSubview(toView)
        
        guard let selectedCellImageView = initialAnimatableContent.selectedCellImageView,
              let window = initialAnimatableContent.view.window ?? presentedAnimatableContent.view.window,
              let cellImageSnapshot = selectedCellImageView.snapshotView(afterScreenUpdates: true),
              let controllerImageSnapshot = presentedAnimatableContent.movieImageView.snapshotView(afterScreenUpdates: true)
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let isPresenting = presentationType.isPresenting
        
        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = presentedAnimatableContent.view.backgroundColor
        
        if isPresenting {
            self.selectedCellImageViewSnapshot = cellImageSnapshot
            
            backgroundView = UIView(frame: containerView.bounds)
            backgroundView.addSubview(fadeView)
            fadeView.alpha = 0
        } else {
            backgroundView = initialAnimatableContent.view.snapshotView(afterScreenUpdates: true) ?? fadeView
            backgroundView.addSubview(fadeView)
        }
        
        toView.alpha = 0
        
        [backgroundView, selectedCellImageViewSnapshot, controllerImageSnapshot].forEach {
            containerView.addSubview($0)
        }
        
        let controllerImageViewRect = presentedAnimatableContent.movieImageView.convert(presentedAnimatableContent.movieImageView.bounds, to: window)
        
        [self.selectedCellImageViewSnapshot, controllerImageSnapshot].forEach {
            $0.frame = (isPresenting ? cellImageViewRect : controllerImageViewRect)
        }
        	
        controllerImageSnapshot.alpha = isPresenting ? 0 : 1
        
        self.selectedCellImageViewSnapshot.alpha = isPresenting ? 1 : 0
        
        UIView.animateKeyframes(withDuration: TransitionAnimator.duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.selectedCellImageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                controllerImageSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                fadeView.alpha = isPresenting ? 1 : 0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                self.selectedCellImageViewSnapshot.alpha = isPresenting ? 0 : 1
                controllerImageSnapshot.alpha = isPresenting ? 1 : 0
            }
        }, completion: { _ in
            self.selectedCellImageViewSnapshot.removeFromSuperview()
            controllerImageSnapshot.removeFromSuperview()
            
            backgroundView.removeFromSuperview()
            
            toView.alpha = 1
            
            transitionContext.completeTransition(true)
        })
    }
}
