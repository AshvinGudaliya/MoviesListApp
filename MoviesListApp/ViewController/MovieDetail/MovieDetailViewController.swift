//
//  MovieDetailViewController.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 11/09/22.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    private var viewModel: MovieDetailViewModel?
    var movieId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = MovieDetailViewModel(delegate: self)
        viewModel?.fetchMoviesDetails(withId: movieId)
    }
    
    private func updateUI(withMovieModel movieModel: MovieModel) {
        titleLabel.text = movieModel.title
        overviewLabel.text = movieModel.overview
        ratingLabel.text = String(format: "%.2f", movieModel.voteAverage ?? 0.0)
        
        iconImageView.loadImage(fromUrl: movieModel.imagePath(), placeholder: UIImage(named: "movies_placeholder"))
        
        if let date = Date(fromString: movieModel.releaseDate ?? "", format: "YYYY-MM-DD") {
            let formattedDate = date.toString(format: "DD MMM YYYY")
            releaseDateLabel.text = formattedDate
        } else {
            releaseDateLabel.text = ""
        }
    }
}

extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func reloadMovieData(model: MovieModel) {
        DispatchQueue.main.async {
            self.updateUI(withMovieModel: model)
        }
    }
    
    func fetchApiError(error: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: LocalizationString.Message.oops, message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizationString.Message.okay, style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
