//
//  Errors.swift
//  KODE-Recipes
//
//  Created by Developer on 09.09.2021.
//

import Foundation

protocol CustomError: Error {
    var errorTitle: String { get }
}

enum APIError: CustomError {
    case noInternet
    case basic
}

extension APIError {
    var errorTitle: String {
        switch self {
        case .noInternet:
            return Constants.ErrorType.noInternet
        default:
            return Constants.ErrorType.basic
        }
    }
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return Constants.ErrorText.noInternet
        default:
            return Constants.ErrorText.basic
        }
    }
}
