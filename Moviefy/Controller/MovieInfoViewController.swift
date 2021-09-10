//
//  MovieInfoViewController.swift
//  Moviefy
//
//  Created by A-Team Intern on 7.09.21.
//

import UIKit

class MovieInfoViewController: UIViewController {

    var movie: Movie?
    var movieTitle: UILabel?
    var movieImage: UIImageView?
    var shadowView: UIView?
    var closeButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.movieImage = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 250))
        self.movieImage?.image = UIImage(data: (self.movie?.imageData)!)
        
        self.shadowView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        let gradient = CAGradientLayer()
        gradient.frame = self.shadowView!.bounds
        gradient.colors = [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.black.withAlphaComponent(0.2).cgColor, UIColor.black.withAlphaComponent(0.0).cgColor]
        gradient.locations = [0.0, 0.4, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.shadowView?.layer.addSublayer(gradient)
        
        self.closeButton = UIButton(type: .custom)
        self.closeButton?.setImage(UIImage(systemName: "xmark"), for: .normal)
        self.closeButton?.imageView?.contentMode = .scaleAspectFit
        self.closeButton?.contentHorizontalAlignment = .fill
        self.closeButton?.contentVerticalAlignment = .fill
        self.closeButton?.tintColor = .white
        self.closeButton?.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton?.addTarget(self, action: #selector(MovieInfoViewController.closeButtonTap), for: .touchUpInside)
        self.closeButton?.isUserInteractionEnabled = true
        
        self.shadowView?.addSubview(self.closeButton!)
        self.view.addSubview(self.movieImage!)
        self.view.addSubview(self.shadowView!)
        
        self.closeButton?.centerYAnchor.constraint(equalTo: self.shadowView!.centerYAnchor).isActive = true
        self.closeButton?.leadingAnchor.constraint(equalTo: self.shadowView!.leadingAnchor, constant: 20).isActive = true
        self.closeButton?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.closeButton?.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    @objc func closeButtonTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
