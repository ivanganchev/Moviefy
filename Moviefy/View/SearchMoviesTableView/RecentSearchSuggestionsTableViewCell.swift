//
//  RecentSearchSuggestionsCell.swift
//  Moviefy
//
//  Created by A-Team Intern on 21.10.21.
//

import Foundation
import UIKit

class RecentSearchSuggestionsTableViewCell: UITableViewCell {
    static let identifier = "RecentSearchSuggestionsTableViewCell"
    
    let textSuggestion: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: "Helvetica", size: 20)
        text.tintColor = .black
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let deleteButton: RecentSearchSuggestionCloseButton = {
        let closeButton = RecentSearchSuggestionCloseButton(type: .custom)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.contentHorizontalAlignment = .fill
        closeButton.contentVerticalAlignment = .fill
        closeButton.tintColor = .red
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.isUserInteractionEnabled = true
        
        return closeButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.textSuggestion)
        self.contentView.addSubview(self.deleteButton)
        
        NSLayoutConstraint.activate([
            self.textSuggestion.topAnchor.constraint(equalTo: self.topAnchor),
            self.textSuggestion.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.textSuggestion.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            self.deleteButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.deleteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
