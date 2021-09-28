//
//  MoviesCollectionViewCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 29.08.21.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    static let identifier = "MoviesCollectionViewCell"
    
    var data: Data? {
        didSet {
            DispatchQueue.main.async {
                self.myImageView.image = UIImage(data: self.data!)
            }
        }
    }
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(myImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        var ratio = 0.0
        let orientation = UIDevice.current.orientation
        switch orientation {
            case .portrait:
                ratio = 0.33
            case .portraitUpsideDown:
                ratio = 0.33
            case .landscapeLeft:
                ratio = 0.33 / 2
            case .landscapeRight:
                ratio = 0.33 / 2
            default:
                ratio = 0
        }
        let width = UIScreen.main.bounds.width * CGFloat(ratio)
        let height = width * (750 / 500)
        DispatchQueue.main.async {
            self.myImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
    }
}
