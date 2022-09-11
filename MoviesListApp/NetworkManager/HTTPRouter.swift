//
//  HTTPRouter.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 10/09/22.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol HTTPRouter {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: String]? { get }
    var headers: [String: String]? { get }
    var request: URLRequest { get }
}

extension HTTPRouter {
    
    
    var baseURL: String {
        return "https://api.themoviedb.org/"
    }
    
    var url: URL {
        return URL(string: baseURL + path)!
    }
    
    var parameters: [String: String]? {
        return nil
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
    var request: URLRequest {
        
        var urlRequest = URLRequest(url: url)
        
        if var urlComponents = URLComponents(string: url.absoluteString) {
            var queryItems = [URLQueryItem(name: "api_key", value: Constant.apiKey),
                              URLQueryItem(name: "language", value: "en-US")]
            if let params = parameters {
                queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
            }
            urlComponents.queryItems = queryItems
            
            if let url = urlComponents.url {
                urlRequest = URLRequest(url: url)
            }
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return urlRequest
    }
}
