//
//  TransitionAnimatableContent.swift
//  Moviefy
//
//  Created by A-Team Intern on 29.09.21.
//

import Foundation
import UIKit

protocol TransitionAnimatableContent: UIViewController{
    var selectedCellImageView: UIImageView? {get set}
    var selectedCellImageViewSnapshot: UIView? {get set}
}

