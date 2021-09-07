//
//  RecipeTableViewCell.swift
//  KODE-Recipes
//
//  Created by KriDan on 03.06.2021.
//

import UIKit
import Kingfisher

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: Self creating
    
    static func registerCell(tableView: UITableView) {
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
    }
    
    static func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> RecipeTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            return RecipeTableViewCell()
        }
        return cell
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var wrapperContainerView: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    // MARK: Private
    
    private var viewModel: RecipeTableViewCellViewModel!
    
    // MARK: Properties
    
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
    
    // MARK: Helpers
    
    private func setupCellAppearance() {
        wrapperContainerView.layer.cornerRadius = Constants.Design.cornerRadiusMain
        recipeImage.layer.cornerRadius = Constants.Design.cornerRadiusMain
        recipeImage.layer.borderWidth = Constants.Design.borderWidthSecondary
        recipeImage.layer.borderColor = UIColor.BaseTheme.tableBackground?.cgColor
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
    }
    
    // MARK: Actions
    
    func setupCellData(viewModel: RecipeTableViewCellViewModel) {
        self.viewModel = viewModel
        self.recipe = viewModel.data
        
        viewModel.didUpdate = self.setupCellData
    }
    
}
