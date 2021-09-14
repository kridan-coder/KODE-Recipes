//
//  RecipeDetailsViewController.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import UIKit
import Kingfisher

class RecipeDetailsViewController: UIViewController {
    
    // MARK: IBOutlets
    
    //private let contentView = RecipeDetailsViewSK()
    //private let scrollView = UIScrollView()
    
    var contentView: RecipeDetailsViewSK {
        return view as? RecipeDetailsViewSK ?? RecipeDetailsViewSK()
    }

    override func loadView() {
        view = RecipeDetailsViewSK()
    }
    
    
    // MARK: Elements set in code
    
  
    
    // MARK: Public
    
    var viewModel: RecipeDetailsViewModel!
    

    
    // MARK: Helpers
    

    
    private func setupCollectionView() {
        contentView.recipeImagesCollectionView.delegate = self
        contentView.recipeImagesCollectionView.dataSource = self
        ImageCollectionViewCellViewModel.registerCell(collectionView: self.contentView.recipeImagesCollectionView)
        contentView.recipeImagesCollectionView.reloadData()
    }
    
    private func setupAppearance() {
//        difficultyLevelImage.layer.cornerRadius = Constants.Design.cornerRadiusMain
//        difficultyLevelImage.layer.borderWidth = Constants.Design.borderWidthSecondary
//        difficultyLevelImage.layer.borderColor = UIColor.BaseTheme.tableBackground?.cgColor
//        instructionsTextView.layer.cornerRadius = Constants.Design.cornerRadiusMain
//        descriptionTextView.layer.cornerRadius = Constants.Design.cornerRadiusMain
//        refreshControl.tintColor = UIColor.BaseTheme.pageControlMain
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupCollectionView()
        bindToViewModel()
        viewModel.reloadData()
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            viewModel.viewWillDisappear()
        }
    }
    
    // MARK: Actions
    
    @objc func refresh() {
        viewModel.reloadData()
    }
    
    func setupRecipeData(recipe: RecipeDataForDetails) {
        contentView.pageControl.numberOfPages = recipe.imageLinks.count
        contentView.recipeNameLabel.text = recipe.name
        contentView.instructionTextLabel.text = recipe.instructions
        contentView.descriptionTextLabel.text = recipe.description
        contentView.timestampLabel.text = recipe.lastUpdated
        contentView.difficultyTitleLabel.text = "Difficulty"
        contentView.instructionTitleLabel.text = "Instructions"
        contentView.recommendedTitleLabel.text = "Recommendations"
        let image1 = UIImage(named: "DifficultyTrue")
        let imageView1 = UIImageView(image: image1)
        
        let image2 = UIImage(named: "DifficultyTrue")
        let imageView2 = UIImageView(image: image2)
        
        let image3 = UIImage(named: "DifficultyTrue")
        let imageView3 = UIImageView(image: image3)
        
        let image4 = UIImage(named: "DifficultyFalse")
        let imageView4 = UIImageView(image: image4)
        
        let image5 = UIImage(named: "DifficultyFalse")
        let imageView5 = UIImageView(image: image5)
        
        contentView.difficultyImagesCollection.addArrangedSubview(imageView1)
        contentView.difficultyImagesCollection.addArrangedSubview(imageView2)
        contentView.difficultyImagesCollection.addArrangedSubview(imageView3)
        contentView.difficultyImagesCollection.addArrangedSubview(imageView4)
        contentView.difficultyImagesCollection.addArrangedSubview(imageView5)
        
        contentView.recipeImagesCollectionView.reloadData()
        //difficultyLevelImage.image = recipe.difficultyImage
    }
    
    
    // MARK: ViewModel
    
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
        contentView.pageControl.currentPage = Int(scrollView.contentOffset.x / contentView.recipeImagesCollectionView.frame.size.width)
    }
    
}

extension RecipeDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.recipeImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        viewModel.recipeImages[indexPath.row].dequeueCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    
}

extension RecipeDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}
