//
//  RecipeCollectionViewCellSK.swift
//  KODE-Recipes
//
//  Created by Developer on 14.09.2021.
//

import Foundation
import UIKit

class RecipeCollectionViewCellSK: UICollectionViewCell {
    
    // MARK: Self creating
    
    static func registerCell(collectionView: UICollectionView) {
        collectionView.register(RecipeCollectionViewCellSK.self, forCellWithReuseIdentifier: "RecipeCollectionViewCellSK")
    }
    
    static func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> RecipeCollectionViewCellSK {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCellSK", for: indexPath) as? RecipeCollectionViewCellSK else {
            return RecipeCollectionViewCellSK()
        }
        return cell
    }
    
    // MARK: IBOutlets
    
    private let recipeImageView = UIImageView()
    
    // MARK: Private
    
    private var viewModel: ImageCollectionViewCellViewModel!
    
    // MARK: Properties
    
    private var imageLink: String! {
        didSet {
            recipeImageView.kf.indicatorType = .activity
            recipeImageView.kf.setImage(with: URL(string: imageLink), placeholder: UIImage.BaseTheme.placeholder)
        }
    }
    
    
    // MARK: Lifecycle
    
    // MARK: - Init
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConstraints() {
        addSubview(recipeImageView)
        recipeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func initializeUI() {
        setupRecipeImage()
    }
    
    private func setupRecipeImage() {
//        recipeImageView.layer.cornerRadius = Constants.Design.cornerRadiusMain
//        recipeImageView.layer.borderWidth = Constants.Design.borderWidthMain
//        recipeImageView.layer.borderColor = UIColor.BaseTheme.tableBackground?.cgColor
    }
    
    // MARK: Actions
    
    func setupCellData(viewModel: ImageCollectionViewCellViewModel) {
        self.viewModel = viewModel
        imageLink = viewModel.data
        
        viewModel.didUpdate = self.setupCellData
    }
}
