//
//  Repository.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation

class Repository{
    
    var apiClient: ApiClient?
    var databaseClient: DatabaseClient?
    
    init(apiClient: ApiClient, databaseClient: DatabaseClient) {
        self.apiClient = apiClient
        self.databaseClient = databaseClient
    }
    
}
