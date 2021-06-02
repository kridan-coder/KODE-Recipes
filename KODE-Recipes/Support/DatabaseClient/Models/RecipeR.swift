//
//  RecipeR.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation
import RealmSwift

class RecipeR: Object {
    @objc dynamic var uuid: String? = nil
    @objc dynamic var name: String? = nil
    var images = List<String>()
    @objc dynamic var lastUpdated: Date? = nil
    @objc dynamic var recipeDescription: String? = nil
    @objc dynamic var instructions: String? = nil
    var difficulty = RealmOptional<Int>()
}
