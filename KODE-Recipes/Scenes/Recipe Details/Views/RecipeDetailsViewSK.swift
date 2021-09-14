//
//  RecipeDetailsViewController.swift
//  KODE-Recipes
//
//  Created by Developer on 10.09.2021.
//

import Foundation
import UIKit

final class RecipeDetailsViewSK: UIView {
    
    // MARK: - Properties
    var recipeImagesCollectionView: UICollectionView
    let recommendationImagesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        recipeImagesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
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
        
        contentView.addSubview(recipeImagesCollectionView)
        recipeImagesCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(recipeImagesCollectionView.snp.bottom)
            make.centerX.equalTo(recipeImagesCollectionView.snp.centerX)
        }
        
        contentView.addSubview(timestampLabel)
        contentView.addSubview(recipeNameLabel)
        timestampLabel.snp.makeConstraints { make in
            make.bottom.equalTo(recipeNameLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(20)
        }

        recipeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeImagesCollectionView.snp.bottom).inset(-20)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(timestampLabel.snp.leading).offset(-20)
        }

        contentView.addSubview(descriptionTextLabel)
        descriptionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeNameLabel.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        contentView.addSubview(difficultyTitleLabel)
        difficultyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextLabel.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        contentView.addSubview(difficultyImagesCollection)
        difficultyImagesCollection.snp.makeConstraints { make in
            make.top.equalTo(difficultyTitleLabel.snp.bottom).inset(-20)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
            //make.height.equalTo(50)
        }

        contentView.addSubview(instructionTitleLabel)
        instructionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(difficultyImagesCollection.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        contentView.addSubview(instructionTextLabel)
        instructionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionTitleLabel.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        contentView.addSubview(recommendedTitleLabel)
        recommendedTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionTextLabel.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(20)

        }

        contentView.addSubview(recommendationImagesCollectionView)
        recommendationImagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendedTitleLabel.snp.bottom).inset(-20)
            make.bottom.equalTo(contentView).inset(20)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(200)
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
        setupDifficultyImagesCollection()
    }
    
    private func setupTitleLabels() {
        recommendedTitleLabel.font = UIFont.systemFont(ofSize: 23, weight: .regular)
        recommendedTitleLabel.textColor = .darkGray
        
        instructionTitleLabel.font = UIFont.systemFont(ofSize: 23, weight: .regular)
        instructionTitleLabel.textColor = .darkGray
        
        difficultyTitleLabel.font = UIFont.systemFont(ofSize: 23, weight: .regular)
        difficultyTitleLabel.textColor = .darkGray
    }
    
    private func setupTextLabels() {
        instructionTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        instructionTextLabel.textColor = .gray
        instructionTextLabel.numberOfLines = 0
        
        descriptionTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionTextLabel.textColor = .gray
        descriptionTextLabel.numberOfLines = 0
    }
    
    private func setupRecipeNameLabel() {
        recipeNameLabel.numberOfLines = 2
        recipeNameLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        recipeNameLabel.textColor = .darkGray
        
    }
    
    private func setupTimestampLabel() {
        timestampLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        timestampLabel.textColor = .darkGray
    }
    
    private func setupDifficultyImagesCollection() {
        difficultyImagesCollection.axis = .horizontal
        difficultyImagesCollection.distribution = .fillEqually
        difficultyImagesCollection.alignment = .leading
        difficultyImagesCollection.spacing = 20
    }
    
    private func setupRecipeImagesCollection() {
        recipeImagesCollectionView.showsHorizontalScrollIndicator = false
        recipeImagesCollectionView.isPagingEnabled = true
        recipeImagesCollectionView.backgroundColor = .white
    }
    
}

private extension Constants {
    struct SortByButton {
        static let title = "Sort by"
    }
    struct SearchBar {
        static let placeholder = "Search"
    }
}
