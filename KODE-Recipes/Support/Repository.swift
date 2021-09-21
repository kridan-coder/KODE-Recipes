//
//  Repository.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import SystemConfiguration
import UIKit

final class Repository {
    
    // MARK: Public
    
    var apiClient: ApiClient?
    
    // MARK: Lifecycle
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    // MARK: Actions
    
    // converting
    
    func recipeToRecipeForDetails(_ recipe: Recipe) -> RecipeDataForDetails {
        let date = getDateForRecipeDetails(lastUpdated: recipe.lastUpdated)
        
        // description may be not provided or it can be empty
        let description = recipe.description ?? Constants.Description.empty
        
        return RecipeDataForDetails(recipeID: recipe.uuid,
                                    name: formatText(recipe.name),
                                    imageLinks: recipe.images,
                                    lastUpdated: date,
                                    description: description,
                                    instructions: formatText(recipe.instructions),
                                    difficultyLevel: recipe.difficulty,
                                    similarRecipes: recipe.similar)
        
    }
    
    func recipeListElementToRecipeForCell(_ recipe: RecipeListElement) -> RecipeDataForCell {
        return recipeRawToRecipeForCell(recipeListElementToRecipeRaw(recipe))
    }
    
    private func recipeRawToRecipeForCell(_ recipe: RecipeDataRaw) -> RecipeDataForCell {
        
        let imageLink = recipe.imageLinks[0]
        
        let date = getDateForRecipeDetails(lastUpdated: recipe.lastUpdated)
        
        return RecipeDataForCell(recipeID: recipe.recipeID, name: recipe.name, imageLink: imageLink, lastUpdated: date, description: recipe.description, instructions: recipe.instructions, date: recipe.lastUpdated)
    }
    
    private func recipeListElementToRecipeRaw(_ recipe: RecipeListElement) -> RecipeDataRaw {
        return RecipeDataRaw(recipeID: recipe.uuid, name: formatText(recipe.name), imageLinks: recipe.images, lastUpdated: recipe.lastUpdated, description: formatText(recipe.description), instructions: formatText(recipe.instructions), difficulty: recipe.difficulty)
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
    
    private func formatText(_ text: String?) -> String {
        return text?.replacingOccurrences(of: "<br>", with: "\n") ?? ""
    }
    
    private func getDateForRecipeDetails(lastUpdated: Double?) -> String {
        if let safeLastUpdated = lastUpdated {
            let date = Date(timeIntervalSince1970: safeLastUpdated)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: date)
        } else {
            return ""
        }

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
