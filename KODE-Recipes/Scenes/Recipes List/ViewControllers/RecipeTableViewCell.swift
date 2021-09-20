//
//  RecipeTableViewCell.swift
//  KODE-Recipes
//
//  Created by KriDan on 03.06.2021.
//

import UIKit
import Kingfisher

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - Self creating
    
    static func registerCell(tableView: UITableView) {
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
    }
    
    static func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> RecipeTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath)
            as? RecipeTableViewCell ?? RecipeTableViewCell()
        return cell
    }
    
    // MARK: - Properties
    
    private var recipe: RecipeDataForCell! {
        didSet {
            nameLabel.text = recipe.name
            descriptionLabel.text = recipe.description
            lastUpdatedLabel.text = recipe.lastUpdated
            
            // set first image of recipe
            recipeImage.kf.indicatorType = .activity
            recipeImage.kf.setImage(with: URL(string: recipe.imageLink), placeholder: UIImage.BaseTheme.placeholder)
        }
    }
    
    private var viewModel: RecipeTableViewCellViewModel!
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var wrapperContainerView: UIView!
    @IBOutlet private weak var recipeImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var lastUpdatedLabel: UILabel!
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
    }
    
    // MARK: - Public Methods
    
    func setupCellData(viewModel: RecipeTableViewCellViewModel) {
        self.viewModel = viewModel
        self.recipe = viewModel.data
        
        viewModel.didUpdate = self.setupCellData
    }
    
    // MARK: - Private Methods
    
    private func setupCellAppearance() {
        wrapperContainerView.layer.cornerRadius = Constants.Design.cornerRadiusMain
        recipeImage.layer.cornerRadius = Constants.Design.cornerRadiusMain
        recipeImage.layer.borderWidth = Constants.Design.borderWidthSecondary
        recipeImage.layer.borderColor = UIColor.BaseTheme.tableBackground?.cgColor
    }
    
}
