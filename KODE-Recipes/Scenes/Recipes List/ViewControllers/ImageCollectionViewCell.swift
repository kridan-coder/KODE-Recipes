//
//  ImageCollectionViewCell.swift
//  KODE-Recipes
//
//  Created by KriDan on 05.06.2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor(named: "TableBackgroundColor")?.cgColor
    }

}
