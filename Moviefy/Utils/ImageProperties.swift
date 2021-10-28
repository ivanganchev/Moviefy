//
//  ThumbnailImageProperties.swift
//  Moviefy
//
//  Created by A-Team Intern on 28.09.21.
//

import UIKit

class ImageProperties {
    static let imageWidth: CGFloat = 500.0
    static let imageHeight: CGFloat = 750.0
    
    static func getThumbnailImageSize() -> CGSize {
        let width = UIScreen.main.bounds.width * CGFloat(self.getThumbNailImageRatio())
        let height = width * (imageHeight / imageWidth)
        
        return CGSize(width: width, height: height)
    }
    
    static func getThumbNailImageRatio() -> Double {
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
