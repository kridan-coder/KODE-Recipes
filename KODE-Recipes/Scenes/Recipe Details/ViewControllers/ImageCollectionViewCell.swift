//
//  ImageCollectionViewCell.swift
//  KODE-Recipes
//
//  Created by KriDan on 05.06.2021.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Self creating
    
    static func registerCell(collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
    
    static func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> ImageCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath)
            as? ImageCollectionViewCell ?? ImageCollectionViewCell()
        return cell
    }
    
    // MARK: - Properties
    
    private var imageLink: String! {
        didSet {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: imageLink), placeholder: UIImage.BaseTheme.placeholder)
        }
    }
    
    private var viewModel: ImageCollectionViewCellViewModel!
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
    }
    
    // MARK: - Public Methods
    
    func setupCellData(viewModel: ImageCollectionViewCellViewModel) {
        self.viewModel = viewModel
        imageLink = viewModel.data
        
        viewModel.didUpdate = self.setupCellData
    }
    
    // MARK: - Private Methods
    
    private func setupCellAppearance() {
        imageView.layer.cornerRadius = Constants.Design.cornerRadiusMain
        imageView.layer.borderWidth = Constants.Design.borderWidthMain
        imageView.layer.borderColor = UIColor.BaseTheme.tableBackground?.cgColor
    }
    
}
