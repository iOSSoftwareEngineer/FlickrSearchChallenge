//
//  FlickrSearchService.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation

enum FlickrServiceError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case httpError(Int)
}

protocol FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage]
}


class FlickrSearchService: FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
        // Load configuration from plist
        guard let baseURL = ConfigLoader.loadConfigValue(forKey: "FlickrAPIBaseURL"),
              let format = ConfigLoader.loadConfigValue(forKey: "Format"),
              let noJsonCallback = ConfigLoader.loadConfigValue(forKey: "NoJSONCallback") else {
            throw FlickrServiceError.invalidURL
        }

        // Encode the search term for URL safety
        let searchTermEncoded = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchTerm
        let urlString = "\(baseURL)?format=\(format)&nojsoncallback=\(noJsonCallback)&tags=\(searchTermEncoded)"

        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            throw FlickrServiceError.invalidURL
        }

        do {
            // Define a request with a timeout of 15 seconds
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)

            // Ensure the response is an HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw FlickrServiceError.invalidResponse
            }

            // Check for successful HTTP status code
            guard (200...299).contains(httpResponse.statusCode) else {
                throw FlickrServiceError.httpError(httpResponse.statusCode)
            }

            // Decode JSON and handle potential decoding errors
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode([String: [FlickrImage]].self, from: data)

            // Extract the items array
            return result["items"] ?? []

        } catch let error as URLError {
            // Handle network-related errors
            throw FlickrServiceError.networkError(error)
        } catch let decodingError {
            // Handle JSON decoding errors
            throw FlickrServiceError.decodingError(decodingError)
        }
    }
}

