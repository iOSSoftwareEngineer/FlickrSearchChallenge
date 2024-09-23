//
//  ContentView.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var searchTerm: String = ""
    @Environment(FlickrSearchViewModel.self) private var viewModel

    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    TextField("Enter search term (e.g., porcupine or forest, bird)", text: $searchTerm)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onSubmit {
                            Task {
                                await viewModel.searchImages(for: searchTerm)
                            }
                        }

                    Button(action: {
                        Task {
                            await viewModel.searchImages(for: searchTerm)
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    .padding()
                }

                // Loading indicator
                if viewModel.isLoading {
                    ProgressView("Loading images...")
                        .padding()
                }

                // Grid of images
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.images, id: \.link) { image in
                            VStack {
                                AsyncImage(url: URL(string: image.media.m)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)

                                Text(image.title)
                                    .font(.caption)
                                    .lineLimit(2)
                            }
                        }
                    }
                    .padding()
                }

                // Error message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Flickr Image Search")
        }
    }
}

#Preview {
    ContentView()
}
