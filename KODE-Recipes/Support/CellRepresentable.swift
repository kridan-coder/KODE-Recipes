//
//  CellRepresentable.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

protocol CellRepresentable {
    
    static func registerCell(tableView: UITableView)
    
    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    
    func cellSelected()
}
