//
//  ThumbnailImageProperties.swift
//  Moviefy
//
//  Created by A-Team Intern on 28.09.21.
//

import Foundation
import UIKit

class ThumbnailImageProperties {
    static func getSize() -> CGSize {
        let width = UIScreen.main.bounds.width * CGFloat(self.getRatio())
        let height = width * (750 / 500)
        
        return CGSize(width: width, height: height)
    }
    
    static func getRatio() -> Double {
        var ratio: Double
        let size = UIScreen.main.bounds.size
        
        if size.width < size.height {
            ratio = 0.33
        } else {
            ratio = 0.33 / 2
        }
        
        return ratio
    }
}
