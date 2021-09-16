//
//  RecipesListViewController.swift
//  KODE-Recipes
//
//  Created by Developer on 10.09.2021.
//

import UIKit

class RecipesListViewController: UIViewController {
    
    // MARK: - Properties
    // TODO: - Get rid of implicitly unwrapped optional
    var viewModel: RecipesListViewModel!
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let searchController = UISearchController()
    
    private var filteredRecipes: [RecipeTableViewCellViewModel] = []
    
    private var currentSearchCase: SearchCase {
        get {
            // TODO: - Get rid of implicitly unwrapped optional
            SearchCase(rawValue: searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] ?? SearchCase.all.rawValue)!
        }
    }
    
    private var currentSortCase = SortCase.date {
        didSet {
            filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
            tableView.reloadData()
        }
    }
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = Constants.BackButton.text
        initializeUI()
        createConstraints()

        bindToViewModel()
        viewModel.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func sortByButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: Constants.ActionSheet.sortByName, style: .default) { _ in
            self.currentSortCase = .name
        })
        actionSheet.addAction(UIAlertAction(title: Constants.ActionSheet.sortByDate, style: .default) { _ in
            self.currentSortCase = .date
        })
        actionSheet.addAction(UIAlertAction(title: Constants.ActionSheet.cancel, style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func createConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func initializeUI() {
        view.backgroundColor = .white
        setupNavigationItem()
        setupTableView()

    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        RecipeTableViewCellViewModel.registerCell(tableView: self.tableView)
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.SortByButton.title,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(sortByButtonTapped))
        
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
    }
    
    private func bindToViewModel() {
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
    
    private func viewModelDidFinishUpdating() {
        // in case update was triggered by refreshing the table
        filteredRecipes = viewModel.filterRecipesForSearchText(searchText: searchBar.text, scope: currentSearchCase)
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)

        tableView.reloadData()
    }
    
    private func viewModelDidNotFindInternetConnection() {
        let alert = UIAlertController(title: Constants.ErrorType.noInternet,
                                      message: Constants.ErrorText.noInternetTable,
                                      preferredStyle: .alert)
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Cell.height
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

// MARK: - Constants

private extension Constants {
    struct SortByButton {
        static let title = "Sort by"
    }
    struct SearchBar {
        static let placeholder = "Search"
    }
    struct BackButton {
        static let text = "Back"
    }
    struct ActionSheet {
        static let sortByName = "Sort by Name"
        static let sortByDate = "Sort by Date"
        static let cancel = "Cancel"
    }
    struct Cell {
        static let height = CGFloat(180)
    }
    
}
