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
    
    func sortRecipesBy(sortCase: SortCase){
 
        switch sortCase {

        case .name:
            filteredRecipes.sort{x, y in
                return x.data.name < y.data.name
            }
        case .date:
            filteredRecipes.sort{x, y in
                return x.data.lastUpdated < y.data.lastUpdated
            }
        }

        
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
 
        if sender.selectedSegmentIndex == SortCase.name.rawValue {
            sortRecipesBy(sortCase: .name)
        }
        else if sender.selectedSegmentIndex == SortCase.date.rawValue {
            sortRecipesBy(sortCase: .date)
        }

        tableView.reloadData()
    }
    
    
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
        
        searchBar.scopeButtonTitles = [SearchCase.all.rawValue, SearchCase.name.rawValue, SearchCase.description.rawValue, SearchCase.instruction.rawValue]
        
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
            self?.activityIndicator.isHidden = false
            self?.activityIndicator.startAnimating()
        }
        viewModel.didFinishUpdating = {[weak self] in
            self?.activityIndicator.stopAnimating()
            self?.filteredRecipes = self?.viewModel.recipesViewModels ?? []
            self?.sortRecipesBy(sortCase: .name)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filteredRecipes[indexPath.row].cellSelected()
    }
}

extension RecipesListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRecipes = []

        if searchText == ""{
            self.filteredRecipes = self.viewModel.recipesViewModels ?? []
        }
        else {
            filterContentForSearchText(searchText, scope: SearchCase(rawValue: searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] ?? SearchCase.all.rawValue)! )
        }
        
        tableView.reloadData()

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
        self.filteredRecipes = self.viewModel.recipesViewModels ?? []
        tableView.reloadData()
        searchBarShouldEndEditing(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarShouldEndEditing(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text ?? "", scope: SearchCase(rawValue: searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] ?? SearchCase.all.rawValue)! )
        tableView.reloadData()
    }
}

extension RecipesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }


    private func filterContentForSearchText(_ searchText: String, scope: SearchCase = SearchCase.all) {
        
        guard searchText != "" else {return}
        
        switch scope {
        case .name:

            filteredRecipes = viewModel.recipesViewModels.filter{(recipe) -> Bool in
                return recipe.data.name.lowercased().contains(searchText.lowercased())
            }
            
        case .description:
            filteredRecipes = viewModel.recipesViewModels.filter{(recipe) -> Bool in
                return (recipe.data.description?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        
        case .instruction:
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
        
        
        
    }
}
