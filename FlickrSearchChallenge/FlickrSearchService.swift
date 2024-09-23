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
            // Define a request with a timeout of 15 seconds
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)

            // Ensure the response is an HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw FlickrSearchServiceError.invalidResponse
            }

            // Check for successful HTTP status code
            guard (200...299).contains(httpResponse.statusCode) else {
                throw FlickrSearchServiceError.httpError(httpResponse.statusCode)
            }

            // Decode JSON and handle potential decoding errors
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            // Print the raw JSON string for debugging
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString ?? "No data")

            do {
                let result = try decoder.decode(FlickrResponse.self, from: data)
                return result.items
            } catch let DecodingError.keyNotFound(key, context) {
                print("Missing key: \(key) in context: \(context.debugDescription)")
                throw FlickrSearchServiceError.decodingError(DecodingError.keyNotFound(key, context))
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type mismatch for type: \(type) in context: \(context.debugDescription)")
                throw FlickrSearchServiceError.decodingError(DecodingError.typeMismatch(type, context))
            } catch let DecodingError.valueNotFound(type, context) {
                print("Value not found for type: \(type) in context: \(context.debugDescription)")
                throw FlickrSearchServiceError.decodingError(DecodingError.valueNotFound(type, context))
            } catch let DecodingError.dataCorrupted(context) {
                print("Data corrupted in context: \(context.debugDescription)")
                throw FlickrSearchServiceError.decodingError(DecodingError.dataCorrupted(context))
            } catch {
                print("Unknown error: \(error)")
                throw FlickrSearchServiceError.decodingError(error)
            }

        } catch let error as URLError {
            // Handle network-related errors
            throw FlickrSearchServiceError.networkError(error)
        } catch let decodingError {
            // Handle JSON decoding errors
            throw FlickrSearchServiceError.decodingError(decodingError)
        }
    }
}

