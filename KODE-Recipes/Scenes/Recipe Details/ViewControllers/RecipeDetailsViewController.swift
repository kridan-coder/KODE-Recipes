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
    
    let alertView: ErrorPageView
    
    var contentView: RecipeDetailsView {
        return view as? RecipeDetailsView ?? RecipeDetailsView()
    }
    
    let viewModel: RecipeDetailsViewModel
    
    // MARK: - Init
    init(viewModel: RecipeDetailsViewModel) {
        self.viewModel = viewModel
        alertView = ErrorPageView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecipeImagesCollectionView()
        setupRecipeImagesRecommendationsCollectionView()
        bindToViewModel()
        viewModel.reloadData()
        
        setupCustomAlert(alertView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            removeCustomAlert(alertView)
            viewModel.viewWillDisappear()
        }
    }
    
    override func loadView() {
        view = RecipeDetailsView()
    }
    
    // MARK: - Public Methods
    
    func setupRecipeData(recipe: RecipeDataForDetails) {
        if recipe.imageLinks.count < 2 {
            contentView.pageControl.isHidden = true
        } else {
            contentView.pageControl.isHidden = false
            contentView.pageControl.numberOfPages = recipe.imageLinks.count
        }
        
        if recipe.similarRecipes.isEmpty {
            contentView.recommendedTitleLabel.isHidden = true
            contentView.recommendationImagesCollectionView.isHidden = true
        } else {
            contentView.recommendedTitleLabel.isHidden = false
            contentView.recommendedTitleLabel.text = Constants.recommended
            
            contentView.recommendationImagesCollectionView.isHidden = false
            contentView.recommendationImagesCollectionView.reloadData()
        }
        
        contentView.recipeNameLabel.text = recipe.name
        contentView.instructionTextLabel.text = recipe.instructions
        contentView.descriptionTextLabel.text = recipe.description
        contentView.timestampLabel.text = recipe.lastUpdated
        contentView.difficultyTitleLabel.text = Constants.difficulty
        contentView.instructionTitleLabel.text = Constants.instructions
        
        contentView.difficultyView.difficulty = recipe.difficultyLevel
        
        contentView.recipeImagesCollectionView.reloadData()
        
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
            self?.didStartUpdating()
        }
        viewModel.didFinishUpdating = { [weak self] in
            self?.didFinishUpdating()
        }
        viewModel.didReceiveError = { [weak self] error in
            self?.didReceiveError(error)
        }
    }
    
    private func didFinishSuccessfully() {
        hideCustomAlert(alertView)
    }
    
    private func didStartUpdating() {
        // TODO: - Add some logic later
    }
    
    private func didFinishUpdating() {
        if let recipe = viewModel.recipe {
            setupRecipeData(recipe: recipe)
            contentView.recipeImagesCollectionView.reloadData()
            hideCustomAlert(alertView)
        }
    }
    
    private func didReceiveError(_ error: Error) {
        let title: String
        if let customError = error as? CustomError {
            title = customError.errorTitle
        } else {
            title = Constants.ErrorType.basic
        }
        
        showCustomAlert(alertView,
                        title: title,
                        message: error.localizedDescription,
                        buttonText: Constants.ButtonTitle.refresh)
    }
    
}

// MARK: - CustomAlertDisplaying Protocol

extension RecipeDetailsViewController: CustomAlertDisplaying {
    func handleButtonTap() {
        viewModel.reloadData()
    }
    
}

// MARK: - CollectionView Delegate

extension RecipeDetailsViewController: UICollectionViewDelegate {
    // TODO: - Not sure that this function is a nice decision. Need to rethink and make it work faster
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentView.recipeImagesCollectionView.frame.size.width != 0 {
            contentView.pageControl.currentPage =
                Int(scrollView.contentOffset.x / contentView.recipeImagesCollectionView.frame.size.width)
        }
    }
}

// MARK: - CollectionView DataSource

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

// MARK: - CollectionView FlowLayout

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == contentView.recommendationImagesCollectionView {
            viewModel.recipeRecommendationImages[indexPath.row].cellSelected()
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
