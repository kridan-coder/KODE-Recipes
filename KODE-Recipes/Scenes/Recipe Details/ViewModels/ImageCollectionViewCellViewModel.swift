//
//  ImageCollectionViewCellModel.swift
//  KODE-Recipes
//
//  Created by KriDan on 06.06.2021.
//

import Foundation
import UIKit

final class ImageCollectionViewCellViewModel {
    
    // MARK: Properties
    
    let data: String
    
    // MARK: Actions
    
    var didReceiveError: ((String) -> Void)?
    var didUpdate: ((ImageCollectionViewCellViewModel) -> Void)?
    var didSelectImage: ((String) -> Void)?
    
    // MARK: Lifecycle
    
    init(imageLink: String) {
        self.data = imageLink
    }
    
}

extension ImageCollectionViewCellViewModel: CollectionViewCellRepresentable {
    
    static func registerCell(collectionView: UICollectionView) {
        RecipeCollectionViewCell.registerCell(collectionView: collectionView)
    }
    
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = RecipeCollectionViewCell.dequeueCell(collectionView: collectionView, indexPath: indexPath)
        cell.setupCellData(viewModel: self)
        return cell
    }
    
    func cellSelected() {
        self.didSelectImage?(data)
    }
    
}
