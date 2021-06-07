//
//  ApiClient.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation
import Alamofire

// API Client is just a class. No need to use singleton in MVVM-C architectural pattern.

final class ApiClient {
    
    private let baseURL = "https://test.kode-t.ru/recipes.json"
    
    func getRecipes(onSuccess: @escaping (RecipesContainerAC) -> Void, onFailure: @escaping (String) -> Void) {
        AF.request(baseURL, method: .get).response { response in
            switch response.result {
            
            case .failure(let error):
                onFailure(error.errorDescription ?? "Unhandled error while requesting Recipes List.")
                
            case .success(let data):
                guard let safeData = data else {
                    onFailure("Error: response is empty.")
                    return
                }
                onSuccess(try! JSONDecoder().decode(RecipesContainerAC.self, from: safeData))
            }
        }
    }
    
}
