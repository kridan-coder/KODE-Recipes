//
//  CellRepresentable.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import Foundation
import UIKit

protocol TableViewCellRepresentable {
    
    static func registerCell(tableView: UITableView)
        
    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    
    func cellSelected()
    
}

protocol CollectionViewCellRepresentable {
    
    static func registerCell(collectionView: UICollectionView)
        
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    
    func cellSelected()
    
}
