//
//  RecipeViewController.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var difficultyLevelImage: UIImageView!
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: RecipeViewModel!
    
    private func setAppearance(){
        
        instructionsTextView.layer.cornerRadius = 15
        descriptionTextView.layer.cornerRadius = 15
        
        recipeNameLabel.text = viewModel.recipe.name
        
        if let description = viewModel.recipe.description {
            descriptionTextView.text = description
        }
        else {
            descriptionTextView.text = "No description provided."
        }
        
        instructionsTextView.text = viewModel.recipe.instructions
        
        let date = Date(timeIntervalSince1970: viewModel.recipe.lastUpdated)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a, EEEE, MMM d, yyyy"
        lastUpdateLabel.text = "Last update:\n \(formatter.string(from: date)) "

        
        switch viewModel.recipe.difficulty {
        case 1:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.easy.rawValue)
        case 2:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.normal.rawValue)
        case 3:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.hard.rawValue)
        case 4:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.extreme.rawValue)
        case 5:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.insane.rawValue)
        default:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.easy.rawValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
