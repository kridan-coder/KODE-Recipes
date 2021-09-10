//
//  RecipeTableViewCellSK.swift
//  KODE-Recipes
//
//  Created by Developer on 10.09.2021.
//

import Foundation
import UIKit
import Kingfisher

class RecipeTableViewCellSK: UITableViewCell {
    
    // MARK: Self creating
    
    static func registerCell(tableView: UITableView) {
        tableView.register(RecipeTableViewCellSK.self, forCellReuseIdentifier: "RecipeTableViewCell")
    }
    
    static func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> RecipeTableViewCellSK {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCellSK else {
            return RecipeTableViewCellSK()
        }
        return cell
    }
    
    
    // MARK: - Properties
    
    private var viewModel: RecipeTableViewCellViewModel!
    
    private let recipeImageView = UIImageView()
    private let labelsContainer = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let timestampLabel = UILabel()
    
    private var recipe: RecipeDataForCell! {
        didSet {
            titleLabel.text = recipe.name
            descriptionLabel.text = recipe.description
            timestampLabel.text = recipe.lastUpdated
            
            // set first image of recipe
            recipeImageView.kf.indicatorType = .activity
            recipeImageView.kf.setImage(with: URL(string: recipe.imageLink), placeholder: UIImage.BaseTheme.placeholder)
        }
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeUI()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Public Methods
    
    func setupCellData(viewModel: RecipeTableViewCellViewModel) {
        self.viewModel = viewModel
        self.recipe = viewModel.data
        
        viewModel.didUpdate = self.setupCellData
    }
    
    // MARK: - Actions
    
    @objc private func buttonPressed() {
        didPressButton?()
    }
    
    var didPressButton: (() -> Void)?
    
    // MARK: - Private Methods
    
    private func createConstraints() {
        addSubview(recipeImageView)
        addSubview(labelsContainer)

        
        recipeImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2.3)
        }
        
        labelsContainer.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(18)
            make.trailing.equalTo(recipeImageView.snp.leading).offset(-20)
        }
        labelsContainer.addArrangedSubview(titleLabel)
        labelsContainer.addArrangedSubview(descriptionLabel)
        labelsContainer.addArrangedSubview(timestampLabel)
        
    }
    
    private func initializeUI() {
        setupRecipeImage()
        setupTitleLabel()
        setupDescriptionLabel()
        setupTimestampLabel()
        setupLabelsContainer()
    }
    
    private func setupRecipeImage() {
        recipeImageView.layer.masksToBounds = true
        recipeImageView.layer.cornerRadius = 15
        recipeImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .darkGray
        titleLabel.minimumScaleFactor = 0.9
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .systemGray
        descriptionLabel.minimumScaleFactor = 0.9
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupTimestampLabel() {
        timestampLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        timestampLabel.textColor = .darkGray
        timestampLabel.minimumScaleFactor = 0.9
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupLabelsContainer() {
        labelsContainer.alignment = .leading
        labelsContainer.axis = .vertical
        labelsContainer.spacing = 8
    }
    
}

// MARK: - Constants
private extension Constants {
    struct Button {
        static let height = CGFloat(45)
        static let divison = CGFloat(1.15)
    }
}
