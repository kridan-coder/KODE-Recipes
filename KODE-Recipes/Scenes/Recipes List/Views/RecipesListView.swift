//
//  RecipesListViewController.swift
//  KODE-Recipes
//
//  Created by Developer on 09.09.2021.
//

import Foundation
import UIKit
import SnapKit

final class RecipesListView: UIView {
    
    // MARK: - Properties
    
    let navigationItem = UIView()
    
    private let sortByButton = UIButton(type: .system)
    private let searchBar = UISearchBar()
    private let recipesTableView = UITableView()
    
    // MARK: - Init
    
    init() {
        super.init(frame: CGRect.zero)
        initializeUI()
        createConstraints()
        setupTargets()
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    var didPressSortByButton: (() -> Void)?
    
    // MARK: - Actions
    
    @objc private func sortByButtonPressed() {
        didPressSortByButton?()
    }
    
    // MARK: - Private Methods
    
    private func createConstraints() {
        
    }
    
    private func setupTargets() {
        sortByButton.addTarget(self, action: #selector(sortByButtonPressed), for: .touchUpInside)
    }
    
    private func initializeUI() {
        setupSortByButton()
    }
    
    private func setupSortByButton() {
        sortByButton.setTitle(Constants.SortByButton.title, for: .normal)
        sortByButton.setTitleColor(.systemGray, for: .normal)
        
    }
    
}

private extension Constants {
    struct SortByButton {
        static let title = "Sort by"
    }
    struct SearchBar {
        static let placeholder = "Search"
    }
}


