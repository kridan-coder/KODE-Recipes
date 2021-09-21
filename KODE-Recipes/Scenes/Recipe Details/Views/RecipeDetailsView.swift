//
//  RecipeDetailsView.swift
//  KODE-Recipes
//
//  Created by Developer on 10.09.2021.
//

import UIKit

final class RecipeDetailsView: UIView {
    
    // MARK: - Properties
    
    let recipeImagesCollectionView: UICollectionView
    let recommendationImagesCollectionView: UICollectionView
    let pageControl = UIPageControl()
    let recipeNameLabel = UILabel()
    let timestampLabel = UILabel()
    let descriptionTextLabel = UILabel()
    let difficultyTitleLabel = UILabel()
    let difficultyImagesCollection = UIStackView()
    let instructionTitleLabel = UILabel()
    let instructionTextLabel = UILabel()
    let recommendedTitleLabel = UILabel()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // MARK: - Init
    
    init() {
        let layoutRecipeImages = UICollectionViewFlowLayout()
        layoutRecipeImages.scrollDirection = .horizontal
        recipeImagesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutRecipeImages)
        
        let layoutRecipeRecommendationsImages = UICollectionViewFlowLayout()
        layoutRecipeRecommendationsImages.scrollDirection = .horizontal
        recommendationImagesCollectionView = UICollectionView(frame: CGRect.zero,
                                                              collectionViewLayout: layoutRecipeRecommendationsImages)
        
        super.init(frame: CGRect.zero)
        initializeUI()
        createConstraints()
        setupTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    var didPressSortByButton: (() -> Void)?
    
    // MARK: - Actions
    
    @objc private func sortByButtonPressed() {
        didPressSortByButton?()
    }
    
    // MARK: - Private Methods
    
    private func createConstraints() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(self)
        }
    
        createConstraintsRecipeImagesCollection()
        createConstraintsPageControl()
        createConstraintsRecipeNameTimestamp()
        createConstraintsDescription()
        createConstraintsDifficulty()
        createConstraintsInstruction()
        createConstraintsRecommendation()
    }
    
    private func createConstraintsRecipeImagesCollection() {
        contentView.addSubview(recipeImagesCollectionView)
        recipeImagesCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.RecipeImageCollection.height)
        }
    }
    
    private func createConstraintsPageControl() {
        contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(recipeImagesCollectionView.snp.bottom)
            make.centerX.equalTo(recipeImagesCollectionView.snp.centerX)
        }
    }
    
    private func createConstraintsRecipeNameTimestamp() {
        contentView.addSubview(timestampLabel)
        contentView.addSubview(recipeNameLabel)
        timestampLabel.snp.makeConstraints { make in
            make.bottom.equalTo(recipeNameLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }

        recipeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeImagesCollectionView.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.equalToSuperview().inset(Constants.Inset.classic)
            make.trailing.equalTo(timestampLabel.snp.leading).offset(-Constants.Inset.classic)
        }
    }
    
    private func createConstraintsDescription() {
        contentView.addSubview(descriptionTextLabel)
        descriptionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeNameLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }
    }
    
    private func createConstraintsDifficulty() {
        contentView.addSubview(difficultyTitleLabel)
        difficultyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }

        contentView.addSubview(difficultyImagesCollection)
        difficultyImagesCollection.snp.makeConstraints { make in
            make.top.equalTo(difficultyTitleLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.equalToSuperview().inset(Constants.Inset.classic)
            make.trailing.lessThanOrEqualToSuperview().inset(Constants.Inset.classic)
        }
    }
    
    private func createConstraintsInstruction() {
        contentView.addSubview(instructionTitleLabel)
        instructionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(difficultyImagesCollection.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }

        contentView.addSubview(instructionTextLabel)
        instructionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionTitleLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }
    }
    
    private func createConstraintsRecommendation() {
        contentView.addSubview(recommendedTitleLabel)
        recommendedTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionTextLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)

        }

        contentView.addSubview(recommendationImagesCollectionView)
        recommendationImagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendedTitleLabel.snp.bottom)
            make.bottom.equalTo(contentView)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(Constants.RecommendationImageCollection.height)
        }
    }
    
    private func setupTargets() {
        // TODO: - make and setup targets
    }
    
    private func initializeUI() {
        backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        setupTitleLabels()
        setupTextLabels()
        setupRecipeNameLabel()
        setupTimestampLabel()
        setupRecipeImagesCollection()
        setupRecipeRecommendationsImagesCollection()
        setupDifficultyImagesCollection()
    }
    
    private func setupTitleLabels() {
        recommendedTitleLabel.font = UIFont.big
        recommendedTitleLabel.textColor = .darkGray
        
        instructionTitleLabel.font = UIFont.big
        instructionTitleLabel.textColor = .darkGray
        
        difficultyTitleLabel.font = UIFont.big
        difficultyTitleLabel.textColor = .darkGray
    }
    
    private func setupTextLabels() {
        instructionTextLabel.font = UIFont.thin
        instructionTextLabel.textColor = .gray
        instructionTextLabel.numberOfLines = 0
        
        descriptionTextLabel.font = UIFont.thin
        descriptionTextLabel.textColor = .gray
        descriptionTextLabel.numberOfLines = 0
    }
    
    private func setupRecipeNameLabel() {
        recipeNameLabel.numberOfLines = Constants.Text.numberOfLinesStandart
        recipeNameLabel.font = UIFont.huge
        recipeNameLabel.textColor = .darkGray
        
    }
    
    private func setupTimestampLabel() {
        timestampLabel.font = UIFont.thin
        timestampLabel.textColor = .darkGray
    }
    
    private func setupDifficultyImagesCollection() {
        difficultyImagesCollection.axis = .horizontal
        difficultyImagesCollection.distribution = .fillEqually
        difficultyImagesCollection.alignment = .leading
        difficultyImagesCollection.spacing = Constants.DifficultyImageCollection.spacing
    }
    
    private func setupRecipeImagesCollection() {
        recipeImagesCollectionView.showsHorizontalScrollIndicator = false
        recipeImagesCollectionView.isPagingEnabled = true
        recipeImagesCollectionView.backgroundColor = .white
    }
    
    private func setupRecipeRecommendationsImagesCollection() {
        recommendationImagesCollectionView.showsHorizontalScrollIndicator = false
        recommendationImagesCollectionView.backgroundColor = .white
        recommendationImagesCollectionView.contentInset.left = Constants.Inset.classic
        recommendationImagesCollectionView.contentInset.right = Constants.Inset.classic
    }
    
}

// MARK: - Constants

private extension Constants {
    struct SortByButton {
        static let title = "Sort by"
    }
    struct SearchBar {
        static let placeholder = "Search"
    }
    struct DifficultyImageCollection {
        static let spacing = CGFloat(20)
    }
    struct RecommendationImageCollection {
        static let height = CGFloat(190)
    }
    struct RecipeImageCollection {
        static let height = CGFloat(300)
    }
    struct Text {
        static let numberOfLinesStandart = 2
    }
}
