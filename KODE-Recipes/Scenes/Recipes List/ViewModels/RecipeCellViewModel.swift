//
//  RecipeCellViewModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

final class RecipeCellViewModel{
    let data: Recipe
    
    var didReceiveError: ((String) -> Void)?
    var didUpdate: ((RecipeCellViewModel) -> Void)?
    var didSelectRecipe: ((Recipe) -> Void)?
    
    init(recipe: Recipe){
        self.data = recipe
    }
    
}

extension RecipeCellViewModel: CellRepresentable{
    static func registerCell(tableView: UITableView) {
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
    }
    
    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        cell.setup(viewModel: self)
        return cell
    }
    
    func cellSelected() {
        self.didSelectRecipe?(data)
    }
    
    
}
