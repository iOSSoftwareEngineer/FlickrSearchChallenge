//
//  FlickrSearchChallengeTests.swift
//  FlickrSearchChallengeTests
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation
import Testing
@testable import FlickrSearchChallenge
import Foundation
import Testing
@testable import FlickrSearchChallenge

struct FlickrSearchChallengeTests {

    // Test for successful image fetch
    @Test func testFetchImagesSuccess() async throws {
        let viewModel = FlickrSearchViewModel(flickrService: MockFlickrSearchService())
        
        // Wrapping the async call to ensure proper async handling
        await Task {
            await viewModel.searchImages(for: "test")
            
            #expect(viewModel.images.count == 2)
            #expect(viewModel.images[0].title == "Test Image 1")
            #expect(viewModel.isLoading == false)
            #expect(viewModel.errorMessage == nil)
        }.value // to ensure that the task completes before test finishes
    }

    // Test for invalid URL error
    @Test func testFetchImagesInvalidURLError() async throws {
        let viewModel = FlickrSearchViewModel(flickrService: MockFlickrSearchServiceInvalidURL())
        
        await Task {
            await viewModel.searchImages(for: "test")
            
            #expect(viewModel.images.isEmpty == true)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.errorMessage == "Invalid URL. Please check your search term.")
        }.value
    }

    // Test for network error (timeout)
    @Test func testFetchImagesNetworkError() async throws {
        let viewModel = FlickrSearchViewModel(flickrService: MockFlickrSearchServiceNetworkError())
        
        await Task {
            await viewModel.searchImages(for: "test")
            
            #expect(viewModel.images.isEmpty == true)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.errorMessage == "Network error: The request timed out.")
        }.value
    }

    // Test for HTTP error
    @Test func testFetchImagesHTTPError() async throws {
        let viewModel = FlickrSearchViewModel(flickrService: MockFlickrSearchServiceHTTPError())
        
        await Task {
            await viewModel.searchImages(for: "test")
            
            #expect(viewModel.images.isEmpty == true)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.errorMessage == "HTTP error: Received status code 500.")
        }.value
    }

    // Test for decoding error
    @Test func testFetchImagesDecodingError() async throws {
        let viewModel = FlickrSearchViewModel(flickrService: MockFlickrSearchServiceDecodingError())
        
        await Task {
            await viewModel.searchImages(for: "test")
            
            #expect(viewModel.images.isEmpty == true)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.errorMessage == "Failed to decode the response: The data couldn’t be read because it isn’t in the correct format..")
        }.value
    }

    // Test for invalid server response
    @Test func testFetchImagesInvalidResponse() async throws {
        let viewModel = FlickrSearchViewModel(flickrService: MockFlickrSearchServiceInvalidResponse())
        
        await Task {
            await viewModel.searchImages(for: "test")
            
            #expect(viewModel.images.isEmpty == true)
            #expect(viewModel.isLoading == false)
            #expect(viewModel.errorMessage == "Invalid response from the server.")
        }.value
    }
}
