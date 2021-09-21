//
//  RecipesListViewController.swift
//  KODE-Recipes
//
//  Created by Developer on 10.09.2021.
//

import UIKit

class RecipesListViewController: UIViewController {
    
    // MARK: Properties
    
    let viewModel: RecipesListViewModel
    let alertView = ErrorPageView()
    
    private let tableView = UITableView()
//    private let searchBar = UISearchBar()
    private let searchController = UISearchController()
    
    private var filteredRecipes: [RecipeTableViewCellViewModel] = []
    private var currentSearchCase = SearchCase.all
    
    private var currentSortCase = SortCase.date {
        didSet {
            filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
            tableView.reloadData()
        }
    }
    
    init(viewModel: RecipesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    
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
        setupSearchController()

    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
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
        viewModel.didStartUpdating = { [weak self] in
            self?.didStartUpdating()
        }
        viewModel.didFinishUpdating = { [weak self] in
            self?.didFinishUpdating()
        }
        viewModel.didReceiveError = { [weak self] error in
            self?.didReceiveError(error)
        }
    }
    
    private func didFinishSuccessfully() {
        hideCustomAlert(alertView)
    }
    
    private func didStartUpdating() {
        // TODO: - Create and show activity indicator
    }
    
    private func didFinishUpdating() {
        // in case update was triggered by refreshing the table
        filteredRecipes = viewModel.filterRecipesForSearchText(searchText: searchController.searchBar.text, scope: currentSearchCase)
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)

        tableView.reloadData()
        
        hideCustomAlert(alertView)
    }
    
    private func didReceiveError(_ error: Error) {
        navigationController?.navigationBar.isHidden = true
        
        let title: String
        if let customError = error as? CustomError {
            title = customError.errorTitle
        } else {
            title = Constants.ErrorType.basic
        }
        
        showCustomAlert(alertView,
                        title: title,
                        message: error.localizedDescription,
                        buttonText: Constants.ButtonTitle.refresh)
    }
    
}

// MARK: SearchBar DataSource

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

// MARK: SearchBar Delegate

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
    
    // SearchBar Helpers
    
    private func hideSearchBar() {
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        searchController.searchBar.endEditing(true)
    }
    
    private func showSearchBar() {
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    private func resetSearchBar() {
        searchController.searchBar.text = ""
        filteredRecipes = viewModel.recipesViewModels
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        tableView.reloadData()
    }
    
    private func filterAndSort() {
        filteredRecipes = viewModel.filterRecipesForSearchText(searchText: searchController.searchBar.text, scope: currentSearchCase)
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        tableView.reloadData()
    }
    
}

// MARK: CustomAlertDisplaying Protocol

extension RecipesListViewController: CustomAlertDisplaying {
    
    func handleButtonTap() {
        viewModel.reloadData()
    }
    
}

// MARK: TableView Delegate

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
