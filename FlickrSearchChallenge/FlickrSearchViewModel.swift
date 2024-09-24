//
//  FlickrSearchViewModel.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation
import Combine

@Observable
class FlickrSearchViewModel {
    var images: [FlickrImage] = []
    var isLoading: Bool = false
    var errorMessage: String?

    // Store Combine cancellables here
    var cancellables = Set<AnyCancellable>()

    private let flickrService: FlickrServiceProtocol

    init(flickrService: FlickrServiceProtocol = FlickrSearchService()) {
        self.flickrService = flickrService
    }

    func searchImages(for searchTerm: String) async {
        // Ensure isLoading is updated on the main thread
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        do {
            let fetchedImages = try await flickrService.fetchImages(for: searchTerm)
            
            print("Fetched \(fetchedImages.count) images for: \(searchTerm)")  // Debugging
            
            // Ensure UI updates (images) are on the main thread
            await MainActor.run {
                images = fetchedImages
            }
        } catch FlickrSearchServiceError.invalidURL {
            await MainActor.run {
                errorMessage = "Invalid URL. Please check your search term."
            }
        } catch FlickrSearchServiceError.networkError(let error as URLError) {
            await MainActor.run {
                switch error.code {
                case .timedOut:
                    errorMessage = "Network error: The request timed out."
                default:
                    errorMessage = "Network error: \(error.localizedDescription). Please check your connection."
                }
            }
        } catch FlickrSearchServiceError.invalidResponse {
            await MainActor.run {
                errorMessage = "Invalid response from the server."
            }
        } catch FlickrSearchServiceError.httpError(let statusCode) {
            await MainActor.run {
                errorMessage = "HTTP error: Received status code \(statusCode)."
            }
        } catch FlickrSearchServiceError.decodingError(let decodingError) {
            await MainActor.run {
                errorMessage = "Failed to decode the response: \(decodingError.localizedDescription)."
            }
        } catch {
            await MainActor.run {
                errorMessage = "An unknown error occurred: \(error.localizedDescription)."
            }
        }

        // Ensure the loading state change happens on the main thread
        await MainActor.run {
            isLoading = false
        }
    }
}
