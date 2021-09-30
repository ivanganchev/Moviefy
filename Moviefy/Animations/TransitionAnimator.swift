//
//  TransitionAnimator.swift
//  Moviefy
//
//  Created by A-Team Intern on 10.09.21.
//

import Foundation
import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    static let duration: TimeInterval = 0.5

    private let type: PresentationType
    private let firstViewController: TransitionAnimatableContent
    private let movieInfoViewController: MovieInfoViewController
    private var selectedCellImageViewSnapshot: UIView
    private let cellImageViewRect: CGRect

    init?(type: PresentationType, firstViewController: TransitionAnimatableContent, movieInfoViewController: MovieInfoViewController, selectedCellImageViewSnapshot: UIView) {
        self.type = type
        self.firstViewController = firstViewController
        self.movieInfoViewController = movieInfoViewController
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot

        guard let window = firstViewController.view.window ?? movieInfoViewController.view.window,
            let selectedCellImageView = firstViewController.selectedCellImageView
            else { return nil }

        self.cellImageViewRect = selectedCellImageView.convert(selectedCellImageView.bounds, to: window)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = self.movieInfoViewController.view
            else {
                transitionContext.completeTransition(false)
                return
        }

        containerView.addSubview(toView)
        
        guard let selectedCellImageView = firstViewController.selectedCellImageView,
              let window = firstViewController.view.window ?? movieInfoViewController.view.window,
              let cellImageSnapshot = selectedCellImageView.snapshotView(afterScreenUpdates: true),
              let controllerImageSnapshot = movieInfoViewController.movieImage.snapshotView(afterScreenUpdates: true)
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let isPresenting = type.isPresenting
        
        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = movieInfoViewController.view.backgroundColor
        
        if isPresenting {
            self.selectedCellImageViewSnapshot = cellImageSnapshot
            
            backgroundView = UIView(frame: containerView.bounds)
            backgroundView.addSubview(fadeView)
            fadeView.alpha = 0
        } else {
            backgroundView = firstViewController.view.snapshotView(afterScreenUpdates: true) ?? fadeView
            backgroundView.addSubview(fadeView)
        }
        
        toView.alpha = 0
        
        [backgroundView, selectedCellImageViewSnapshot, controllerImageSnapshot].forEach{
            containerView.addSubview($0)
        }
        
        let controllerImageViewRect = movieInfoViewController.movieImage.convert(movieInfoViewController.movieImage.bounds, to: window)
        
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

    enum PresentationType {

        case present
        case dismiss

        var isPresenting: Bool {
            return self == .present
        }
}

