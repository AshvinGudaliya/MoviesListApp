//
//  LatestMovieViewModel.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 10/09/22.
//

import UIKit

//MARK: - LatestMovieViewModelDelegate
protocol LatestMovieViewModelDelegate: NSObjectProtocol {
    func reloadTableView()
    func fetchApiError(error: String)
}

class LatestMovieViewModel: NSObject {
    
    var latestMovies: [MovieModel]

    weak var delegate: LatestMovieViewModelDelegate?
    
    init(delegate: LatestMovieViewModelDelegate) {
        self.delegate = delegate
        self.latestMovies = [MovieModel]()
    }
    
    func fetchLatestMovies() {
        NetworkManager.makeRequest(router: MoviesRouter.latestMovie) { [weak self] (result: Result<MovieModel, NetworkError>) in
            switch result {
            case let .success(model):
                self?.latestMovies.append(model)
                self?.delegate?.reloadTableView()
                
            case .failure(let error):
                self?.delegate?.fetchApiError(error: error.localizedDescription)
            }
        }
    }
}



