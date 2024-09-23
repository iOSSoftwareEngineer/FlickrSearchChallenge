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

    init(flickrService: FlickrServiceProtocol = FlickrService()) {
        self.flickrService = flickrService
    }

    func searchImages(for searchTerm: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedImages = try await flickrService.fetchImages(for: searchTerm)
            images = fetchedImages
        } catch {
            errorMessage = "Failed to load images: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
