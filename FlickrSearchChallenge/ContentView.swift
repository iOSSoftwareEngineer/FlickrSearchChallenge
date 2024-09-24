//
//  ContentView.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var searchTerm: String = ""
    @Environment(FlickrSearchViewModel.self) private var viewModel
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    // Subject to handle the search term changes
    @State private var searchSubject = PassthroughSubject<String, Never>()
    private var debounceTime: TimeInterval = 0.5

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    TextField("Enter comma-separated search term(s)", text: $searchTerm)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onChange(of: searchTerm) {
                            // Send the new value to the searchSubject
                            searchSubject.send(searchTerm)
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
            .onAppear {
                // Setup the debounce pipeline when the view appears
                setupDebounce()
            }
        }
    }

    // Setup the debounce logic for the search input
    func setupDebounce() {
        searchSubject
            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { newTerm in
                print("Searching for: \(newTerm)")  // Debugging: Check when search is triggered
                Task {
                    await viewModel.searchImages(for: newTerm)
                }
            }
            .store(in: &viewModel.cancellables)  // Store the cancellables in the ViewModel
    }
}

#Preview {
    ContentView()
        .environment(FlickrSearchViewModel())
}
