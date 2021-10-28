//
//  SuggestionEntity.swift
//  Moviefy
//
//  Created by A-Team Intern on 22.10.21.
//

import Foundation
import RealmSwift

class SuggestionEntity: Object {
    @Persisted(primaryKey: true) var id: String?
    @Persisted var suggestion: String
    
    convenience init(suggestion: String) {
        self.init()
        
        self.id = UUID().uuidString
        self.suggestion = suggestion
    }
}
