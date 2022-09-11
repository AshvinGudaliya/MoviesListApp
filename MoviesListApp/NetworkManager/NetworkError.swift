//
//  NetworkError.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 10/09/22.
//

import UIKit

protocol MLLocalizedError: LocalizedError {
    var title: String { get }
    var localDescription: String { get } //useful in local parsing errors during debugging as their errorDescription would show generic message in the popup
}

extension MLLocalizedError {
    var title: String {
        return ""
    }
    var localDescription : String {
        return ""
    }
}

enum NetworkError: MLLocalizedError {
    case unauthorized
    case errorString(String)
    case error(code: Double?, message: String)
    case generic
    
    var errorDescription: String? {
        switch self {
        case .unauthorized: return LocalizationString.Message.tokenExpired
        case .errorString(let errorMessage): return errorMessage
        case .error(_,let message): return message
        case .generic: return LocalizationString.Message.generic
        }
    }
    
    var title: String {
        return LocalizationString.Message.error
    }
}
