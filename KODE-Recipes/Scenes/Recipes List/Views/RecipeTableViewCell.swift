//
//  RecipeTableViewCell.swift
//  KODE-Recipes
//
//  Created by Developer on 10.09.2021.
//

import UIKit
import Kingfisher

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: Self creating
    
    static func registerCell(tableView: UITableView) {
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: "RecipeTableViewCell")
    }
    
    static func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> RecipeTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell",
                                                       for: indexPath) as? RecipeTableViewCell
        else {
            return RecipeTableViewCell()
        }
        return cell
    }
    
    // MARK: - Properties
    // TODO: - Get rid of implicitly unwrapped optional
    private var viewModel: RecipeTableViewCellViewModel!
    
    var didPressButton: (() -> Void)?
    
    private let recipeImageView = UIImageView()
    private let labelsContainer = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let timestampLabel = UILabel()
    // TODO: - Get rid of implicitly unwrapped optional
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
    

    
    // MARK: - Private Methods
    
    private func createConstraints() {
        addSubview(recipeImageView)
        addSubview(labelsContainer)
        
        recipeImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.Inset.classic)
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().dividedBy(Constants.Image.widthDivision)
        }
        
        labelsContainer.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(Constants.Inset.small)
            make.trailing.equalTo(recipeImageView.snp.leading).offset(-Constants.Inset.classic)
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
        recipeImageView.layer.cornerRadius = Constants.Design.cornerRadiusMain
        recipeImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.big
        titleLabel.numberOfLines = Constants.Text.numberOfLinesStandart
        titleLabel.textColor = .darkGray
        titleLabel.minimumScaleFactor = Constants.Text.minimumScale
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.standart
        descriptionLabel.numberOfLines = Constants.Text.numberOfLinesStandart
        descriptionLabel.textColor = .systemGray
        descriptionLabel.minimumScaleFactor = Constants.Text.minimumScale
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupTimestampLabel() {
        timestampLabel.font = UIFont.standart
        timestampLabel.textColor = .darkGray
        timestampLabel.minimumScaleFactor = Constants.Text.minimumScale
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupLabelsContainer() {
        labelsContainer.alignment = .leading
        labelsContainer.axis = .vertical
        labelsContainer.spacing = Constants.LabelsContainer.spacing
    }
    
}

// MARK: - Constants

private extension Constants {
    struct Image {
        static let widthDivision = CGFloat(2.3)
    }
    struct Text {
        static let minimumScale = CGFloat(0.9)
        static let numberOfLinesStandart = 2
    }
    struct LabelsContainer {
        static let spacing = CGFloat(8)
    }
}
