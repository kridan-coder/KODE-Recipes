//
//  RecipesListViewController.swift
//  KODE-Recipes
//
//  Created by KriDan on 03.06.2021.
//

import UIKit

class RecipesListViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameDateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewActivityIndicator: UIActivityIndicatorView!
    
    // MARK: Elements set in code
    
    private var refreshControl = UIRefreshControl()
    
    // MARK: Public
    
    var viewModel: RecipesListViewModel!
    
    // MARK: Properties
    
    private var filteredRecipes: [RecipeTableViewCellViewModel] = []
    
    private var currentSearchCase: SearchCase {
        get {
            SearchCase(rawValue: searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] ?? SearchCase.all.rawValue)!
        }
    }
    
    private var currentSortCase: SortCase {
        get {
            SortCase(rawValue: nameDateSegmentedControl.selectedSegmentIndex) ?? .name
        }
    }
    
    // MARK: Helpers
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        RecipeTableViewCellViewModel.registerCell(tableView: self.tableView)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.scopeButtonTitles = [SearchCase.all.rawValue, SearchCase.name.rawValue, SearchCase.description.rawValue, SearchCase.instruction.rawValue]
        searchBar.selectedScopeButtonIndex = 0
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(RecipesListViewController.refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func setupAppearance() {
        tableView.layer.cornerRadius = Constants.Design.cornerRadiusSecondary
        searchBar.backgroundImage = UIImage()
        refreshControl.tintColor = UIColor.BaseTheme.cellBackground
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupSearchBar()
        setupTableView()
        setupRefreshControl()
        bindToViewModel()
        viewModel.reloadData()
    }
    
    // MARK: Actions
    
    @objc func refresh() {
        viewModel.reloadData()
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        tableView.reloadData()
    }
    
    private func startTableViewActivityIndicator() {
        tableViewActivityIndicator.isHidden = false
        tableViewActivityIndicator.startAnimating()
    }
    
    // MARK: ViewModel
    
    private func bindToViewModel() {
        viewModel.didStartUpdating = { [weak self] in
            self?.viewModelDidStartUpdating()
        }
        viewModel.didFinishUpdating = { [weak self] in
            self?.viewModelDidFinishUpdating()
        }
        viewModel.didNotFindInternetConnection = { [weak self] in
            self?.viewModelDidNotFindInternetConnection()
        }
        viewModel.didReceiveError = { [weak self] error in
            self?.viewModelDidReceiveError(error: error)
        }
    }
    
    private func viewModelDidStartUpdating() {
        startTableViewActivityIndicator()
    }
    
    private func viewModelDidFinishUpdating() {
        tableViewActivityIndicator.stopAnimating()
        
        // in case update was triggered by refreshing the table
        filteredRecipes = viewModel.filterRecipesForSearchText(searchText: searchBar.text, scope: currentSearchCase)
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        refreshControl.endRefreshing()
        
        tableView.reloadData()
    }
    
    private func viewModelDidNotFindInternetConnection() {
        let alert = UIAlertController(title: Constants.ErrorType.noInternet, message: Constants.ErrorText.noInternetTable, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.AlertActionTitle.ok, style: .default))
        present(alert, animated: true)
    }
    
    private func viewModelDidReceiveError(error: String) {
        let alert = UIAlertController(title: Constants.ErrorType.basic, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.AlertActionTitle.ok, style: .default))
        present(alert, animated: true)
    }
    
}

extension RecipesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        filteredRecipes[indexPath.row].dequeueCell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filteredRecipes[indexPath.row].cellSelected()
    }
    
}

extension RecipesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterAndSort()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showSearchBar()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        hideSearchBar()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearchBar()
        hideSearchBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterAndSort()
    }
    
    // MARK: SearchBar Helpers
    
    private func hideSearchBar() {
        searchBar.showsScopeBar = false
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    private func showSearchBar() {
        searchBar.showsScopeBar = true
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    private func resetSearchBar() {
        searchBar.text = ""
        filteredRecipes = viewModel.recipesViewModels
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        tableView.reloadData()
    }
    
    private func filterAndSort() {
        filteredRecipes = viewModel.filterRecipesForSearchText(searchText: searchBar.text, scope: currentSearchCase)
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        tableView.reloadData()
    }
    
}

extension RecipesListViewController: UITableViewDelegate {}
