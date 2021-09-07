//
//  ApiClient.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation
import Alamofire

struct APIRoutable: URLRequestConvertible {
    var baseURL: String = Constants.API.baseURL
    var path: String
    var method: HTTPMethod
    var parameters: Parameters?
    var encoding: ParameterEncoding
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
    
}

// API Client is just a class. No need to use singleton in MVVM-C architectural pattern.

final class ApiClient {

    // GENERIC method
    private func perform<T: Decodable>(_ apiRoute: APIRoutable, completion: @escaping (AFResult<T>) -> Void) {
        
        let dataRequest = AF.request(apiRoute)
    
        dataRequest
            .validate(statusCode: 200..<300)
            .responseDecodable {  (response: AFDataResponse<T>) in
                
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
        }
    
    func getAllRecipes(completion: @escaping (AFResult<RecipeListResponse>) -> Void) {
        let allRecipesRoute = APIRoutable(path: "recipes", method: .get, encoding: URLEncoding.default)
        perform(allRecipesRoute, completion: completion)
    }
    
    func getRecipe(uuid: String, completion: @escaping (AFResult<RecipeResponse>) -> Void) {
        let recipeRoute = APIRoutable(path: "recipes/" + uuid, method: .get, encoding: URLEncoding.default)
        perform(recipeRoute, completion: completion)
    }
    
}
