//
//  RecipeCollectionViewCellSK.swift
//  KODE-Recipes
//
//  Created by Developer on 14.09.2021.
//

import UIKit
import SnapKit

class RecipeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Self creating
    
    static func registerCell(collectionView: UICollectionView) {
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeCollectionViewCellSK")
    }
    
    static func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> RecipeCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCellSK", for: indexPath) as? RecipeCollectionViewCell else {
            return RecipeCollectionViewCell()
        }
        return cell
    }
    
    // MARK: - Properties
    
    private let recipeImageView = UIImageView()
    
    // TODO: - Get rid of implicitly unwrapped optional
    private var viewModel: ImageCollectionViewCellViewModel!
    
    // TODO: - Get rid of implicitly unwrapped optional
    private var imageLink: String! {
        didSet {
            recipeImageView.kf.indicatorType = .activity
            recipeImageView.kf.setImage(with: URL(string: imageLink), placeholder: UIImage.BaseTheme.placeholder)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setupCellData(viewModel: ImageCollectionViewCellViewModel) {
        self.viewModel = viewModel
        imageLink = viewModel.data
        
        viewModel.didUpdate = self.setupCellData
    }
    
    // MARK: - Private Methods
    
    private func createConstraints() {
        addSubview(recipeImageView)
        recipeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
