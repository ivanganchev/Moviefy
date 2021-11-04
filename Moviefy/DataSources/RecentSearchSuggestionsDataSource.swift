//
//  RecentSearchSuggestionsDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 21.10.21.
//

import UIKit
import RealmSwift

class RecentSearchSuggestionsDataSource: NSObject {
    private var suggestions = [SuggestionEntity]()
    private var token: NotificationToken?
    
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
        guard let realm = try? Realm() else {
            return
        }
        
        let results = realm.objects(SuggestionEntity.self)
        self.token = results.observe {(changes: RealmCollectionChange) in
            completion(changes)
        }
    }
    
    func saveSearchText(text: String) {
        let suggestion = SuggestionEntity(suggestion: text)
        guard RealmWriteTransactionHelper.filterRealmObject(entityType: SuggestionEntity.self, predicate: NSPredicate(format: "suggestion == %@", text)) == nil else {
           return
        }
        RealmWriteTransactionHelper.realmAdd(entity: suggestion)
    }
    
    func deleteSearchTextAt(index: Int) {
        guard index < self.suggestions.count, let id = self.getSuggestion(at: index)?.id else {
            return
        }
        
        guard let suggestionEntity = RealmWriteTransactionHelper.getRealmObject(primaryKey: id, entityType: SuggestionEntity.self) else {
            return
        }
        RealmWriteTransactionHelper.realmDelete(entity: suggestionEntity)
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
        
        cell.textSuggestion.text = self.getSuggestion(at: indexPath.row)?.suggestion
        cell.deleteButton.clickAction = { _ in
            self.deleteSearchTextAt(index: indexPath.row)
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension RecentSearchSuggestionsDataSource {
    func getSuggestion(at index: Int) -> SuggestionEntity? {
        if index < self.suggestions.count {
            return self.suggestions[index]
        }
        return nil
    }
}
