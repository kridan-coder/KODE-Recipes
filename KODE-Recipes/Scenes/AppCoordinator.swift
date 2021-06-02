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
        return UINavigationController(rootViewController: UIViewController())
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
    }
    
}
