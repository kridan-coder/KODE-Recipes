//
//  RecommendationCollectionViewRecipeSK.swift
//  KODE-Recipes
//
//  Created by Developer on 14.09.2021.
//

import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell {
    
    // MARK: Self creating
    
    static func registerCell(collectionView: UICollectionView) {
        collectionView.register(RecommendedCollectionViewCell.self,
                                forCellWithReuseIdentifier: "RecommendationCollectionViewCellSK")
    }
    
    static func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> RecommendedCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCollectionViewCellSK",
                                                            for: indexPath) as? RecommendedCollectionViewCell else {
            return RecommendedCollectionViewCell()
        }
        return cell
    }
    
    // MARK: Properties
    
    private let recipeImageView = UIImageView()
    private let titleLabel = UILabel()
    
    private var imageLink: String? {
        didSet {
            recipeImageView.kf.indicatorType = .activity
            recipeImageView.kf.setImage(with: URL(string: imageLink ?? ""), placeholder: UIImage.BaseTheme.placeholder)
        }
    }
    // TODO: - Get rid of implicitly unwrapped optional
    private var viewModel: RecommendedImageCollectionViewCellViewModel!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setupCellData(viewModel: RecommendedImageCollectionViewCellViewModel) {
        self.viewModel = viewModel
        imageLink = viewModel.imageLink
        titleLabel.text = viewModel.name
        
        viewModel.didUpdate = self.setupCellData
    }
    
    // MARK: - Private Methods
    
    private func createConstraints() {
        addSubview(recipeImageView)
        addSubview(titleLabel)
        
        recipeImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.Inset.classic)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().dividedBy(Constants.RecipeImage.dividedBy)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.Inset.huge)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.tiny)
        }
        
    }
    
    private func initializeUI() {
        setupRecipeImage()
        setupTitleLabel()
        setupGradient()
    }
    
    private func setupRecipeImage() {
        recipeImageView.layer.masksToBounds = true
        recipeImageView.layer.cornerRadius = Constants.Design.cornerRadiusMain
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.titleFont
    }
    
    // TODO: make a class or protocol for gradient adding on any UIView
    private func setupGradient() {
        let gradientView = UIView(frame: self.bounds)
        let gradient = CAGradientLayer()
        gradient.colors = Constants.Gradient.colors
        gradient.frame = gradientView.bounds
        gradient.locations = Constants.Gradient.locations
        gradientView.layer.insertSublayer(gradient, at: 0)
        recipeImageView.addSubview(gradientView)
        recipeImageView.bringSubviewToFront(gradientView)
    }
    
}

// MARK: - Constants

private extension Constants {
    struct RecipeImage {
        static let dividedBy = CGFloat(3 / 2)
    }
    struct Gradient {
        static let colors = [UIColor.black.withAlphaComponent(0.74).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        static let locations = [NSNumber(0.0), NSNumber(0.5)]
    }
}

private extension UIFont {
    static let titleFont = UIFont.systemFont(ofSize: 21, weight: .semibold)
}
