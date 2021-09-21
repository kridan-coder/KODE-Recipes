//
//  DifficultyView.swift
//  KODE-Recipes
//
//  Created by Developer on 21.09.2021.
//

import UIKit
import SnapKit

final class DifficultyView: UIView {
    
    private let difficultyImagesCollection = UIStackView()
    
    var difficulty: Int = 0 {
        didSet {
            difficultyImagesCollection.arrangedSubviews.forEach { view in
                difficultyImagesCollection.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            
            for _ in 0..<difficulty {
                let image = UIImage.difficultyTrue
                let imageView = UIImageView(image: image)
                difficultyImagesCollection.addArrangedSubview(imageView)
            }
            
            for _ in difficulty..<Constants.maxDifficultyStarAmount {
                let image = UIImage.difficultyFalse
                let imageView = UIImageView(image: image)
                difficultyImagesCollection.addArrangedSubview(imageView)
            }
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        initializeUI()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeUI() {
        setupDifficultyImagesCollection()
    }
    
    private func setupDifficultyImagesCollection() {
        difficultyImagesCollection.axis = .horizontal
        difficultyImagesCollection.distribution = .fillEqually
        difficultyImagesCollection.alignment = .leading
        difficultyImagesCollection.spacing = Constants.DifficultyImageCollection.spacing
    }
    
    private func createConstraints() {
        addSubview(difficultyImagesCollection)
        difficultyImagesCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

private extension Constants {
    
    static let maxDifficultyStarAmount = 5
    
    struct DifficultyImageCollection {
        static let spacing = CGFloat(20)
    }
}
