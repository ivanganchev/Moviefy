//
//  RecentSearchesTableViewDelegate.swift
//  Moviefy
//
//  Created by A-Team Intern on 22.10.21.
//

import Foundation
import UIKit

class RecentSearchSuggestionsTableViewDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
