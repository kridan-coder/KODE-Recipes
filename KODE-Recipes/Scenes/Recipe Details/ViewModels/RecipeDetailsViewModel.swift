//
//  RecipeViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

protocol RecipeViewModelCoordinatorDelegate: class {
    func viewWillDisappear()
}

final class RecipeDetailsViewModel {
    
    // MARK: Private
    
    private let repository: Repository
    
    private let recipeID: String
    
    // MARK: Delegates
    
    weak var coordinatorDelegate: RecipeViewModelCoordinatorDelegate?
    
    // MARK: Properties
    
    var recipeImages: [ImageCollectionViewCellViewModel] = []
    
    var recipe: RecipeDataForDetails? {
        didSet {
            recipeImages = recipe!.imageLinks.map { viewModelFor(imageLink: $0) }
        }
    }
    
    // MARK: Actions
    
    var didReceiveError: ((String) -> Void)?
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    
    // MARK: Service
    
    func reloadData() {
        self.didStartUpdating?()
        getDataFromNetwork()
    }
    
    func viewWillDisappear() {
        coordinatorDelegate?.viewWillDisappear()
    }
    
    // MARK: Lifecycle
    
    init(repository: Repository, recipeID: String) {
        self.repository = repository
        self.recipeID = recipeID
    }
    
    // MARK: Helpers
    
    private func viewModelFor(imageLink: String) -> ImageCollectionViewCellViewModel {
        ImageCollectionViewCellViewModel(imageLink: imageLink)
    }
    
    private func getDataFromNetwork() {
        recipe = RecipeDataForDetails(recipeID: "123-123-1sad-21asd-23ws-12", name: "Chicken Caramelized French Onion Dip", imageLinks: [
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/tomato-puff-pastry-bites-3.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/tomato-puff-pastry-bites-bc48c5.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/tomato-puff-pastry-bites-4.jpg"
        ], lastUpdated: "14.02.2001", description: "If you like tomatoes, you will love this little appetizer. You can make one or as many as you like. Great way to use some garden fresh tomatoes. You can easily sprinkle some feta cheese and olives after they are baked.", instructions: "Preheat oven to 425 deg. Cut tomato slices. You don't want them to be too thin and yet you don't want them to be too thick either. Set aside.  Cut puff pastry into small squares that are roughly about the same size as your tomato slices. Place some parchment paper on a cookie sheet. Lay the puff pastry square on the parchment paper. Add about 1 TBS +/- of Jack cheese (or provolone, gouda, havarti, mozzarella). Add some sliced/chopped onion. I had some green onion from the garden and use the white tip only. But, you can easily add regular onion. Place a tomato slice on top. Add a pinch of Italian seasoning. Season with salt and pepper, if you like. If you are going to add feta cheese later, you might not need to add any salt. Bake in a preheated 425 oven for about 10-12 minutes. Please check them... you want them golden brown and nicely puffed. Depending on the puff pastry size, the cooking time will vary. Mine took 12 minutes. Sprinkle feta on top if you like.", difficultyImage: nil)
        didFinishUpdating?()
    }

    
}
