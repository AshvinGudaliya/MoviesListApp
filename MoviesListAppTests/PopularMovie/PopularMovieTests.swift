//
//  PopularMovieTests.swift
//  MoviesListAppTests
//
//  Created by Ashvin Gudaliya on 11/09/22.
//

import XCTest
@testable import MoviesListApp

class PopularMovieTests: XCTestCase {

    var viewModel: MockPopularMovieViewModel?
    
    var delegate: MockPopularMovieViewModelDelegate = MockPopularMovieViewModelDelegate()
    
    override func setUp() {
        super.setUp()
        viewModel = MockPopularMovieViewModel(delegate: delegate)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testWithSuccessResponse() {
        
        viewModel?.fetchPopularMovies()
        XCTAssert(delegate.finishWithSuccess, "Fetch successfully")
    }
    
    func testWithErrorOnApi() {
        viewModel?.updateError = NetworkError.generic
        viewModel?.fetchPopularMovies()
        XCTAssertTrue(delegate.errorMessage == NetworkError.generic.errorDescription)
        XCTAssertTrue(delegate.finishWithErrorOccurred)
    }
    
    func testPopularMoviesDataCount() {
        viewModel?.fetchPopularMovies()
        XCTAssertTrue(viewModel?.popularMovies.count != 0)
        XCTAssert(viewModel?.popularMovies.count == 20, "Populer movies is not equal to 20")
    }
}

//MARK: - MockPopularMovieViewModel
class MockPopularMovieViewModelDelegate: NSObject, PopularMovieViewModelDelegate {
    
    var finishWithSuccess = false
    var finishWithErrorOccurred = false
    var errorMessage: String = ""
    
    func reloadTableView() {
        finishWithSuccess = true
    }
    
    func fetchApiError(error: String) {
        finishWithErrorOccurred = true
        errorMessage = error
    }
}

class MockPopularMovieViewModel: PopularMovieViewModel {
    
    var updateError: NetworkError?
    
    override func fetchPopularMovies() {
        
        if let updateError = updateError {
            delegate?.fetchApiError(error: updateError.localizedDescription)
        }
        
        let jsonData = JSONHelper.loadJson(filename: "PopularMovie")
        
        do {
            let decodedResponse = try JSONDecoder().decode(PopularMovieModel.self, from: jsonData)
            self.popularMovies = decodedResponse.results ?? []
            delegate?.reloadTableView()
        } catch {
            delegate?.fetchApiError(error: error.localizedDescription)
        }
    }
}
