//
//  SearchSuggestionsBackButton.swift
//  Moviefy
//
//  Created by A-Team Intern on 3.11.21.
//

import UIKit

class SearchSuggestionsBackButton: UIButton {
    var areSuggestionsVisible: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
