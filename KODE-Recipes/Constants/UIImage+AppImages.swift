//
//  UIImage+AppImages.swift
//  KODE-Recipes
//
//  Created by Developer on 21.09.2021.
//

import UIKit

extension UIImage {
    static var difficultyTrue: UIImage {
        return UIImage(named: "DifficultyTrue") ?? UIImage()
    }
    static var difficultyFalse: UIImage {
        return UIImage(named: "DifficultyFalse") ?? UIImage()
    }
}
