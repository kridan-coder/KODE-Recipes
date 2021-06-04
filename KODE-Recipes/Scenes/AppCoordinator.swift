//
//  AppCoordinator.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: Properties
    
    let window: UIWindow?
    
    lazy var rootNavigationController: UINavigationController = {
        
        //let navigationController =

        //navigationController.navigationBar.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        return UINavigationController()
    }()
    
    let apiClient: ApiClient
    let databaseClient: DatabaseClient
    let repository: Repository
    
    
    // MARK: Coordinator
    
    init(window: UIWindow) {
        self.window = window
        
        apiClient = ApiClient()
        databaseClient = DatabaseClient()
        repository = Repository(apiClient: apiClient, databaseClient: databaseClient)
    }
    
    override func start(){
        guard let window = window else {return}
        
        window.rootViewController = self.rootNavigationController
        window.makeKeyAndVisible()
        
        let recipeListCoordinator = RecipesListCoordinator(rootNavigationController: rootNavigationController, apiClient: apiClient, databaseClient: databaseClient, repository: repository)
        
        addChildCoordinator(recipeListCoordinator)
        
        recipeListCoordinator.start()
    }
    
}
