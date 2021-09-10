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
    
    private let contentView = RecipeDetailsViewControllerSK()
    private let scrollView = UIScrollView()
    
    // MARK: Elements set in code
    
    private var refreshControl = UIRefreshControl()
    
    // MARK: Public
    
    var viewModel: RecipeDetailsViewModel!
    
    // MARK: Properties
    private var images: [ImageCollectionViewCellViewModel] = []
    
    // MARK: Helpers
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(RecipeDetailsViewController.refresh), for: .valueChanged)
        scrollView.addSubview(refreshControl)
    }
    
    private func setupCollectionView() {
        contentView.recipeImagesCollectionView.delegate = self
        contentView.recipeImagesCollectionView.dataSource = self
        ImageCollectionViewCellViewModel.registerCell(collectionView: self.contentView.recipeImagesCollectionView)
    }
    
    private func setupAppearance() {
//        difficultyLevelImage.layer.cornerRadius = Constants.Design.cornerRadiusMain
//        difficultyLevelImage.layer.borderWidth = Constants.Design.borderWidthSecondary
//        difficultyLevelImage.layer.borderColor = UIColor.BaseTheme.tableBackground?.cgColor
//        instructionsTextView.layer.cornerRadius = Constants.Design.cornerRadiusMain
//        descriptionTextView.layer.cornerRadius = Constants.Design.cornerRadiusMain
        refreshControl.tintColor = UIColor.BaseTheme.pageControlMain
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupCollectionView()
        setupRefreshControl()
        bindToViewModel()
        viewModel.reloadData()
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        // this notification is needed for correct cell size recalculating
        NotificationCenter.default.addObserver(self, selector: #selector(RecipeDetailsViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            viewModel.viewWillDisappear()
        }
    }
    
    // MARK: Actions
    
    @objc func rotated() {
        contentView.recipeImagesCollectionView.collectionViewLayout.invalidateLayout()
        contentView.recipeImagesCollectionView.scrollToItem(at: IndexPath(item: contentView.pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func refresh() {
        viewModel.reloadData()
    }
    
    func setupRecipeData(recipe: RecipeDataForDetails) {
        contentView.pageControl.numberOfPages = recipe.imageLinks.count
        contentView.recipeNameLabel.text = recipe.name
        contentView.instructionTextLabel.text = recipe.instructions
        contentView.descriptionTextLabel.text = recipe.description
        contentView.timestampLabel.text = recipe.lastUpdated
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
    }
    
    private func viewModelDidFinishUpdating() {
        if let recipe = viewModel.recipe {
            images = viewModel.imagesViewModels
            setupRecipeData(recipe: recipe)
            contentView.recipeImagesCollectionView.reloadData()
        }
        refreshControl.endRefreshing()
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
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        images[indexPath.row].dequeueCell(collectionView: collectionView, indexPath: indexPath)
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
