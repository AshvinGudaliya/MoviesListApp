//
//  LatestMovieTests.swift
//  MoviesListAppTests
//
//  Created by Ashvin Gudaliya on 11/09/22.
//

import XCTest
@testable import MoviesListApp

class LatestMovieTests: XCTestCase {

    var viewModel: MockLatestMovieViewModel?
    
    var delegate: MockLatestMovieViewModelDelegate = MockLatestMovieViewModelDelegate()
    
    override func setUp() {
        super.setUp()
        viewModel = MockLatestMovieViewModel(delegate: delegate)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testWithSuccessResponse() {
        
        viewModel?.fetchLatestMovies()
        XCTAssert(delegate.finishWithSuccess, "Fetch successfully")
    }
    
    func testWithErrorOnApi() {
        viewModel?.updateError = NetworkError.generic
        viewModel?.fetchLatestMovies()
        XCTAssertTrue(delegate.errorMessage == NetworkError.generic.errorDescription)
        XCTAssertTrue(delegate.finishWithErrorOccurred)
    }
    
    func testLatestMoviesDataCount() {
        viewModel?.fetchLatestMovies()
        XCTAssertTrue(viewModel?.latestMovies.count == 1)
    }
}

//MARK: - MockLatestMovieViewModel
class MockLatestMovieViewModelDelegate: NSObject, LatestMovieViewModelDelegate {
    
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

class MockLatestMovieViewModel: LatestMovieViewModel {
    
    var updateError: NetworkError?
    
    override func fetchLatestMovies() {
        
        if let updateError = updateError {
            delegate?.fetchApiError(error: updateError.localizedDescription)
        }
        
        let jsonData = JSONHelper.loadJson(filename: "LatestMovie")
        
        do {
            let decodedResponse = try JSONDecoder().decode(MovieModel.self, from: jsonData)
            self.latestMovies.append(decodedResponse)
            delegate?.reloadTableView()
        } catch {
            delegate?.fetchApiError(error: error.localizedDescription)
        }
    }
}
