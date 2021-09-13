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
    
    var imagesViewModels: [ImageCollectionViewCellViewModel] = []
    
    var recipe: RecipeDataForDetails? {
        didSet {
            imagesViewModels = recipe!.imageLinks.map { viewModelFor(imageLink: $0) }
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
        recipe = RecipeDataForDetails(recipeID: "123-123-1sad-21asd-23ws-12", name: "Chicken", imageLinks: [
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/tomato-puff-pastry-bites-3.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/tomato-puff-pastry-bites-bc48c5.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/tomato-puff-pastry-bites-4.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/swiss-cheese-fondue-1bb369.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/swiss-cheese-fondue.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/bloomin-onion-bread.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/royal-blend-chicken-salad-f2756c.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/lemon-artichoke-baked-orzo-a825b7.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/cinnamon-applesauce-pancakes-634671.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/crme-brle-rice-pudding-649fda.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/goat-cheese-stuffed-mini-portobello.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/holiday-brussels-sprouts.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/deviled-eggs-12.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/deviledeggs-6747ac.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/garlic-chicken-bites.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/bruschetta-10.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/bruschetta-41.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/bruschetta-44.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/bruschetta-45.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/untitled-recipe-4667.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/baked-asparagus-with-parmesan--99fa77.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/spinach-artichoke-dip-4.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/spinach-artichoke-dip-42.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/spinach-artichoke-dip-45.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/appetizer-candied-nuts.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/brown-rice-and-black-bean-burr-ae246c.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/rice-and-turkey-stuffed-pepper-668dbb.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/italian-sushi-77727b.jpg",
            "https://bigoven-res.cloudinary.com/image/upload/t_recipe-256/spicy-salmon-avocado-tower-ec8598.jpg"
        ], lastUpdated: "14.02.2001", description: "If you like tomatoes, you will love this little appetizer. You can make one or as many as you like. Great way to use some garden fresh tomatoes. You can easily sprinkle some feta cheese and olives after they are baked.", instructions: "Preheat oven to 425 deg. Cut tomato slices. You don't want them to be too thin and yet you don't want them to be too thick either. Set aside.  Cut puff pastry into small squares that are roughly about the same size as your tomato slices. Place some parchment paper on a cookie sheet. Lay the puff pastry square on the parchment paper. Add about 1 TBS +/- of Jack cheese (or provolone, gouda, havarti, mozzarella). Add some sliced/chopped onion. I had some green onion from the garden and use the white tip only. But, you can easily add regular onion. Place a tomato slice on top. Add a pinch of Italian seasoning. Season with salt and pepper, if you like. If you are going to add feta cheese later, you might not need to add any salt. Bake in a preheated 425 oven for about 10-12 minutes. Please check them... you want them golden brown and nicely puffed. Depending on the puff pastry size, the cooking time will vary. Mine took 12 minutes. Sprinkle feta on top if you like.", difficultyImage: nil)
        didFinishUpdating?()
    }

    
}
