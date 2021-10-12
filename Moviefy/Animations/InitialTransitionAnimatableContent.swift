//
//  TransitionAnimatableContent.swift
//  Moviefy
//
//  Created by A-Team Intern on 29.09.21.
//

import Foundation
import UIKit

protocol InitialTransitionAnimatableContent: UIViewController {
    var selectedCellImageView: UIImageView? { get }
    var selectedCellImageViewSnapshot: UIView? { get }
}
