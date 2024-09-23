//
//  FlickrSearchViewModel.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//
import Foundation

@Observable
class FlickrSearchViewModel {
    var images: [FlickrImage] = []
    var isLoading: Bool = false
    var errorMessage: String?

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
        } catch FlickrSearchServiceError.invalidURL {
            errorMessage = "Invalid URL. Please check your search term."
        } catch FlickrSearchServiceError.networkError(let error as URLError) {
            switch error.code {
            case .timedOut:
                errorMessage = "Network error: The request timed out."
            default:
                errorMessage = "Network error: \(error.localizedDescription). Please check your connection."
            }
        } catch FlickrSearchServiceError.invalidResponse {
            errorMessage = "Invalid response from the server."
        } catch FlickrSearchServiceError.httpError(let statusCode) {
            errorMessage = "HTTP error: Received status code \(statusCode)."
        } catch FlickrSearchServiceError.decodingError(let decodingError) {
            errorMessage = "Failed to decode the response: \(decodingError.localizedDescription)."
        } catch {
            errorMessage = "An unknown error occurred: \(error.localizedDescription)."
        }

        isLoading = false
    }
}
