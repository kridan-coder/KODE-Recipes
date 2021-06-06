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
    
    private var recipe: Recipe! {
        didSet {
            nameLabel.text = recipe.name
            descriptionLabel.text = recipe.description
            
            // set first image of recipe
            recipeImage.kf.indicatorType = .activity
            recipeImage.kf.setImage(with: URL(string: recipe.imageLinks[0]), placeholder: UIImage(named: "Placeholder"))
            
            // set date with specific format
            let date = Date(timeIntervalSince1970: recipe.lastUpdated)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            lastUpdatedLabel.text = "Last update: \(formatter.string(from: date))"
        }
    }
    
    private func setupCellAppearance() {
        wrapperContainerView.layer.cornerRadius = 15
        recipeImage.layer.cornerRadius = 15
        recipeImage.layer.borderWidth = 1
        recipeImage.layer.borderColor = UIColor(named: "TableBackgroundColor")?.cgColor
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


