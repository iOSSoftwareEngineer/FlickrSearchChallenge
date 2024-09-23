//
//  FlickrSearchViewModel.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation

@MainActor
class FlickrSearchViewModel: ObservableObject {
    @Published var images: [FlickrImage] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let flickrService: FlickrServiceProtocol

    init(flickrService: FlickrServiceProtocol = FlickrSearchService()) {
        self.flickrService = flickrService
    }

    func searchImages(for searchTerm: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedImages = try await flickrService.fetchImages(for: searchTerm)
            images = fetchedImages
        } catch FlickrServiceError.invalidURL {
            errorMessage = "Invalid URL. Please check your search term."
        } catch FlickrServiceError.networkError(let error as URLError) {
            switch error.code {
            case .timedOut:
                errorMessage = "Network error: The request timed out."
            default:
                errorMessage = "Network error: \(error.localizedDescription). Please check your connection."
            }
        } catch FlickrServiceError.invalidResponse {
            errorMessage = "Invalid response from the server."
        } catch FlickrServiceError.httpError(let statusCode) {
            errorMessage = "HTTP error: Received status code \(statusCode)."
        } catch FlickrServiceError.decodingError(let decodingError) {
            errorMessage = "Failed to decode the response: \(decodingError.localizedDescription)."
        } catch {
            errorMessage = "An unknown error occurred: \(error.localizedDescription)."
        }

        isLoading = false
    }
}
