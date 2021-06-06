//
//  RecipesContainerR.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation
import RealmSwift

class RecipesContainerDC: Object{
    var recipes = List<RecipeDC>()
}
