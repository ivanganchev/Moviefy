//
//  IndicatorCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 5.10.21.
//

import Foundation
import UIKit

class IndicatorFooter: UICollectionReusableView {
    static let identifier = "IndicatorFooter"
    
    var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.addSubview(self.indicator)
//        NSLayoutConstraint.activate([
//                self.indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//                self.indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
