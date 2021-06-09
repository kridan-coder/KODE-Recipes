//
//  DatabaseClient.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation
import RealmSwift

// Database Client is just a class. No need to use singleton in MVVM-C architectural pattern.

final class DatabaseClient {
    
    private static let realm = try! Realm()
    
    func saveObject<T: Object>(_ object: T) {
        try! DatabaseClient.realm.write {
            DatabaseClient.realm.add(object, update: .modified)
        }
    }
    
    func saveObjects<T: Object>(_ objects: [T]) {
        try! DatabaseClient.realm.write {
            DatabaseClient.realm.add(objects, update: .modified)
        }
    }
    
    func getObjects<T: Object>(ofType: T.Type, filter: String? = nil) -> [T] {
        let result = (filter != nil) ? DatabaseClient.realm.objects(T.self).filter(filter!) : DatabaseClient.realm.objects(T.self)
        return Array(result)
    }
    
    func getObjectByPrimaryKey<T: Object>(ofType: T.Type, primaryKey: String) -> T? {
        DatabaseClient.realm.object(ofType: T.self, forPrimaryKey: primaryKey)
    }
    
}
