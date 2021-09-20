//
//  RecipesListViewController.swift
//  KODE-Recipes
//
//  Created by KriDan on 03.06.2021.
//

import UIKit

class RecipesListViewController: UIViewController {
    
    // MARK: Properties
    
    let viewModel: RecipesListViewModel
    
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
    
    // Elements set in code
    private let refreshControl = UIRefreshControl()
    private let alertView = ErrorPageView()
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var nameDateSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewActivityIndicator: UIActivityIndicatorView!
    
    // MARK: Init
    
    init(viewModel: RecipesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "RecipesListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupSearchBar()
        setupTableView()
        setupRefreshControl()
        bindToViewModel()
        viewModel.reloadData()
        setupCustomAlert(alertView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            removeCustomAlert(alertView)
        }
    }
    
    // MARK: Actions
    
    @objc private func refresh() {
        viewModel.reloadData()
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        tableView.reloadData()
    }
    
    // MARK: Private Methods
    
    private func startTableViewActivityIndicator() {
        tableViewActivityIndicator.isHidden = false
        tableViewActivityIndicator.startAnimating()
    }
    
    // UI setup
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
    
    // ViewModel binding
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
        viewModel.didFinishSuccessfully = { [weak self]  in
            self?.didFinishSuccessfully()
        }
    }
    
    private func didFinishSuccessfully() {
        hideCustomAlert(alertView)
    }
    
    private func didStartUpdating() {
        startTableViewActivityIndicator()
    }
    
    private func didFinishUpdating() {
        tableViewActivityIndicator.stopAnimating()
        
        // in case update was triggered by refreshing the table
        filteredRecipes = viewModel.filterRecipesForSearchText(searchText: searchBar.text, scope: currentSearchCase)
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        refreshControl.endRefreshing()
        
        tableView.reloadData()
    }
    
    private func didNotFindInternet() {
        navigationController?.navigationBar.isHidden = true
        showCustomAlert(alertView, title: Constants.ErrorType.noInternet, message: Constants.ErrorText.noInternet, buttonText: Constants.ButtonTitle.refresh)
    }
    
    private func didReceiveError(_ error: Error) {
        showCustomAlert(alertView, title: Constants.ErrorType.basic, message: error.localizedDescription, buttonText: Constants.ButtonTitle.refresh)
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

// MARK: CustomAlertDisplaying Protocol

extension RecipesListViewController: CustomAlertDisplaying {
    
    func handleButtonTap() {
        viewModel.reloadData()
    }
    
}

// MARK: TableView Delegate

extension RecipesListViewController: UITableViewDelegate {}
