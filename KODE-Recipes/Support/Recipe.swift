//
//  Recipe.swift
//  KODE-Recipes
//
//  Created by Developer on 06.09.2021.
//

import Foundation

struct Recipe: Decodable {
    let uuid: String
    let name: String
    let images: [String]
    let lastUpdated: Double?
    let description: String?
    let instructions: String?
    let difficulty: Int
    let similar: [RecipeBrief]
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case images
        case lastUpdated
        case description
        case instructions
        case difficulty
        case similar
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decode(String.self, forKey: .uuid)
        name = try values.decode(String.self, forKey: .name)
        images = (try? values.decode([String].self, forKey: .images)) ?? []
        lastUpdated = try values.decode(Double.self, forKey: .lastUpdated)
        description = try? values.decode(String.self, forKey: .description)
        instructions = try? values.decode(String.self, forKey: .instructions)
        difficulty = try values.decode(Int.self, forKey: .difficulty)
        similar = (try? values.decode([RecipeBrief].self, forKey: .similar)) ?? []
    }
    
}
