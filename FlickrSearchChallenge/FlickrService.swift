//
//  FlickrServiceProtocol.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation

protocol FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage]
}


// Modify the FlickrService to pull URL configuration from the plist
class FlickrService: FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
        guard let baseURL = ConfigLoader.loadConfigValue(forKey: "FlickrAPIBaseURL"),
              let format = ConfigLoader.loadConfigValue(forKey: "Format"),
              let noJsonCallback = ConfigLoader.loadConfigValue(forKey: "NoJSONCallback") else {
            throw URLError(.badURL)
        }

        let searchTermEncoded = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchTerm
        let urlString = "\(baseURL)?format=\(format)&nojsoncallback=\(noJsonCallback)&tags=\(searchTermEncoded)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        // Decode JSON and return
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode([String: [FlickrImage]].self, from: data)

        // Flickr returns data under the key "items"
        return result["items"] ?? []
    }
}
