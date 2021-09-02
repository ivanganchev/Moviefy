//
//  MoviesTableViewDelegate.swift
//  Moviefy
//
//  Created by A-Team Intern on 2.09.21.
//

import Foundation
import UIKit

class MoviesTableViewDelegate: NSObject, UITableViewDelegate {
    var moviesSections: [String] = ["Top Rated", "Popular", "Upcoming", "Now Playing"]
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        let label = UILabel(frame: CGRect(x: 10, y: -12, width: tableView.frame.width, height: 30))
        label.text = self.moviesSections[section]
        
        label.font = UIFont(name: "Helvetica-Bold", size: 24)
        label.textColor = .black
        
        view.addSubview(label)
        
        return view
    }
    
    
}
