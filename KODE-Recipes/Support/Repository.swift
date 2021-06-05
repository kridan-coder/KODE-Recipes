//
//  Repository.swift
//  KODE-Recipes
//
//  Created by KriDan on 02.06.2021.
//

import Foundation
import SystemConfiguration

final class Repository{
    
    var apiClient: ApiClient?
    var databaseClient: DatabaseClient?
    
    init(apiClient: ApiClient, databaseClient: DatabaseClient) {
        self.apiClient = apiClient
        self.databaseClient = databaseClient
    }
    
    private func formatText(_ text: String?) -> String? {
        guard let text = text else {return nil}
        return text.replacingOccurrences(of: "<br>", with: "\n")
    }
    
    func recipeACtoRecipe(recipeAC: RecipeAC) -> Recipe {
        return Recipe(name: formatText(recipeAC.name!)!, imageLinks: recipeAC.images!, lastUpdated: recipeAC.lastUpdated!, description: formatText(recipeAC.description), instructions: formatText(recipeAC.instructions!)!, difficulty: recipeAC.difficulty!)
    }
    
    func isConnectedToNetwork() -> Bool{
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
    
}
