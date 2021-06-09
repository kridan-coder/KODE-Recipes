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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var difficultyLevelImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Elements set in code
    
    private var refreshControl = UIRefreshControl()
    
    // MARK: Public
    
    var viewModel: RecipeDetailsViewModel!
    
    // MARK: Helpers
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(RecipeDetailsViewController.refresh), for: .valueChanged)
        scrollView.addSubview(refreshControl)
    }
    
    private func setupAppearance() {
        difficultyLevelImage.layer.cornerRadius = 15
        difficultyLevelImage.layer.borderWidth = 1
        difficultyLevelImage.layer.borderColor = UIColor.BaseTheme.tableBackground?.cgColor
        instructionsTextView.layer.cornerRadius = 15
        descriptionTextView.layer.cornerRadius = 15
        refreshControl.tintColor = UIColor.BaseTheme.pageControlMain
    }
    
    private func setupRecipeData() {
        pageControl.numberOfPages = viewModel.recipe.imageLinks.count
        recipeNameLabel.text = viewModel.recipe.name
        instructionsTextView.text = viewModel.recipe.instructions
        
        // description may be not provided or can be empty
        descriptionTextView.text = viewModel.recipe.description
        if descriptionTextView.text == nil || descriptionTextView.text == "" {
            descriptionTextView.text = "No description provided."
        }
        
        // set date with specific format
        let date = Date(timeIntervalSince1970: viewModel.recipe.lastUpdated)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a, EEEE, MMM d, yyyy"
        lastUpdateLabel.text = "Last Recipe Update:\n \(formatter.string(from: date)) "
        
        // set image according to recipe difficulty
        switch viewModel.recipe.difficulty {
        case 1:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.easy.rawValue)
        case 2:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.normal.rawValue)
        case 3:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.hard.rawValue)
        case 4:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.extreme.rawValue)
        case 5:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.insane.rawValue)
        default:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.easy.rawValue)
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        ImageCollectionViewCellViewModel.registerCell(collectionView: self.collectionView)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupAppearance()
        setupRecipeData()
        setupCollectionView()
        
        // this notification is needed for correct cell size recalculating
        NotificationCenter.default.addObserver(self, selector: #selector(RecipeDetailsViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: Actions
    
    @objc func rotated() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func refresh() {
        print("Heeh")
    }
    
}

extension RecipeDetailsViewController: UICollectionViewDelegate {
    
    // TODO: Not sure that this function is a nice decision. Need to rethink and make it work faster
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
    }
    
}

extension RecipeDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.recipe.imageLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        viewModel.imagesViewModels[indexPath.row].dequeueCell(collectionView: collectionView, indexPath: indexPath)
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
