//
//  Values.swift
//  KODE-Recipes
//
//  Created by KriDan on 09.06.2021.
//

import Foundation
import UIKit


struct Constants {
    
    struct Design {
        static let cornerRadiusError = CGFloat(22)
        static let spacingMain = CGFloat(22)
        
        static let basicInset = CGFloat(20)
    
        static let cornerRadiusMain = CGFloat(15)
        static let cornerRadiusSecondary = CGFloat(5)
        static let borderWidthMain = CGFloat(2)
        static let borderWidthSecondary = CGFloat(1)
    }
    
    struct API {
        static let baseURL = "https://test.kode-t.ru/recipes.json"
    }
    
    struct NavigationBarTitle {
        static let recipes = "Recipes"
        static let recipeDetails = "RecipeDetails"
    }
    
    struct ErrorType {
        static let basic = "Something went wrong"
        static let noInternet = "No Internet"
    }
    
    struct ButtonTitle {
        static let refresh = "Refresh"
    }
    
    struct ErrorText {
        static let basic = "The problem is on our side, we are already looking into it. Please try refreshing the screen later."
        static let noInternet = "Try refreshing the screen when communication is restored."

    }
    
    struct Description {
        static let empty = "No description provided."
    }
    
    struct DateDummy {
        static let recipeCell = "Last update: "
        static let recipeDetails = "Last Recipe Update:\n"
    }
    
}
