//
//  MovieDetailTests.swift
//  MoviesListAppTests
//
//  Created by Ashvin Gudaliya on 11/09/22.
//

import XCTest
@testable import MoviesListApp

class MovieDetailTests: XCTestCase {

    var viewModel: MockMovieDetailViewModel?
    
    var delegate: MockMovieDetailViewModelDelegate = MockMovieDetailViewModelDelegate()
    
    override func setUp() {
        super.setUp()
        viewModel = MockMovieDetailViewModel(delegate: delegate)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testWithSuccessResponse() {
        viewModel?.fetchMoviesDetails(withId: 616037)
        XCTAssert(delegate.finishWithSuccess, "Fetch successfully")
        XCTAssertNotNil(delegate.model, "Movie details not found")
    }
    
    func testWithErrorOnApi() {
        viewModel?.updateError = NetworkError.generic
        viewModel?.fetchMoviesDetails(withId: 616037)
        XCTAssertTrue(delegate.errorMessage == NetworkError.generic.errorDescription)
        XCTAssertTrue(delegate.finishWithErrorOccurred)
    }
    
    func testMovieDetailsDataCount() {
        viewModel?.fetchMoviesDetails(withId: 616037)
    }
}

//MARK: - MockMovieDetailViewModel
class MockMovieDetailViewModelDelegate: NSObject, MovieDetailViewModelDelegate {
    
    var model: MovieModel?
    var finishWithSuccess = false
    var finishWithErrorOccurred = false
    var errorMessage: String = ""
    
    func reloadMovieData(model: MovieModel) {
        self.model = model
        finishWithSuccess = true
    }
    
    func fetchApiError(error: String) {
        finishWithErrorOccurred = true
        errorMessage = error
    }
}

class MockMovieDetailViewModel: MovieDetailViewModel {
    
    var updateError: NetworkError?
    
    override func fetchMoviesDetails(withId movieId: Int) {
        
        if let updateError = updateError {
            delegate?.fetchApiError(error: updateError.localizedDescription)
        }
        
        let jsonData = JSONHelper.loadJson(filename: "MovieDetail")
        
        do {
            let movieModel = try JSONDecoder().decode(MovieModel.self, from: jsonData)
            delegate?.reloadMovieData(model: movieModel)
        } catch {
            delegate?.fetchApiError(error: error.localizedDescription)
        }
    }
}
