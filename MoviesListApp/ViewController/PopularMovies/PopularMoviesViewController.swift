//
//  PopularMoviesViewController.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 11/09/22.
//

import UIKit

class PopularMoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    private var viewModel: PopularMovieViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.title = "Popular Movies"
    }
    
    private func setupView() {
        viewModel = PopularMovieViewModel(delegate: self)
        viewModel?.fetchPopularMovies()
        
        tableView.registerNib(MovieListTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.hideEmptyCells()
    }
    
    private func hideNoRecoredLabel(with hide: Bool) {
        tableView.isHidden = !hide
        noDataFoundLabel.isHidden = hide
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource
extension PopularMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.popularMovies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: MovieListTableViewCell.self, for: indexPath)
        guard let movieData = viewModel?.popularMovies[indexPath.row] else { return cell }
        cell.configure(withMovieData: movieData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieModel = viewModel?.popularMovies[indexPath.row],
              let movieId = movieModel.id else {
            return
        }
        
        let detailViewController = Storyboard.Main.instantiateViewController(withViewClass: MovieDetailViewController.self)
        detailViewController.movieId = movieId
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel?.fetchNewPopularMovies(index: indexPath.row)
    }
}

// MARK: - PopularMovieViewModelDelegate
extension PopularMoviesViewController: PopularMovieViewModelDelegate {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.hideNoRecoredLabel(with: true)
            
            self.tableView.reloadData()
        }
    }
    
    func fetchApiError(error: String) {
        DispatchQueue.main.async {
            self.hideNoRecoredLabel(with: false)
            let alert = UIAlertController(title: LocalizationString.Message.oops, message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizationString.Message.okay, style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
