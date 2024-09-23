//
//  MockFlickrSearchServiceInvalidURL.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation
import Testing
@testable import FlickrSearchChallenge

// Mock service that throws an invalid URL error
class MockFlickrSearchServiceInvalidURL: FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
        throw FlickrServiceError.invalidURL
    }
}
