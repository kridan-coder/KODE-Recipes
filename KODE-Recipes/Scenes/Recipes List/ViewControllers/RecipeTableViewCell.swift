//
//  RecipeTableViewCell.swift
//  KODE-Recipes
//
//  Created by KriDan on 03.06.2021.
//

import UIKit
import Kingfisher

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var wrapperContainerView: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    // MARK: Private
    
    private var viewModel: RecipeTableViewCellViewModel!
    
    // MARK: Properties
    
    private var recipe: Recipe! {
        didSet {
            nameLabel.text = recipe.name
            descriptionLabel.text = recipe.description
            
            // set first image of recipe
            recipeImage.kf.indicatorType = .activity
            recipeImage.kf.setImage(with: URL(string: recipe.imageLinks[0]), placeholder: UIImage.BaseTheme.placeholder)
            
            // set date with specific format
            let date = Date(timeIntervalSince1970: recipe.lastUpdated)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            lastUpdatedLabel.text = "Last update: \(formatter.string(from: date))"
        }
    }
    
    // MARK: Helpers
    
    private func setupCellAppearance() {
        wrapperContainerView.layer.cornerRadius = Constants.cornerRadiusMain
        recipeImage.layer.cornerRadius = Constants.cornerRadiusMain
        recipeImage.layer.borderWidth = Constants.borderWidthSecondary
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
