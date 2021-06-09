//
//  RecipeTableViewCellViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

final class RecipeTableViewCellViewModel {
    
    // MARK: Properties
    
    let data: RecipeDataForCell
    
    // MARK: Actions
    
    var didReceiveError: ((String) -> Void)?
    var didUpdate: ((RecipeTableViewCellViewModel) -> Void)?
    var didSelectRecipe: ((String) -> Void)?
    
    // MARK: Lifecycle
    
    init(recipe: RecipeDataForCell) {
        self.data = recipe
    }
    
}

extension RecipeTableViewCellViewModel: TableViewCellRepresentable {
    
    static func registerCell(tableView: UITableView) {
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
    }
    
    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        cell.setupCellData(viewModel: self)
        return cell
    }
    
    func cellSelected() {
        self.didSelectRecipe?(data.recipeID)
    }
    
}
