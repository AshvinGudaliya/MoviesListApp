//
//  MovieListTableViewCell.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 10/09/22.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deatilsContentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        deatilsContentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        deatilsContentView.layer.shadowOpacity = 0.4
        deatilsContentView.layer.shadowRadius = 5
        deatilsContentView.layer.cornerRadius = 4
        deatilsContentView.layer.masksToBounds =  false
        selectionStyle = .none
    }
    
    func configure(withMovieData movieData: MovieModel) {
        
        titleLabel.text = movieData.title
        overviewLabel.text = movieData.overview
        iconImageView.loadImage(fromUrl: movieData.imagePath(), placeholder: UIImage(named: "movies_placeholder"))
        
        if let date = Date(fromString: movieData.releaseDate ?? "", format: "YYYY-MM-DD") {
            let formattedDate = date.toString(format: "DD MMM YYYY")
            releaseDateLabel.text = formattedDate
        } else {
            releaseDateLabel.text = ""
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.roundedCorners(corners: [.bottomLeft, .topLeft], radius: 4)
    }
}
