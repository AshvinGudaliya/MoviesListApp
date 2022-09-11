//
//  PopularMovieModel.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 10/09/22.
//

import UIKit

//MARK: - PopularMovieModel
struct PopularMovieModel: Codable {
    var page: Int?
    var results: [MovieModel]?
    var totalResults: Int?
    var totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results, page
    }
}
