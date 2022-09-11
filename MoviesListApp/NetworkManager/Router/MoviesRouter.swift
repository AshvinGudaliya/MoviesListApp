//
//  MoviesRouter.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 10/09/22.
//

import UIKit

enum MoviesRouter: HTTPRouter {
    
    case latestMovie
    case popularMovie(page: Int)
    case movieDetail(id: Int)
    
    var path: String {
        switch self {
        case .latestMovie: return "3/movie/latest"
        case .popularMovie: return "3/movie/popular"
        case .movieDetail(let id): return "3/movie/\(id)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String : String]? {
        switch self {
        case .popularMovie(let page):
            return ["page": page.description]
        default: return nil
        }
    }
    
    var header: [String: String]? {
        return [
            "Authorization": "Bearer \(Constant.accessToken)",
            "Content-Type": "application/json;charset=utf-8"
        ]
    }
}
