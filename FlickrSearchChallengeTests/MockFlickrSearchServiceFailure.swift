//
//  MockFlickrSearchServiceFailure.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation
import Testing
@testable import FlickrSearchChallenge

// Failure mock to simulate an error response
class MockFlickrSearchServiceFailure: FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
        throw URLError(.badServerResponse)
    }
}
