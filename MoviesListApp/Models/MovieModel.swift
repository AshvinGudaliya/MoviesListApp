//
//  MovieModel.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 10/09/22.
//

import UIKit

//MARK: - MovieModel
struct MovieModel: Codable {
    let id: Int?
    let originalTitle, overview: String?
    let releaseDate: String?
    let status, title: String?
    let video: Bool?
    let posterPath: String?
    var voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case status, title, video
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
    
    func imagePath() -> String {
        
        guard let image = posterPath else {
            return ""
        }
        
        return URLConstant.imageURL + image
    }
}
