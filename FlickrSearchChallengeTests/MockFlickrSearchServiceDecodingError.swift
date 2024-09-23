//
//  MockFlickrSearchServiceDecodingError.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation
import Testing
@testable import FlickrSearchChallenge

// Mock service that throws a decoding error
class MockFlickrSearchServiceDecodingError: FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
        throw FlickrSearchServiceError.decodingError(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Test decoding error")))
    }
}
