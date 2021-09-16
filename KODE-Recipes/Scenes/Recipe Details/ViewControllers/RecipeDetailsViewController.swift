//
//  RecipeDetailsViewController.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import UIKit
import Kingfisher

class RecipeDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var contentView: RecipeDetailsView {
        return view as? RecipeDetailsView ?? RecipeDetailsView()
    }
    // TODO: - Get rid of implicitly unwrapped optional
    var viewModel: RecipeDetailsViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecipeImagesCollectionView()
        setupRecipeImagesRecommendationsCollectionView()
        bindToViewModel()
        viewModel.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            viewModel.viewWillDisappear()
        }
    }
    
    override func loadView() {
        view = RecipeDetailsView()
    }
    
    // MARK: - Public Methods
    
    func setupRecipeData(recipe: RecipeDataForDetails) {
        contentView.pageControl.numberOfPages = recipe.imageLinks.count
        contentView.recipeNameLabel.text = recipe.name
        contentView.instructionTextLabel.text = recipe.instructions
        contentView.descriptionTextLabel.text = recipe.description
        contentView.timestampLabel.text = recipe.lastUpdated
        contentView.difficultyTitleLabel.text = Constants.difficulty
        contentView.instructionTitleLabel.text = Constants.instructions
        contentView.recommendedTitleLabel.text = Constants.recommended
        
        for _ in 0..<recipe.difficultyLevel {
            let image = UIImage.difficultyTrue
            let imageView = UIImageView(image: image)
            contentView.difficultyImagesCollection.addArrangedSubview(imageView)
        }
        
        for _ in recipe.difficultyLevel..<5 {
            let image = UIImage.difficultyFalse
            let imageView = UIImageView(image: image)
            contentView.difficultyImagesCollection.addArrangedSubview(imageView)
        }
        
        contentView.recipeImagesCollectionView.reloadData()
    }
    
    // MARK: Actions
    
    @objc func refresh() {
        viewModel.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func setupRecipeImagesCollectionView() {
        contentView.recipeImagesCollectionView.delegate = self
        contentView.recipeImagesCollectionView.dataSource = self
        ImageCollectionViewCellViewModel.registerCell(collectionView: self.contentView.recipeImagesCollectionView)
        contentView.recipeImagesCollectionView.reloadData()
    }
    
    private func setupRecipeImagesRecommendationsCollectionView() {
        contentView.recommendationImagesCollectionView.delegate = self
        contentView.recommendationImagesCollectionView.dataSource = self
        RecommendedCollectionViewCell.registerCell(collectionView: self.contentView.recommendationImagesCollectionView)
    }
    
    // ViewModel
    private func bindToViewModel() {
        viewModel.didStartUpdating = { [weak self] in
            self?.viewModelDidStartUpdating()
        }
        viewModel.didFinishUpdating = { [weak self] in
            self?.viewModelDidFinishUpdating()
        }
        viewModel.didReceiveError = { [weak self] error in
            self?.viewModelDidReceiveError(error: error)
        }
    }
    
    private func viewModelDidStartUpdating() {
        // TODO: - add logic on starting update
    }
    
    private func viewModelDidFinishUpdating() {
        if let recipe = viewModel.recipe {
            setupRecipeData(recipe: recipe)
            contentView.recipeImagesCollectionView.reloadData()
        }
    }
    
    private func viewModelDidReceiveError(error: String) {
        let alert = UIAlertController(title: Constants.ErrorType.basic, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.AlertActionTitle.ok, style: .default))
        present(alert, animated: true)
    }
    
}

extension RecipeDetailsViewController: UICollectionViewDelegate {
    
    // TODO: Not sure that this function is a nice decision. Need to rethink and make it work faster
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentView.recipeImagesCollectionView.frame.size.width != 0 {
            contentView.pageControl.currentPage = Int(scrollView.contentOffset.x / contentView.recipeImagesCollectionView.frame.size.width)
        }
    }
}

extension RecipeDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == contentView.recipeImagesCollectionView {
            return viewModel.recipeImages.count
        } else {
            return viewModel.recipeRecommendationImages.count
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == contentView.recipeImagesCollectionView {
            return viewModel.recipeImages[indexPath.row].dequeueCell(collectionView: collectionView, indexPath: indexPath)
        } else {
            return viewModel.recipeRecommendationImages[indexPath.row].dequeueCell(collectionView: collectionView, indexPath: indexPath)
        }
        
    }
    
}

extension RecipeDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentView.recipeImagesCollectionView {
            return collectionView.frame.size
        } else {
            var newSize = CGSize()
            newSize.width = (self.view.frame.width / 3) * 2
            newSize.height = collectionView.frame.height
            return newSize
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == contentView.recipeImagesCollectionView {
            return Constants.spaceRecipeImages
        } else {
            return Constants.spaceRecipeRecommendations
        }
        
    }
    
}

private extension Constants {
    static let spaceRecipeImages = CGFloat(0)
    static let spaceRecipeRecommendations = CGFloat(20)
    static let difficulty = "Difficulty: "
    static let instructions = "Instruction: "
    static let recommended = "Recommended: "
}

private extension UIImage {
    static var difficultyTrue: UIImage {
        return UIImage(named: "DifficultyTrue") ?? UIImage()
    }
    static var difficultyFalse: UIImage {
        return UIImage(named: "DifficultyFalse") ?? UIImage()
    }
}
