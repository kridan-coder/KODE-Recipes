//
//  RecipesListViewController.swift
//  KODE-Recipes
//
//  Created by KriDan on 03.06.2021.
//

import UIKit

class RecipesListViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var filteredRecipes: [RecipeCellViewModel] = []
    

    
    var viewModel: RecipesListViewModel!
    
    private func setTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 5
        
        RecipeCellViewModel.registerCell(tableView: self.tableView)
        
        
        //tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        
    }
    
    private func setSearchBar(){
        
        searchBar.delegate = self
        
        
        searchBar.backgroundImage = UIImage()
        
        searchBar.scopeButtonTitles = [SearchCase.All.rawValue, SearchCase.Name.rawValue, SearchCase.Description.rawValue, SearchCase.Instruction.rawValue]
        
        searchBar.selectedScopeButtonIndex = 0
    }
    

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        setSearchBar()
        setTableView()
        bindToViewModel()
        
        viewModel.reloadData()

    }

    private func bindToViewModel(){
        viewModel.didStartUpdating = {[weak self] in
            self?.activityIndicator.startAnimating()
        }
        viewModel.didFinishUpdating = {[weak self] in
            self?.activityIndicator.stopAnimating()
            self?.filteredRecipes = self?.viewModel.recipesViewModels ?? []
            self?.tableView.reloadData()
        }
        
    }


}

extension RecipesListViewController: UITableViewDelegate {}

extension RecipesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return filteredRecipes[indexPath.row].dequeueCell(tableView: tableView, indexPath: indexPath)
    }
}

extension RecipesListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRecipes = []

  

//        for recipe in recipes {
//
//        }

    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = true
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = false
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBarShouldEndEditing(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarShouldEndEditing(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}

extension RecipesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }


    private func filterContentForSearchText(_ searchText: String, scope: SearchCase = SearchCase.All) {
        
        switch scope {
        case .Name:

            filteredRecipes = viewModel.recipesViewModels.filter{(recipe) -> Bool in
                return recipe.data.name.lowercased().contains(searchText.lowercased())
            }
            
        case .Description:
            filteredRecipes = viewModel.recipesViewModels.filter{(recipe) -> Bool in
                return (recipe.data.description?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        
        case .Instruction:
            filteredRecipes = viewModel.recipesViewModels.filter{(recipe) -> Bool in
                return recipe.data.instructions.lowercased().contains(searchText.lowercased())
            }
        default:
            filteredRecipes = viewModel.recipesViewModels.filter{(recipe) -> Bool in
                return recipe.data.name.lowercased().contains(searchText.lowercased()) ||
                    (recipe.data.description?.lowercased().contains(searchText.lowercased()) ?? false) ||
                    recipe.data.instructions.lowercased().contains(searchText.lowercased())
                
                
            }
        }
        
        tableView.reloadData()
        
    }
}
