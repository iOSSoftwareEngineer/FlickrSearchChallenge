//
//  MockFlickrSearchServiceHTTPError.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation
import Testing
@testable import FlickrSearchChallenge

// Mock service that throws an HTTP error
class MockFlickrSearchServiceHTTPError: FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
        throw FlickrSearchServiceError.httpError(500) // Internal Server Error
    }
}
