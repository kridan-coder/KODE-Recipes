//
//  ImageCollectionViewCell.swift
//  KODE-Recipes
//
//  Created by KriDan on 05.06.2021.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: Self creating
    
    static func registerCell(collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
    
    static func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> ImageCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            return ImageCollectionViewCell()
        }
        return cell
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Private
    
    private var viewModel: ImageCollectionViewCellViewModel!
    
    // MARK: Properties
    
    private var imageLink: String! {
        didSet {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: imageLink), placeholder: UIImage.BaseTheme.placeholder)
        }
    }
    
    // MARK: Helpers
    
    private func setupCellAppearance() {
        imageView.layer.cornerRadius = Constants.Design.cornerRadiusMain
        imageView.layer.borderWidth = Constants.Design.borderWidthMain
        imageView.layer.borderColor = UIColor.BaseTheme.tableBackground?.cgColor
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
    }
    
    // MARK: Actions
    
    func setupCellData(viewModel: ImageCollectionViewCellViewModel) {
        self.viewModel = viewModel
        imageLink = viewModel.data
        
        viewModel.didUpdate = self.setupCellData
    }
    
}
