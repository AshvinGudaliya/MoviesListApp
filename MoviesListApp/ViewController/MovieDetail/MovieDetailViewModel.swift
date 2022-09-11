//
//  MovieDetailViewModel.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 11/09/22.
//

import UIKit

protocol MovieDetailViewModelDelegate: NSObjectProtocol {
    func reloadMovieData(model: MovieModel)
    func fetchApiError(error: String)
}

class MovieDetailViewModel: NSObject {
    
    weak var delegate: MovieDetailViewModelDelegate?
    
    init(delegate: MovieDetailViewModelDelegate) {
        self.delegate = delegate
    }
    
    func fetchMoviesDetails(withId movieId: Int) {
        NetworkManager.makeRequest(router: MoviesRouter.movieDetail(id: movieId)) { [weak self] (result: Result<MovieModel, NetworkError>) in
            switch result {
            case let .success(model):
                self?.delegate?.reloadMovieData(model: model)
                
            case .failure(let error):
                self?.delegate?.fetchApiError(error: error.localizedDescription)
            }
        }
    }
}
