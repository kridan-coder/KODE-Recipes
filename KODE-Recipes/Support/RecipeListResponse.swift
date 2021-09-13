//
//  RecipeListResponse.swift
//  KODE-Recipes
//
//  Created by Developer on 07.09.2021.
//

import Foundation

struct RecipeListResponse: Decodable {
    let recipes: [RecipeListElement]
    
    enum CodingKeys: String, CodingKey {
        case recipes
      }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        recipes = (try? values.decode([RecipeListElement].self, forKey: .recipes)) ?? []
    }
    
}
