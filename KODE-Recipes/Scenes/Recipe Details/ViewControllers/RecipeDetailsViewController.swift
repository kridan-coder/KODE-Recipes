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
    
    let viewModel: RecipeDetailsViewModel
    
    private let alertView = ErrorPageView()
    
    // Elements set in code
    private let refreshControl = UIRefreshControl()
    
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
    
    init(viewModel: RecipeDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "RecipeDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupCollectionView()
        setupRefreshControl()
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
    
    // MARK: - Actions
    
    @objc private func refresh() {
        viewModel.reloadData()
    }
    
    func setupRecipeData(numberOfPages: Int, recipeName: String, instructions: String, description: String, lastUpdate: String, difficultyImage: UIImage) {
        pageControl.numberOfPages = numberOfPages
        recipeNameLabel.text = recipeName
        instructionsTextView.text = instructions
        descriptionTextView.text = description
        lastUpdateLabel.text = lastUpdate
        difficultyLevelImage.image = difficultyImage
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
            setupRecipeData(numberOfPages: recipe.imageLinks.count, recipeName: recipe.name, instructions: recipe.instructions, description: recipe.description, lastUpdate: recipe.lastUpdated, difficultyImage: recipe.difficultyImage ?? UIImage())
            collectionView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    private func didReceiveError(_ error: Error) {
        navigationController?.navigationBar.isHidden = true
        showCustomAlert(alertView,
                        title: Constants.ErrorType.basic,
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
        pageControl.currentPage = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
    }
    
}

// MARK: - CollectionView DataSource

extension RecipeDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        viewModel.images[indexPath.row].dequeueCell(collectionView: collectionView, indexPath: indexPath)
    }
    
}

// MARK: - CollectionView FlowLayout

extension RecipeDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}
