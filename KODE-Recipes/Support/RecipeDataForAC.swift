//
//  RecipeAC.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation

struct RecipSeListElement: Decodable {
    var uuid: String? = nil
    var name: String? = nil
    var images: [String]? = nil
    var lastUpdated: Double? = nil
    var description: String? = nil
    var instructions: String? = nil
    var difficulty: Int? = nil
}
