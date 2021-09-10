//
//  RecipeDetailsViewController.swift
//  KODE-Recipes
//
//  Created by Developer on 10.09.2021.
//

import Foundation
import UIKit

final class RecipeDetailsViewControllerSK: UIView {
    
    // MARK: - Properties
    let recipeImagesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    //let recommendationImagesCollectionView = UICollectionView()
    let pageControl = UIPageControl()
    let recipeNameLabel = UILabel()
    let timestampLabel = UILabel()
    let descriptionTextLabel = UILabel()
    let difficultyTitleLabel = UILabel()
    let difficultyImagesCollection = UIStackView()
    let instructionTitleLabel = UILabel()
    let instructionTextLabel = UILabel()
    let recommendedTitleLabel = UILabel()
    
    // MARK: - Init
    
    init() {
        super.init(frame: CGRect.zero)
        initializeUI()
        createConstraints()
        setupTargets()
        isHidden = true
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
        addSubview(recipeImagesCollectionView)
        recipeImagesCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        addSubview(timestampLabel)
        addSubview(recipeNameLabel)
        timestampLabel.snp.makeConstraints { make in
            make.bottom.equalTo(recipeNameLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(20)
        }
        
        recipeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeImagesCollectionView.snp.bottom).inset(20)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(timestampLabel.snp.leading).offset(-20)
        }
        
        addSubview(descriptionTextLabel)
        descriptionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeNameLabel.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addSubview(difficultyTitleLabel)
        difficultyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextLabel.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addSubview(difficultyImagesCollection)
        difficultyImagesCollection.snp.makeConstraints { make in
            make.top.equalTo(difficultyTitleLabel.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addSubview(instructionTitleLabel)
        instructionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(difficultyImagesCollection.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addSubview(instructionTextLabel)
        instructionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionTitleLabel.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addSubview(recommendedTitleLabel)
        recommendedTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionTextLabel.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
//        addSubview(recommendationImagesCollectionView)
//        recommendationImagesCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(recommendedTitleLabel.snp.bottom).inset(20)
//            make.leading.trailing.equalToSuperview().inset(20)
//        }
        
        addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(recipeImagesCollectionView.snp.bottom)
            make.centerX.equalTo(recipeImagesCollectionView.snp.centerX)
        }
        
    }
    
    private func setupTargets() {
        
    }
    
    private func initializeUI() {
        backgroundColor = .white
        setupTitleLabels()
        setupTextLabels()
        setupRecipeNameLabel()
        setupTimestampLabel()
        setupDifficultyImagesCollection()
    }
    
    private func setupTitleLabels() {
        recommendedTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        recommendedTitleLabel.textColor = .darkGray
        
        instructionTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        instructionTitleLabel.textColor = .darkGray
        
        difficultyTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        difficultyTitleLabel.textColor = .darkGray
    }
    
    private func setupTextLabels() {
        instructionTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        instructionTextLabel.textColor = .gray
        
        descriptionTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionTextLabel.textColor = .gray
    }
    
    private func setupRecipeNameLabel() {
        recipeNameLabel.numberOfLines = 2
        recipeNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        recipeNameLabel.textColor = .darkGray
        
    }
    
    private func setupTimestampLabel() {
        timestampLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        timestampLabel.textColor = .darkGray
    }
    
    private func setupDifficultyImagesCollection() {
        difficultyImagesCollection.axis = .horizontal
        difficultyImagesCollection.alignment = .firstBaseline
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

