//
//  RecentSearchSuggestionsDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 21.10.21.
//

import Foundation
import UIKit
import RealmSwift

class RecentSearchSuggestionsDataSource: NSObject {
    var suggestions = [SuggestionEntity]()
    var token: NotificationToken?
    
    var deleteSearchTextButtonTap: (() -> Void)?
    
    func loadSavedSuggestions() {
        let realm = try? Realm()
        guard let results = realm?.objects(SuggestionEntity.self) else {
            return
        }
        self.suggestions = Array(results)
    }
    
    func registerNotificatonToken(completion: @escaping (RealmCollectionChange<Results<SuggestionEntity>>) -> Void) {
        self.token?.invalidate()
        let realm = try? Realm()
        guard let results = realm?.objects(SuggestionEntity.self) else {
            return
        }
        
        self.token = results.observe {(changes: RealmCollectionChange) in
            completion(changes)
        }
    }
    
    func saveSearchText(text: String) {
        do {
            let realm = try Realm()

            let suggestion = SuggestionEntity(suggestion: text)
            try realm.write({
                realm.add(suggestion)
            })
        } catch let err {
            print(err)
        }
    }
    
    func deleteSearchText(index: Int) {
        guard index < self.suggestions.count, let id = self.suggestions[index].id else {
            return
        }
        
        do {
            let realm = try Realm()
            
            if let suggestionEntity = realm.object(ofType: SuggestionEntity.self, forPrimaryKey: id) {
                try realm.write({
                    realm.delete(suggestionEntity)
                })
            }
        } catch let err {
            print(err)
        }
    }
}

extension RecentSearchSuggestionsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchSuggestionsTableViewCell.identifier, for: indexPath) as? RecentSearchSuggestionsTableViewCell else {
            return RecentSearchSuggestionsTableViewCell()
        }
        
        cell.textSuggestion.text = suggestions[indexPath.row].suggestion
        cell.deleteButton.deleteAction = { _ in
            self.deleteSearchText(index: indexPath.row)
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
