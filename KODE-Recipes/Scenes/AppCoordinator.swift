//
//  AppCoordinator.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    // MARK: Properties
    
    let window: UIWindow?
    let rootNavigationController: UINavigationController! = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.barTintColor = UIColor.BaseTheme.background
        return navigationController
    }()
    
    let apiClient: ApiClient
    //let databaseClient: DatabaseClient
    let repository: Repository
    
    // MARK: Coordinator
    
    init(window: UIWindow) {
        self.window = window
        apiClient = ApiClient()
        //databaseClient = DatabaseClient()
        repository = Repository(apiClient: apiClient)
    }
    
    override func start() {
        guard let window = window else {
            return
        }
        
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        
        // launching Recipes List Scene
        let recipeListCoordinator = RecipesListCoordinator(rootNavigationController: rootNavigationController, repository: repository)
        recipeListCoordinator.delegate = self
        addChildCoordinator(recipeListCoordinator)
        recipeListCoordinator.start()
    }
    
}
