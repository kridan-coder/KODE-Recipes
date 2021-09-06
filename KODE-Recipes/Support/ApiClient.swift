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
    
    func getAllRecipes(onSuccess: @escaping ([RecipeListElement]?) -> Void, onFailure: @escaping (String) -> Void) {
        AF.request(baseURL + "recipes", method: .get).response { response in
            switch response.result {
            
            case .failure(let error):
                onFailure(error.errorDescription ?? Constants.ErrorText.unhandledRequestFailure)
                
            case .success(let data):
                guard let safeData = data else {
                    onFailure(Constants.ErrorText.emptyResponse)
                    return
                }
                
                do {
                    let recipeList = try JSONDecoder().decode([RecipeListElement].self, from: safeData)
                    onSuccess(recipeList)
                }
                catch {
                    onFailure(Constants.ErrorText.decodingFailure + error.localizedDescription)
                }
                
            }
        }
    }
    
    func getRecipe(uuid: String, onSuccess: @escaping (Recipe?) -> Void, onFailure: @escaping (String) -> Void) {
        AF.request(baseURL + "recipes/" + uuid, method: .get).response { response in
            switch response.result {
            
            case .failure(let error):
                onFailure(error.errorDescription ?? Constants.ErrorText.unhandledRequestFailure)
                
            case .success(let data):
                guard let safeData = data else {
                    onFailure(Constants.ErrorText.emptyResponse)
                    return
                }
                
                do {
                    let recipe = try JSONDecoder().decode(Recipe.self, from: safeData)
                    onSuccess(recipe)
                }
                catch {
                    onFailure(Constants.ErrorText.decodingFailure + error.localizedDescription)
                }
                
            }
        }
    }
    
}
