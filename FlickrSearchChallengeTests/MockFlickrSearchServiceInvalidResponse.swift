//
//  MockFlickrSearchServiceInvalidResponse.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation
import Testing
@testable import FlickrSearchChallenge

// Mock service that throws an invalid server response error
class MockFlickrSearchServiceInvalidResponse: FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
        throw FlickrServiceError.invalidResponse
    }
}
