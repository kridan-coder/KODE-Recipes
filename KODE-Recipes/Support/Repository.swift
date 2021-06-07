//
//  Repository.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation
import SystemConfiguration
import RealmSwift

final class Repository {
    
    // MARK: Public
    
    var apiClient: ApiClient?
    var databaseClient: DatabaseClient?
    
    // MARK: Lifecycle
    
    init(apiClient: ApiClient, databaseClient: DatabaseClient) {
        self.apiClient = apiClient
        self.databaseClient = databaseClient
    }
    
    // MARK: Actions
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
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
    
    func recipeACtoRecipe(_ recipeAC: RecipeAC) -> Recipe {
        return Recipe(name: formatText(recipeAC.name!)!, imageLinks: recipeAC.images!, lastUpdated: recipeAC.lastUpdated!, description: formatText(recipeAC.description), instructions: formatText(recipeAC.instructions!)!, difficulty: recipeAC.difficulty!)
    }
    
    func recipeDCtoRecipe(_ recipeDC: RecipeDC) -> Recipe {
        return Recipe(name: formatText(recipeDC.name!)!, imageLinks: Array(recipeDC.images), lastUpdated: recipeDC.lastUpdated.value!, description: formatText(recipeDC.recipeDescription), instructions: formatText(recipeDC.instructions!)!, difficulty: recipeDC.difficulty.value!)
    }
    
    func recipeACtoRecipeDC(_ recipeAC: RecipeAC) -> RecipeDC {
        let recipeDC = RecipeDC()
        recipeDC.difficulty.value = recipeAC.difficulty
        recipeDC.images = List<String>()
        if let images = recipeAC.images {
            for link in images {
                recipeDC.images.append(link)
            }
        }
        recipeDC.instructions = recipeAC.instructions
        recipeDC.lastUpdated.value = recipeAC.lastUpdated
        recipeDC.name = recipeAC.name
        recipeDC.recipeDescription = recipeAC.description
        recipeDC.uuid = recipeAC.uuid
        return recipeDC
    }
    
    func wrapRecipesDCIntoDatabaseContainer(_ recipesDC: [RecipeDC]) -> RecipesContainerDC {
        let container = RecipesContainerDC()
        for recipe in recipesDC {
            container.recipes.append(recipe)
        }
        return container
    }
    
    // filtering and sorting
    
    func filterRecipesForSearchText(recipes: [RecipeTableViewCellViewModel], searchText: String, scope: SearchCase? = SearchCase.all) -> [RecipeTableViewCellViewModel] {
        guard searchText != "" else {
            return recipes
        }
        
        var mutableRecipes = recipes
        
        switch scope {
        case .name:
            mutableRecipes = recipes.filter { (recipe) -> Bool in
                recipe.data.name.lowercased().contains(searchText.lowercased())
            }
        case .description:
            // if description is not provided then no need to search anything in it
            mutableRecipes = recipes.filter { (recipe) -> Bool in
                (recipe.data.description?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        case .instruction:
            mutableRecipes = recipes.filter { (recipe) -> Bool in
                recipe.data.instructions.lowercased().contains(searchText.lowercased())
            }
        default:
            mutableRecipes = recipes.filter { (recipe) -> Bool in
                recipe.data.name.lowercased().contains(searchText.lowercased()) ||
                    
                    (recipe.data.description?.lowercased().contains(searchText.lowercased()) ?? false) ||
                    
                    recipe.data.instructions.lowercased().contains(searchText.lowercased())
            }
        }
        
        return mutableRecipes
    }
    
    func sortRecipesBy(sortCase: SortCase, recipes: [RecipeTableViewCellViewModel]) -> [RecipeTableViewCellViewModel] {
        var safeRecipes = recipes
        
        switch sortCase {
        case .name:
            safeRecipes.sort { x, y in
                return x.data.name < y.data.name
            }
        case .date:
            safeRecipes.sort { x, y in
                return x.data.lastUpdated > y.data.lastUpdated
            }
        }
        
        return safeRecipes
    }
    
    
    // MARK: Helpers
    
    private func formatText(_ text: String?) -> String? {
        guard let text = text else {
            return nil
        }
        return text.replacingOccurrences(of: "<br>", with: "\n")
    }
    
}
