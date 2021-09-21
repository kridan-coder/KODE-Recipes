//
//  RecipeViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

protocol RecipeViewModelCoordinatorDelegate: AnyObject {
    func viewWillDisappear()
}

final class RecipeDetailsViewModel {
    
    // MARK: - Properties
    
    weak var coordinatorDelegate: RecipeViewModelCoordinatorDelegate?
    
    var images: [ImageCollectionViewCellViewModel] = []
    
    var recipeImages: [ImageCollectionViewCellViewModel] = []
    
    var recipeRecommendationImages: [RecommendedImageCollectionViewCellViewModel] = []
    
    var recipe: RecipeDataForDetails? {
        didSet {
            recipeImages = recipe?.imageLinks.map { viewModelForMain(imageLink: $0) } ?? []
            recipeRecommendationImages = recipe?.similarRecipes?.map { viewModelForRecommended(name: $0.name, imageLink: $0.imageLink) } ?? []
        }
    }
    
    private let repository: Repository
    
    private let recipeID: String
    
    // MARK: - Actions
    
    var didReceiveError: ((Error) -> Void)?
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    
    // MARK: - Init
    
    init(repository: Repository, recipeID: String) {
        self.repository = repository
        self.recipeID = recipeID
    }
    
    // MARK: - Public Methods
    
    func reloadData() {
        self.didStartUpdating?()
        getDataFromNetwork()
    }
    
    func viewWillDisappear() {
        coordinatorDelegate?.viewWillDisappear()
    }
    
    // MARK: - Private Methods
    
    init(repository: Repository, recipeID: String) {
        self.repository = repository
        self.recipeID = recipeID
    }
    
    // MARK: Helpers
    
    private func viewModelForMain(imageLink: String) -> ImageCollectionViewCellViewModel {
        ImageCollectionViewCellViewModel(imageLink: imageLink)
    }
    
    private func viewModelForRecommended(name: String, imageLink: String) -> RecommendedImageCollectionViewCellViewModel {
        RecommendedImageCollectionViewCellViewModel(name: name, imageLink: imageLink)
    private func getDataFromNetwork() {
        repository.apiClient?.getRecipe(uuid: recipeID) { [weak self] response in
            
            switch response {
            case .success(let recipeContainer):
                self?.recipe = self?.repository.recipeAPIToRecipeForDetails(recipeContainer.recipe)
                self?.didFinishUpdating?()
                
            case .failure(let error):
                self?.didReceiveError?(error)
            }
            
        }
    }
    
    private func getDataFromNetwork() {
        // TODO: - Get rid of dummy
        recipe = RecipeDataForDetails(recipeID: "123-123-1sad-21asd-23ws-12", name: "Chicken Caramelized French Onion Dip", imageLinks: [
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/tomato-puff-pastry-bites-3.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/tomato-puff-pastry-bites-bc48c5.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/tomato-puff-pastry-bites-4.jpg"
        ], lastUpdated: "14.02.2001", description: "If you like tomatoes, you will love this little appetizer. You can make one or as many as you like. Great way to use some garden fresh tomatoes. You can easily sprinkle some feta cheese and olives after they are baked.", instructions: "Preheat oven to 425 deg. Cut tomato slices. You don't want them to be too thin and yet you don't want them to be too thick either. Set aside.  Cut puff pastry into small squares that are roughly about the same size as your tomato slices. Place some parchment paper on a cookie sheet. Lay the puff pastry square on the parchment paper. Add about 1 TBS +/- of Jack cheese (or provolone, gouda, havarti, mozzarella). Add some sliced/chopped onion. I had some green onion from the garden and use the white tip only. But, you can easily add regular onion. Place a tomato slice on top. Add a pinch of Italian seasoning. Season with salt and pepper, if you like. If you are going to add feta cheese later, you might not need to add any salt. Bake in a preheated 425 oven for about 10-12 minutes. Please check them... you want them golden brown and nicely puffed. Depending on the puff pastry size, the cooking time will vary. Mine took 12 minutes. Sprinkle feta on top if you like.", difficultyLevel: 4, similarRecipes: [RecipeBrief(recipeID: "123-123-1sad-21asd-23ws-12", name: "Chicken Caramelized French Onion Dip", imageLink: "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/antipasto-skewers-2.jpg"), RecipeBrief(recipeID: "123-123-1sad-21asd-23ws-12", name: "Loaf", imageLink: "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/savory-pita-chips-4.jpg"), RecipeBrief(recipeID: "123-123-1sad-21asd-23ws-12", name: "Steak", imageLink: "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/tomato-puff-pastry-bites-bc48c5.jpg"), RecipeBrief(recipeID: "123-123-1sad-21asd-23ws-12", name: "Pasta", imageLink: "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/caramelized-french-onion-dip.jpg")])
        didFinishUpdating?()
    }

}
