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
    
    var didReceiveError: ((Error) -> Void)?
    var didUpdate: ((RecipeTableViewCellViewModel) -> Void)?
    var didSelectRecipe: ((String) -> Void)?
    
    // MARK: Init
    
    init(recipe: RecipeDataForCell) {
        self.data = recipe
    }
    
}

// MARK: - CellRepresentable Protocol

extension RecipeTableViewCellViewModel: TableViewCellRepresentable {
    
    static func registerCell(tableView: UITableView) {
        RecipeTableViewCell.registerCell(tableView: tableView)
    }
    
    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = RecipeTableViewCell.dequeueCell(tableView: tableView, indexPath: indexPath)
        cell.setupCellData(viewModel: self)
        return cell
    }
    
    func cellSelected() {
        self.didSelectRecipe?(data.recipeID)
    }
    
}
