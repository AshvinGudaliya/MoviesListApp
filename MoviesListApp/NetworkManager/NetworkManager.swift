//
//  NetworkManager.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 10/09/22.
//

import UIKit

class NetworkManager: NSObject {

    static func makeRequest<T: Codable>(router: HTTPRouter, handler: @escaping (Result<T, NetworkError>) -> ()) {
        NetworkManager.log(request: router.request)
        MoviesProgress.shared.showProgress()
        let task = URLSession.shared.dataTask(with: router.request) { data, response, error in
            
            MoviesProgress.shared.hideProgress()
            guard let response = response as? HTTPURLResponse else {
                return handler(.failure(.generic))
            }
            
            NetworkManager.log(data: data, response: response, error: error)
            
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    handler(.success(decodedResponse))
                } catch let err {
                    handler(.failure(.errorString(err.localizedDescription)))
                }
            } else if response.statusCode == 401 {
                handler(.failure(.unauthorized))
            } else if let error = error {
                handler(.failure(.errorString(error.localizedDescription)))
            }
        }
            
        task.resume()
    }
    
    class func log(request: URLRequest){

        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)

        let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"

        var requestLog = "\n---------- OUT ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            requestLog += "\n\(bodyString)\n"
        }

        requestLog += "\n------------------------->\n";
        print(requestLog)
    }

    class func log(data: Data?, response: HTTPURLResponse?, error: Error?){

        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")

        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"

        var responseLog = "\n<---------- IN ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }

        if let statusCode =  response?.statusCode{
            responseLog += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        if let host = components?.host{
            responseLog += "Host: \(host)\n"
        }
        for (key,value) in response?.allHeaderFields ?? [:] {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            responseLog += "\n\(bodyString)\n"
        }
        if let error = error{
            responseLog += "\nError: \(error.localizedDescription)\n"
        }

        responseLog += "<------------------------\n";
        print(responseLog)
    }
}
