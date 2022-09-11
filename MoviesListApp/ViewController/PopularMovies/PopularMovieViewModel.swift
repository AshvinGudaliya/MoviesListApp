//
//  PopularMovieViewModel.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 11/09/22.
//

import UIKit

//MARK: - PopularMovieViewModelDelegate
protocol PopularMovieViewModelDelegate: NSObjectProtocol {
    func reloadTableView()
    func fetchApiError(error: String)
}

class PopularMovieViewModel {
    
    var popularMovies: [MovieModel]
    private var currentPage: Int
    private var isApiRunning: Bool = false
    private var totalResults: Int?
    
    weak var delegate: PopularMovieViewModelDelegate?
    
    init(delegate: PopularMovieViewModelDelegate) {
        self.delegate = delegate

        popularMovies = [MovieModel]()
        currentPage = 1
    }
    
    func fetchPopularMovies() {
        
        guard !isApiRunning else { return }
        isApiRunning = true
        
        if let totalResults = totalResults {
            if totalResults < popularMovies.count {
                return
            }
        }
        
        NetworkManager.makeRequest(router: MoviesRouter.popularMovie(page: currentPage)) { [weak self] (result: Result<PopularMovieModel, NetworkError>) in
            
            switch result {
            case let .success(model):
                if let results = model.results {
                    self?.popularMovies.append(contentsOf: results)
                }
                self?.currentPage = (self?.currentPage ?? 1) + 1
                self?.delegate?.reloadTableView()
                
            case .failure(let error):
                self?.delegate?.fetchApiError(error: error.localizedDescription)
            }
            self?.isApiRunning = false
        }
    }
    
    func fetchNewPopularMovies(index: Int) {
        if index == popularMovies.count - 5 {
            fetchPopularMovies()
        }
    }
}
