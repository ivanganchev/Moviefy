//
//  RecentSearchSuggestionCloseButton.swift
//  Moviefy
//
//  Created by A-Team Intern on 25.10.21.
//

import Foundation
import UIKit

class RecentSearchSuggestionCloseButton: UIButton {
    var deleteAction: ((_ sender: RecentSearchSuggestionCloseButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteAction(_ sender: RecentSearchSuggestionCloseButton) {
        deleteAction?(sender)
    }
}
