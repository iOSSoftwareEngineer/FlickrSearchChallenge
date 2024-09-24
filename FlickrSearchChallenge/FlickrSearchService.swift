//
//  FlickrSearchService.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation

enum FlickrSearchServiceError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case httpError(Int)
}

protocol FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage]
}


struct FlickrResponse: Codable {
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [FlickrImage]
}


class FlickrSearchService: FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
        // Load configuration from plist
        guard let baseURL = ConfigLoader.loadConfigValue(forKey: "FlickrAPIBaseURL"),
              let format = ConfigLoader.loadConfigValue(forKey: "Format"),
              let noJsonCallback = ConfigLoader.loadConfigValue(forKey: "NoJSONCallback") else {
            throw FlickrSearchServiceError.invalidURL
        }

        // Encode the search term for URL safety
        let searchTermEncoded = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchTerm
        let urlString = "\(baseURL)?format=\(format)&nojsoncallback=\(noJsonCallback)&tags=\(searchTermEncoded)"

        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            throw FlickrSearchServiceError.invalidURL
        }

        do {
            // Perform the network request
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)

            // Ensure the response is an HTTP response with a successful status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw FlickrSearchServiceError.invalidResponse
            }

            // Decode JSON and handle potential decoding errors
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            // Debug: Print the raw JSON string
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print(jsonString)
//            }

            let result = try decoder.decode(FlickrResponse.self, from: data)
            return result.items

        } catch let error as URLError {
            throw FlickrSearchServiceError.networkError(error)
        } catch let decodingError as DecodingError {
            // Handle specific decoding errors
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("Missing key: \(key) in context: \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("Type mismatch for type: \(type) in context: \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("Value not found for type: \(type) in context: \(context.debugDescription)")
            case .dataCorrupted(let context):
                print("Data corrupted in context: \(context.debugDescription)")
            default:
                print("Unknown decoding error: \(decodingError)")
            }
            throw FlickrSearchServiceError.decodingError(decodingError)
        }
    }
}


