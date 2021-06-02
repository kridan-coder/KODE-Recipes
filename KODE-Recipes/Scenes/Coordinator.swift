//
//  Coordinator.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation

class Coordinator{
    
    
    private(set) var childCoordinators: [Coordinator] = []
    
    func start(){
        preconditionFailure("\(#function) method needs to be overriden by concrete subclass.")
    }
    
    func finish(){
        preconditionFailure("\(#function) method needs to be overriden by concrete subclass.")
    }
    
    func addChildCoordinator(_ coordinator: Coordinator){
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator){
        if let index = childCoordinators.firstIndex(of: coordinator){
            childCoordinators.remove(at: index)
        }
        else {
            print("Could not remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }
    
    func removeAllChildCoordinatorsWithType<T: Coordinator>(type: T.Type){
        childCoordinators = childCoordinators.filter{$0 is T == false}
    }
    
    func removeAllChildCoordinators(){
        childCoordinators.removeAll()
    }
    
}

extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }

}
