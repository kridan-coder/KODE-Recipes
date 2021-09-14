//
//  RecommendationCollectionViewRecipeSK.swift
//  KODE-Recipes
//
//  Created by Developer on 14.09.2021.
//

import Foundation
import UIKit

class RecommendationCollectionViewCellSK: UICollectionViewCell {
    
    // MARK: Self creating
    
    static func registerCell(collectionView: UICollectionView) {
        collectionView.register(RecommendationCollectionViewCellSK.self, forCellWithReuseIdentifier: "RecommendationCollectionViewCellSK")
    }
    
    static func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> RecommendationCollectionViewCellSK {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCollectionViewCellSK", for: indexPath) as? RecommendationCollectionViewCellSK else {
            return RecommendationCollectionViewCellSK()
        }
        return cell
    }
    
    // MARK: IBOutlets
    
    private let recipeImageView = UIImageView()
    private let titleLabel = UILabel()
    
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
        addSubview(titleLabel)

        
        recipeImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3/2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(18)
        }
        
    }
    
    private func initializeUI() {
        setupRecipeImage()
        setupTitleLabel()
    }
    
    private func setupRecipeImage() {
        recipeImageView.layer.cornerRadius = Constants.Design.cornerRadiusMain
        recipeImageView.layer.borderWidth = Constants.Design.borderWidthMain
        recipeImageView.layer.borderColor = UIColor.BaseTheme.tableBackground?.cgColor
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 18)
    }
    
    // MARK: Actions
    
    func setupCellData(viewModel: ImageCollectionViewCellViewModel) {
        self.viewModel = viewModel
        imageLink = viewModel.data
        
        viewModel.didUpdate = self.setupCellData
    }
}
