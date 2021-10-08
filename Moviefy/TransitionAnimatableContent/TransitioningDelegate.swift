//
//  SearchMoviesTransitionAnimatableContent.swift
//  Moviefy
//
//  Created by A-Team Intern on 7.10.21.
//

import Foundation
import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var transitionAnimator: TransitionAnimator?
    var initialTransitionAnimatableContent: InitialTransitionAnimatableContent?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.initialTransitionAnimatableContent = source as? InitialTransitionAnimatableContent
        guard let initialTransitionAnimatableContent = self.initialTransitionAnimatableContent,
                let movieInfoViewController = presented as? PresentedTransitionAnimatableContent,
                let selectedCellImageViewSnapshot = self.initialTransitionAnimatableContent?.selectedCellImageViewSnapshot
                else { return nil }

        self.transitionAnimator = TransitionAnimator(type: .present, initialAnimatableContent: self.initialTransitionAnimatableContent!, presentedAnimatableContent: movieInfoViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return self.transitionAnimator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let movieInfoViewController = dismissed as? PresentedTransitionAnimatableContent,
              let selectedCellImageViewSnapshot = self.initialTransitionAnimatableContent?.selectedCellImageViewSnapshot
            else { return nil }

        self.transitionAnimator = TransitionAnimator(type: .dismiss, initialAnimatableContent: self.initialTransitionAnimatableContent!, presentedAnimatableContent: movieInfoViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return self.transitionAnimator
    }
}
