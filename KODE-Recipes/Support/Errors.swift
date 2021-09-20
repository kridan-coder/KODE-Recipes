//
//  Errors.swift
//  KODE-Recipes
//
//  Created by Developer on 09.09.2021.
//

import Foundation

enum ErrorType: Error {
    case noInternet
    case basic
}

extension ErrorType: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return Constants.ErrorText.noInternet
        case .basic:
            return Constants.ErrorText.basic
        }
    }
}
