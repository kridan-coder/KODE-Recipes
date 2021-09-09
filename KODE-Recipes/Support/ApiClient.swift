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
    
    private let baseURL = Constants.API.baseURL
    
    func getRecipes(onSuccess: @escaping (RecipesContainerForAC) -> Void, onFailure: @escaping (String) -> Void) {
        AF.request(baseURL, method: .get).response { response in
            switch response.result {
            
            case .failure(let error):
                onFailure(error.errorDescription ?? Constants.ErrorText.basic)
                
            case .success(let data):
                guard let safeData = data else {
                    onFailure(Constants.ErrorText.basic)
                    return
                }
                
                do {
                    let recipesContainerAC = try JSONDecoder().decode(RecipesContainerForAC.self, from: safeData)
                    onSuccess(recipesContainerAC)
                }
                catch {
                    onFailure(Constants.ErrorText.basic + error.localizedDescription)
                }
                
            }
        }
    }
    
}
