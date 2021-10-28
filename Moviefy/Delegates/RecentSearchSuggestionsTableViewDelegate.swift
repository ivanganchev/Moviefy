//
//  RecentSearchesTableViewDelegate.swift
//  Moviefy
//
//  Created by A-Team Intern on 22.10.21.
//

import UIKit

class RecentSearchSuggestionsTableViewDelegate: NSObject, UITableViewDelegate {
    var getSelectedSuggestionIndex: ((_ index: Int) -> Void)?
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getSelectedSuggestionIndex?(indexPath.row)
    }
}
