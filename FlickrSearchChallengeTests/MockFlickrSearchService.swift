//
//  MockFlickrSearchService.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation
import Testing
@testable import FlickrSearchChallenge

internal class MockFlickrSearchService: FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 1 second delay to simulate network
        return [
            FlickrImage(
                title: "Test Image 1",
                link: "http://example.com/1",
                media: FlickrImage.Media(m: "http://example.com/image1.jpg"),
                dateTaken: "2024-09-22T15:30:00Z", // Add the missing dateTaken parameter
                description: "A beautiful image of nature.",
                published: "2024-09-23T12:34:56Z",
                author: "John Doe",
                tags: "nature, beauty"             // Add the missing tags parameter
            ),
            FlickrImage(
                title: "Test Image 2",
                link: "http://example.com/2",
                media: FlickrImage.Media(m: "http://example.com/image2.jpg"),
                dateTaken: "2024-08-01T09:00:00Z", // Add the missing dateTaken parameter
                description: "An amazing view of the mountains.",
                published: "2024-08-01T09:12:45Z",
                author: "Jane Smith",
                tags: "mountains, landscape"       // Add the missing tags parameter
            )
        ]
    }
}

