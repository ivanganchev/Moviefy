//
//  MoviesTableViewDelegate.swift
//  Moviefy
//
//  Created by A-Team Intern on 2.09.21.
//

import Foundation
import UIKit

class MoviesTableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
