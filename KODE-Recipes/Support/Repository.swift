//
//  Repository.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation
import RealmSwift

final class Repository {
    
    // MARK: Public
    
    var apiClient: ApiClient?
    
    // MARK: Lifecycle
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    // MARK: Actions
    
    // converting
    
    func recipeAPIToRecipeForDetails(_ recipe: RecipeListElement) -> RecipeDataForDetails {
        return recipeRawToRecipeForDetails(recipeAPItoRecipeRaw(recipe))
    }
    
    func recipeAPIToRecipeForCell(_ recipe: RecipeListElement) -> RecipeDataForCell {
        return recipeRawToRecipeForCell(recipeAPItoRecipeRaw(recipe))
    }
    
    private func recipeRawToRecipeForDetails(_ recipe: RecipeDataRaw) -> RecipeDataForDetails {
        let date = getDateForRecipeDetails(lastUpdated: recipe.lastUpdated)
        
        // description may be not provided or it can be empty
        var description = recipe.description
        if description == nil || description == "" {
            description = Constants.Description.empty
        }
        
        let difficultyImage = getDifficultyImage(difficultyLevel: recipe.difficulty)
        
        return RecipeDataForDetails(recipeID: recipe.recipeID, name: recipe.name, imageLinks: recipe.imageLinks, lastUpdated: date, description: description!, instructions: recipe.instructions, difficultyImage: difficultyImage)
    }
    
    private func recipeRawToRecipeForCell(_ recipe: RecipeDataRaw) -> RecipeDataForCell {
        
        let imageLink = recipe.imageLinks[0]
        
        let date = getDateForRecipeCell(lastUpdated: recipe.lastUpdated)
        
        return RecipeDataForCell(recipeID: recipe.recipeID, name: recipe.name, imageLink: imageLink, lastUpdated: date, description: recipe.description, instructions: recipe.instructions)
    }
    
    private func recipeAPItoRecipeRaw(_ recipeAC: RecipeListElement) -> RecipeDataRaw {
        return RecipeDataRaw(recipeID: recipeAC.uuid, name: formatText(recipeAC.name), imageLinks: recipeAC.images, lastUpdated: recipeAC.lastUpdated, description: formatText(recipeAC.description), instructions: formatText(recipeAC.instructions), difficulty: recipeAC.difficulty)
    }
    
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
            mutableRecipes.sort { x, y in
                return x.data.name < y.data.name
            }
        case .date:
            mutableRecipes.sort { x, y in
                return x.data.lastUpdated > y.data.lastUpdated
            }
        }
        
        return mutableRecipes
    }
    
    
    // MARK: Helpers
    
    private func formatText(_ text: String?) -> String {
        return text?.replacingOccurrences(of: "<br>", with: "\n") ?? ""
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
