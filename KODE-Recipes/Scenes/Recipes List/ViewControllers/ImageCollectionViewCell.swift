//
//  ImageCollectionViewCell.swift
//  KODE-Recipes
//
//  Created by KriDan on 05.06.2021.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Private
    
    private var viewModel: ImageCollectionViewCellViewModel!
    
    // MARK: Properties
    
    private var imageLink: String! {
        didSet {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: imageLink), placeholder: UIImage(named: "Placeholder"))
        }
    }
    
    // MARK: Helpers
    
    private func setupCellAppearance() {
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor(named: "TableBackgroundColor")?.cgColor
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
