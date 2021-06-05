//
//  RecipeTableViewCell.swift
//  KODE-Recipes
//
//  Created by KriDan on 03.06.2021.
//

import UIKit
import Kingfisher



class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var wholeContainerView: UIView!
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    
    
    
    var viewModel: RecipeCellViewModel!
    var recipe: Recipe! {
        didSet{
            recipeImage.kf.indicatorType = .activity
            recipeImage.kf.setImage(with: URL(string: recipe.imageLinks[0]))
            
            nameLabel.text = recipe.name
            descriptionLabel.text = recipe.description
            
            let date = Date(timeIntervalSince1970: recipe.lastUpdated)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            lastUpdatedLabel.text = "Last update: \(formatter.string(from: date)) "
            //formatter.dateFormat = "h:mm a"
            //lastUpdatedLabel.text! += "(\(formatter.string(from: date)))"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.layer.cornerRadius = 15
        recipeImage.layer.cornerRadius = 15
        recipeImage.layer.borderWidth = 1
        recipeImage.layer.borderColor = UIColor(named: "TableBackgroundColor")?.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    
    func setup(viewModel: RecipeCellViewModel){
        self.viewModel = viewModel
        self.recipe = viewModel.data
    }
    
}


