//
//  Values.swift
//  KODE-Recipes
//
//  Created by KriDan on 09.06.2021.
//

import Foundation
import UIKit

enum Constants {
    
    enum Design {
        static let cornerRadiusMain = CGFloat(15)
        static let cornerRadiusSecondary = CGFloat(5)
        static let borderWidthMain = CGFloat(2)
        static let borderWidthSecondary = CGFloat(1)
    }
    
    enum API {
        static let baseURL = "https://test.kode-t.ru/recipes.json"
    }
    
    enum AlertActionTitle {
        static let ok = "OK"
    }
    
    enum NavigationBarTitle {
        static let recipes = "Recipes"
        static let recipeDetails = "RecipeDetails"
    }
    
    enum ErrorType {
        static let basic = "Error"
        static let noInternet = "No Internet connection"
    }
    
    enum ErrorText {
        static let decodingFailure = "Failed to decode data. "
        static let emptyResponse = "Response is empty. "
        static let unhandledRequestFailure = "Unexpected error while making a request. "
        static let noInternetTable = "Local saves will be shown (if there are any). Please connect to the Internet and refresh the table. "
        static let recipesListIsEmpty = "Recipes list is empty. "
        static let recipeDetailsAreEmpty = "Recipe Details could not be loaded. "
    }
    
    enum Description {
        static let empty = "No description provided."
    }
    
    enum DateDummy {
        static let recipeCell = "Last update: "
        static let recipeDetails = "Last Recipe Update:\n"
    }
    
}
