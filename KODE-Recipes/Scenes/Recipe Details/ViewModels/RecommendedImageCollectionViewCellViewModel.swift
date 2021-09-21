//
//  RecommendationImageCollectionView.swift
//  KODE-Recipes
//
//  Created by Developer on 15.09.2021.
//

import UIKit

final class RecommendedImageCollectionViewCellViewModel {
    
    // MARK: Properties
    
    let imageLink: String
    let name: String
    private let uuid: String
    
    // MARK: Actions
    
    var didReceiveError: ((String) -> Void)?
    var didUpdate: ((RecommendedImageCollectionViewCellViewModel) -> Void)?
    var didSelectRecommendedRecipe: ((String) -> Void)?
    
    // MARK: Lifecycle
    
    init(name: String, imageLink: String, uuid: String) {
        self.name = name
        self.imageLink = imageLink
        self.uuid = uuid
    }
    
}

extension RecommendedImageCollectionViewCellViewModel: CollectionViewCellRepresentable {
    
    static func registerCell(collectionView: UICollectionView) {
        RecommendedCollectionViewCell.registerCell(collectionView: collectionView)
    }
    
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = RecommendedCollectionViewCell.dequeueCell(collectionView: collectionView, indexPath: indexPath)
        cell.setupCellData(viewModel: self)
        return cell
    }
    
    func cellSelected() {
        self.didSelectRecommendedRecipe?(uuid)
    }
    
}
