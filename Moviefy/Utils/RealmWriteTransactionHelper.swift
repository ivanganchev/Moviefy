//
//  RealmWriteTransactionHelper.swift
//  Moviefy
//
//  Created by A-Team Intern on 26.10.21.
//

import Foundation
import RealmSwift

class RealmWriteTransactionHelper {
    private static func errorHandler(handle: () throws -> Void) {
        do {
            try handle()
        } catch let err {
            print(err)
        }
    }
    
    private static func realmWrite(write: () throws -> Void) {
        guard let realm = try? Realm() else { return }
        
        errorHandler {
            try realm.write({
                try write()
            })
        }
    }
    
    static func realmAdd(entity: Object) {
        guard let realm = try? Realm() else { return }
        
        realmWrite {
            realm.add(entity)
        }
    }
    
    static func realmDelete(entity: Object) {
        guard let realm = try? Realm() else { return }
        realmWrite {
                realm.delete(entity)
        }
    }
    
    static func getRealmObject(primaryKey: String, entityType: Object.Type) -> Object? {
        let realm = try? Realm()
        
        return realm?.object(ofType: entityType, forPrimaryKey: primaryKey)
    }
    
    static func filterRealmObject(entityType: Object.Type, predicate: NSPredicate) -> Object? {
        let realm = try? Realm()
        
        return realm?.objects(entityType).filter(predicate).first
    }
}
