//
//  FlickrSearchChallengeTests.swift
//  FlickrSearchChallengeTests
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation
import Testing
@testable import FlickrSearchChallenge

struct FlickrSearchChallengeTests {

    // Test for successful image fetch
    @Test func testFetchImagesSuccess() async throws {
        let viewModel = await FlickrSearchViewModel(flickrService: MockFlickrSearchService())
        await viewModel.searchImages(for: "test")

        await #expect(viewModel.images.count == 2)
        await #expect(viewModel.images[0].title == "Test Image 1")
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == nil)
    }

    // Test for invalid URL error
    @Test func testFetchImagesInvalidURLError() async throws {
        let viewModel = await FlickrSearchViewModel(flickrService: MockFlickrSearchServiceInvalidURL())
        await viewModel.searchImages(for: "test")

        await #expect(viewModel.images.isEmpty == true)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == "Invalid URL. Please check your search term.")
    }

    // Test for network error (timeout)
    @Test func testFetchImagesNetworkError() async throws {
        let viewModel = await FlickrSearchViewModel(flickrService: MockFlickrSearchServiceNetworkError())
        await viewModel.searchImages(for: "test")

        await #expect(viewModel.images.isEmpty == true)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == "Network error: The request timed out.")
    }

    // Test for HTTP error
    @Test func testFetchImagesHTTPError() async throws {
        let viewModel = await FlickrSearchViewModel(flickrService: MockFlickrSearchServiceHTTPError())
        await viewModel.searchImages(for: "test")

        await #expect(viewModel.images.isEmpty == true)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == "HTTP error: Received status code 500.")
    }

    // Test for decoding error
    @Test func testFetchImagesDecodingError() async throws {
        let viewModel = await FlickrSearchViewModel(flickrService: MockFlickrSearchServiceDecodingError())
        await viewModel.searchImages(for: "test")

        await #expect(viewModel.images.isEmpty == true)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == "Failed to decode the response: The data couldn’t be read because it isn’t in the correct format..")
    }

    // Test for invalid server response
    @Test func testFetchImagesInvalidResponse() async throws {
        let viewModel = await FlickrSearchViewModel(flickrService: MockFlickrSearchServiceInvalidResponse())
        await viewModel.searchImages(for: "test")

        await #expect(viewModel.images.isEmpty == true)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == "Invalid response from the server.")
    }
}
