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
    
    func setRecipesContainerToDatabase(_ data: RecipesContainerR) {
        try! DatabaseClient.realm.write {
            DatabaseClient.realm.add(data)
        }
        
    }
    
    func getRecipesContainerFromDatabase() -> RecipesContainerR? {
        let databaseData = DatabaseClient.realm.objects(RecipesContainerR.self)
        guard databaseData.count != 0 else {return nil}
        return databaseData[0]
    }
    
}
