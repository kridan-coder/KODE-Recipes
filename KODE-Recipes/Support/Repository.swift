//
//  Repository.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation
import SystemConfiguration
import UIKit
//import RealmSwift

final class Repository {
    
    // MARK: Public
    
    var apiClient: ApiClient?
    //var databaseClient: DatabaseClient?
    
    // MARK: Lifecycle
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
        //self.databaseClient = databaseClient
    }
    
    // MARK: Actions
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let result = (isReachable && !needsConnection)
        
        return result
    }
    
    // converting
    
//    func recipeDCToRecipeForDetails(_ recipeDC: RecipeDataForDC) -> RecipeDataForDetails {
//        return recipeRawToRecipeForDetails(recipeDCtoRecipeRaw(recipeDC))
//    }
    
//    func recipeDCToRecipeForCell(_ recipeDC: RecipeDataForDC) -> RecipeDataForCell {
//        return recipeToRecipeForCell(recipeDCtoRecipeRaw(recipeDC))
//    }
    
    func recipeACToRecipeForCell(_ recipeAC: RecipeDataForAC) -> RecipeDataForCell {
        return recipeToRecipeForCell(recipeACtoRecipeRaw(recipeAC))
    }
    
    func recipeRawToRecipeForDetails(_ recipe: RecipeDataRaw) -> RecipeDataForDetails {
        let date = getDateForRecipeDetails(lastUpdated: recipe.lastUpdated)
        
        // description may be not provided or it can be empty
        var description = recipe.description
        if description == nil || description == "" {
            description = Constants.Description.empty
        }
        
        let difficultyImage = getDifficultyImage(difficultyLevel: recipe.difficulty)
        
        return RecipeDataForDetails(recipeID: recipe.recipeID, name: recipe.name, imageLinks: recipe.imageLinks, lastUpdated: date, description: description!, instructions: recipe.instructions, difficultyImage: difficultyImage)
    }
    
    func recipeToRecipeForCell(_ recipe: RecipeDataRaw) -> RecipeDataForCell {
        
        let imageLink = recipe.imageLinks[0]
        
        let date = getDateForRecipeCell(lastUpdated: recipe.lastUpdated)
        
        return RecipeDataForCell(recipeID: recipe.recipeID, name: recipe.name, imageLink: imageLink, lastUpdated: date, description: recipe.description, instructions: recipe.instructions)
    }
    
    func recipeACtoRecipeRaw(_ recipeAC: RecipeDataForAC) -> RecipeDataRaw {
        return RecipeDataRaw(recipeID: recipeAC.uuid!, name: formatText(recipeAC.name!)!, imageLinks: recipeAC.images!, lastUpdated: recipeAC.lastUpdated!, description: formatText(recipeAC.description), instructions: formatText(recipeAC.instructions!)!, difficulty: recipeAC.difficulty!)
    }
    
//    func recipeDCtoRecipeRaw(_ recipeDC: RecipeDataForDC) -> RecipeDataRaw {
//        return RecipeDataRaw(recipeID: recipeDC.uuid!, name: formatText(recipeDC.name!)!, imageLinks: Array(recipeDC.images), lastUpdated: recipeDC.lastUpdated.value!, description: formatText(recipeDC.recipeDescription), instructions: formatText(recipeDC.instructions!)!, difficulty: recipeDC.difficulty.value!)
//    }
    
//    func recipeACtoRecipeDC(_ recipeAC: RecipeDataForAC) -> RecipeDataForDC {
//        let recipeDC = RecipeDataForDC()
//        recipeDC.difficulty.value = recipeAC.difficulty
//        recipeDC.images = List<String>()
//        if let images = recipeAC.images {
//            for link in images {
//                recipeDC.images.append(link)
//            }
//        }
//        recipeDC.instructions = recipeAC.instructions
//        recipeDC.lastUpdated.value = recipeAC.lastUpdated
//        recipeDC.name = recipeAC.name
//        recipeDC.recipeDescription = recipeAC.description
//        recipeDC.uuid = recipeAC.uuid
//        return recipeDC
//    }
    
    // filtering and sorting
    
    func filterRecipesForSearchText(recipes: [RecipeTableViewCellViewModel], searchText: String?, scope: SearchCase? = SearchCase.all) -> [RecipeTableViewCellViewModel] {
        guard let safeSearchText = searchText, safeSearchText != "" else {
            return recipes
        }
        
        var mutableRecipes = recipes
        
        switch scope {
        case .name:
            mutableRecipes = recipes.filter { (recipe) -> Bool in
                recipe.data.name.lowercased().contains(safeSearchText.lowercased())
            }
        case .description:
            // if description is not provided then no need to search anything in it
            mutableRecipes = recipes.filter { (recipe) -> Bool in
                (recipe.data.description?.lowercased().contains(safeSearchText.lowercased()) ?? false)
            }
        case .instruction:
            mutableRecipes = recipes.filter { (recipe) -> Bool in
                recipe.data.instructions.lowercased().contains(safeSearchText.lowercased())
            }
        default:
            mutableRecipes = recipes.filter { (recipe) -> Bool in
                recipe.data.name.lowercased().contains(safeSearchText.lowercased()) ||
                    
                    (recipe.data.description?.lowercased().contains(safeSearchText.lowercased()) ?? false) ||
                    
                    recipe.data.instructions.lowercased().contains(safeSearchText.lowercased())
            }
        }
        
        return mutableRecipes
    }
    
    func sortRecipesBy(sortCase: SortCase, recipes: [RecipeTableViewCellViewModel]) -> [RecipeTableViewCellViewModel] {
        var mutableRecipes = recipes
        
        switch sortCase {
        case .name:
            mutableRecipes.sort { first, second in
                return first.data.name < second.data.name
            }
        case .date:
            mutableRecipes.sort { first, second in
                return first.data.lastUpdated > second.data.lastUpdated
            }
        }
        
        return mutableRecipes
    }
    
    
    // MARK: Helpers
    
    private func formatText(_ text: String?) -> String? {
        guard let text = text else {
            return nil
        }
        return text.replacingOccurrences(of: "<br>", with: "\n")
    }
    
    private func getDateForRecipeCell(lastUpdated: Double) -> String {
        let date = Date(timeIntervalSince1970: lastUpdated)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return Constants.DateDummy.recipeCell + formatter.string(from: date)
    }
    
    private func getDateForRecipeDetails(lastUpdated: Double) -> String {
        let date = Date(timeIntervalSince1970: lastUpdated)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a, EEEE, MMM d, yyyy"
        return Constants.DateDummy.recipeDetails + formatter.string(from: date)
    }
    
    private func getDifficultyImage(difficultyLevel: Int) -> UIImage? {
        switch difficultyLevel {
        case 1:
            return UIImage.BaseTheme.Difficulty.easy
        case 2:
            return UIImage.BaseTheme.Difficulty.normal
        case 3:
            return UIImage.BaseTheme.Difficulty.hard
        case 4:
            return UIImage.BaseTheme.Difficulty.extreme
        case 5:
            return UIImage.BaseTheme.Difficulty.insane
        default:
            return UIImage.BaseTheme.Difficulty.unknown
        }
    }
    
}
