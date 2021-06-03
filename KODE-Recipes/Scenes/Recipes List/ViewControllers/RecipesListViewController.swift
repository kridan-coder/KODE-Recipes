//
//  RecipesListViewController.swift
//  KODE-Recipes
//
//  Created by KriDan on 03.06.2021.
//

import UIKit

class RecipesListViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    private func setSearchBarAppearance(){
        searchBar.backgroundImage = UIImage()
        
        let underline = CALayer()
        underline.frame = CGRect(x: 10, y: searchBar.frame.height, width: searchBar.frame.width - 20, height: 3)
        underline.cornerRadius = 1
        underline.backgroundColor = UIColor.white.cgColor
    
        searchBar.layer.addSublayer(underline)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSearchBarAppearance()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBarAppearance()

        // Do any additional setup after loading the view.
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
