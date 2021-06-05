//
//  RecipeViewController.swift
//  KODE-Recipes
//
//  Created by KriDan on 04.06.2021.
//

import UIKit
import Kingfisher

class RecipeViewController: UIViewController {

    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var difficultyLevelImage: UIImageView!
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    var viewModel: RecipeViewModel!
    
    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
    
    private func setAppearance(){
        
        pageControl.numberOfPages = viewModel.recipe.imageLinks.count
        
        difficultyLevelImage.layer.cornerRadius = 15
        difficultyLevelImage.layer.borderWidth = 1
        difficultyLevelImage.layer.borderColor = UIColor(named: "TableBackgroundColor")?.cgColor
            
        instructionsTextView.layer.cornerRadius = 15
        descriptionTextView.layer.cornerRadius = 15
        
        recipeNameLabel.text = viewModel.recipe.name
        
        if let description = viewModel.recipe.description {
            descriptionTextView.text = description
        }
        else {
            descriptionTextView.text = "No description provided."
        }
        
        instructionsTextView.text = viewModel.recipe.instructions
        
        let date = Date(timeIntervalSince1970: viewModel.recipe.lastUpdated)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a, EEEE, MMM d, yyyy"
        lastUpdateLabel.text = "Last Recipe Update:\n \(formatter.string(from: date)) "

        
        switch viewModel.recipe.difficulty {
        case 1:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.easy.rawValue)
        case 2:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.normal.rawValue)
        case 3:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.hard.rawValue)
        case 4:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.extreme.rawValue)
        case 5:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.insane.rawValue)
        default:
            difficultyLevelImage.image = UIImage(named: DifficultyLevel.easy.rawValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        setUpCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(RecipeViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

        
   
    
    @objc func rotated(){
        collectionView.collectionViewLayout.invalidateLayout()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecipeViewController: UICollectionViewDelegate{

    // TODO: Not sure that this function is a nice decision. Need to rethink and make it work faster
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
    }
    
}

extension RecipeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recipe.imageLinks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: URL(string: viewModel.recipe.imageLinks[indexPath.row]))
        
//        let image = UIImageView()
//        image.layer.cornerRadius = 15
//        image.kf.indicatorType = .activity
//        image.kf.setImage(with: URL(string: viewModel.recipe.imageLinks[indexPath.row]))
//        cell.addSubview(image)
        return cell
    }
}

extension RecipeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }

}
