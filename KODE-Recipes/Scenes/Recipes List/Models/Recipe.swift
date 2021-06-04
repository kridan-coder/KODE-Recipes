//
//  Recipe.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation

struct Recipe {
    var name: String
    var imageLinks: [String]
    var lastUpdated: Date
    var description: String?
    var instructions: String
    var difficulty: Int
}
