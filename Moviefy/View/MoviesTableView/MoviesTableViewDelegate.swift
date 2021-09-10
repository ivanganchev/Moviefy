//
//  MoviesTableViewDelegate.swift
//  Moviefy
//
//  Created by A-Team Intern on 2.09.21.
//

import Foundation
import UIKit

protocol MoviesTableViewButtonTapDelegate {
    func switchView(path: MovieCategoryEndPoint)
}

class MoviesTableViewDelegate: NSObject, UITableViewDelegate {
    var moviesSections: [String] = ["Top Rated", "Popular", "Upcoming", "Now Playing"]
    var delegate: MoviesTableViewButtonTapDelegate?
    var movieCategoryCases: [MovieCategoryEndPoint] = MovieCategoryEndPoint.allCases
    var path: MovieCategoryEndPoint?
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        view.backgroundColor = .white
        
        let label = UILabel(frame: .zero)
        label.text = self.moviesSections[section]
        label.font = UIFont(name: "Helvetica-Bold", size: 26)
        label.textColor = .black
        label.center.y = view.center.y
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(frame: .zero)
        button.setTitle("See all", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Light", size: 18)
        button.setTitleColor(.systemBlue, for: .normal)
        button.center.y = view.center.y
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(MoviesTableViewDelegate.headerButtonTapped), for: .touchUpInside)
        button.tag = section
        
        view.addSubview(label)
        view.addSubview(button)
        
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        label.center.y = view.center.y
        button.leadingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        button.center.y = view.center.y
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat.leastNormalMagnitude
//    }
    
    @objc func headerButtonTapped(sender:UIButton) {
        delegate?.switchView(path: self.movieCategoryCases[sender.tag])
    }
}
