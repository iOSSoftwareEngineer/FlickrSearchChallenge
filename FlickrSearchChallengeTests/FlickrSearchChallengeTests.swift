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

    class MockFlickrService: FlickrServiceProtocol {
        func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
            return [
                FlickrImage(
                    title: "Test Image 1",
                    link: "http://example.com/1",
                    media: FlickrImage.Media(m: "http://example.com/image1.jpg"),
                    description: "A beautiful image of nature.",
                    author: "John Doe",
                    published: "2024-09-23T12:34:56Z"
                ),
                FlickrImage(
                    title: "Test Image 2",
                    link: "http://example.com/2",
                    media: FlickrImage.Media(m: "http://example.com/image2.jpg"),
                    description: "An amazing view of the mountains.",
                    author: "Jane Smith",
                    published: "2024-08-01T09:12:45Z"
                )
            ]
        }
    }

    // Define a failure mock to simulate an error response
    class MockFlickrServiceFailure: FlickrServiceProtocol {
        func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
            throw URLError(.badServerResponse)
        }
    }

    // Test for successful image fetch
    @Test func testFetchImagesSuccess() async throws {
        let viewModel = await FlickrSearchViewModel(flickrService: MockFlickrService())
        await viewModel.searchImages(for: "test")

        await #expect(viewModel.images.count == 2)
        await #expect(viewModel.images[0].title == "Test Image 1")
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == nil)
    }

    // Test for failure scenario
    @Test func testFetchImagesFailure() async throws {
        let viewModel = await FlickrSearchViewModel(flickrService: MockFlickrServiceFailure())
        await viewModel.searchImages(for: "test")

        await #expect(viewModel.images.isEmpty == true)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage != nil)
    }
}
