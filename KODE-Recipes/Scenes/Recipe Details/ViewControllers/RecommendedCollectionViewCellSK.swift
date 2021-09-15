//
//  RecommendationCollectionViewRecipeSK.swift
//  KODE-Recipes
//
//  Created by Developer on 14.09.2021.
//

import Foundation
import UIKit

class RecommendedCollectionViewCellSK: UICollectionViewCell {
    
    // MARK: Self creating
    
    static func registerCell(collectionView: UICollectionView) {
        collectionView.register(RecommendedCollectionViewCellSK.self, forCellWithReuseIdentifier: "RecommendationCollectionViewCellSK")
    }
    
    static func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> RecommendedCollectionViewCellSK {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCollectionViewCellSK", for: indexPath) as? RecommendedCollectionViewCellSK else {
            return RecommendedCollectionViewCellSK()
        }
        cell.setupGradient()
        return cell
    }
    
    
    // MARK: IBOutlets
    
    private let recipeImageView = UIImageView()
    private let titleLabel = UILabel()
    
    // MARK: Private
    
    private var viewModel: RecommendedImageCollectionViewCellViewModel!
    
    // MARK: Properties
    
    private var imageLink: String? {
        didSet {
            recipeImageView.kf.indicatorType = .activity
            recipeImageView.kf.setImage(with: URL(string: imageLink ?? ""), placeholder: UIImage.BaseTheme.placeholder)
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
            make.top.equalToSuperview().inset(30)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
    }
    
    private func initializeUI() {
        setupRecipeImage()
        setupTitleLabel()
        //setupGradient()
    }
    
    private func setupRecipeImage() {
        recipeImageView.layer.masksToBounds = true
        recipeImageView.layer.cornerRadius = Constants.Design.cornerRadiusMain
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
    }
    
    private func setupGradient() {
        let gradientView = UIView(frame: self.frame)
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient.frame = gradientView.bounds
        gradient.locations = [0.0, 0.5]
        gradientView.layer.insertSublayer(gradient, at: 0)
        recipeImageView.addSubview(gradientView)
        recipeImageView.bringSubviewToFront(gradientView)
    }
    
    // MARK: Actions
    
    func setupCellData(viewModel: RecommendedImageCollectionViewCellViewModel) {
        self.viewModel = viewModel
        imageLink = viewModel.imageLink
        titleLabel.text = viewModel.name
        
        viewModel.didUpdate = self.setupCellData
    }
}
