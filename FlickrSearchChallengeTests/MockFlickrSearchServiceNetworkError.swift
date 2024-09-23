//
//  MockFlickrSearchServiceNetworkError.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation
import Testing
@testable import FlickrSearchChallenge

// Mock service that throws a network error
class MockFlickrSearchServiceNetworkError: FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
        throw FlickrSearchServiceError.networkError(URLError(.timedOut))
    }
}
