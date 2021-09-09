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
    
    var viewModel: RecipeDetailsViewModel!
    
    private var images: [ImageCollectionViewCellViewModel] = []
    private let alertView = ErrorPageView()
    
    // Elements set in code
    private var refreshControl = UIRefreshControl()
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var lastUpdateLabel: UILabel!
    @IBOutlet private weak var difficultyLevelImage: UIImageView!
    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var instructionsTextView: UITextView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupCollectionView()
        setupRefreshControl()
        bindToViewModel()
        viewModel.reloadData()
        setupCustomAlert(alertView)
        
        // this notification is needed for correct cell size recalculating
        NotificationCenter.default.addObserver(self, selector: #selector(RecipeDetailsViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            viewModel.viewWillDisappear()
        }
    }
    
    // MARK: - Actions
    
    @objc func rotated() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc private func refresh() {
        viewModel.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func setupRecipeData(recipe: RecipeDataForDetails) {
        pageControl.numberOfPages = recipe.imageLinks.count
        recipeNameLabel.text = recipe.name
        instructionsTextView.text = recipe.instructions
        descriptionTextView.text = recipe.description
        lastUpdateLabel.text = recipe.lastUpdated
        difficultyLevelImage.image = recipe.difficultyImage
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(RecipeDetailsViewController.refresh), for: .valueChanged)
        scrollView.addSubview(refreshControl)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        ImageCollectionViewCellViewModel.registerCell(collectionView: self.collectionView)
    }
    
    private func setupAppearance() {
        difficultyLevelImage.layer.cornerRadius = Constants.Design.cornerRadiusMain
        difficultyLevelImage.layer.borderWidth = Constants.Design.borderWidthSecondary
        difficultyLevelImage.layer.borderColor = UIColor.BaseTheme.tableBackground?.cgColor
        instructionsTextView.layer.cornerRadius = Constants.Design.cornerRadiusMain
        descriptionTextView.layer.cornerRadius = Constants.Design.cornerRadiusMain
        refreshControl.tintColor = UIColor.BaseTheme.pageControlMain
    }
    
    // ViewModel binding
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
        viewModel.didFinishSuccessfully = { [weak self]  in
            self?.didFinishSuccessfully()
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
            images = viewModel.imagesViewModels
            setupRecipeData(recipe: recipe)
            collectionView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    private func didReceiveError(_ error: Error) {
        navigationController?.navigationBar.isHidden = true
        showCustomAlert(alertView, title: Constants.ErrorType.basic, message: error.localizedDescription, buttonText: Constants.ButtonTitle.refresh)
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
        pageControl.currentPage = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
    }
    
}

// MARK: - CollectionView DataSource

extension RecipeDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        images[indexPath.row].dequeueCell(collectionView: collectionView, indexPath: indexPath)
    }
    
}

// MARK: - CollectionView FlowLayout

extension RecipeDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}
