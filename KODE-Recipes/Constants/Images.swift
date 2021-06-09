//
//  Images.swift
//  KODE-Recipes
//
//  Created by KriDan on 09.06.2021.
//

import Foundation
import UIKit

extension UIImage {
    
    struct BaseTheme {
        static var placeholder: UIImage? { return UIImage(named: "Placeholder") }
        
        struct Difficulty {
            static var easy: UIImage? { return UIImage(named: "Difficulty1") }
            static var normal: UIImage? { return UIImage(named: "Difficulty2") }
            static var hard: UIImage? { return UIImage(named: "Difficulty3") }
            static var extreme: UIImage? { return UIImage(named: "Difficulty4") }
            static var insane: UIImage? { return UIImage(named: "Difficulty5") }
            static var unknown: UIImage? { return UIImage(named: "DifficultyUnknown") }
        }
    }
    
}
