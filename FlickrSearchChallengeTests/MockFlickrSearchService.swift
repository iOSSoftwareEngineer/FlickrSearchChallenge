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
