//
//  RecentSearchSuggestionCloseButton.swift
//  Moviefy
//
//  Created by A-Team Intern on 25.10.21.
//

import UIKit

class CustomDeleteButton: UIButton {
    var clickAction: ((_ sender: CustomDeleteButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteAction(_ sender: CustomDeleteButton) {
        clickAction?(sender)
    }
}
