//
//  ImageDetailView.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import SwiftUI

struct ImageDetailView: View {
    let image: FlickrImage
    
    var body: some View {
        VStack {
            // Display the image
            AsyncImage(url: URL(string: image.media.m)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: 300)

            // Display the title
            Text(image.title)
                .font(.title)
                .padding(.top, 10)

            // Display the description
            Text(image.description.stripHTML())
                .font(.body)
                .padding(.top, 10)
                .multilineTextAlignment(.leading)

            // Display the author
            Text("By \(image.author)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 10)

            // Display the formatted published date
            Text("Published on \(image.formattedPublishedDate())")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 10)


            Spacer()
        }
        .padding()
        .navigationTitle("Image Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}


extension String {
    // Function to remove HTML tags
    func stripHTML() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
        return attributedString?.string ?? self
    }
}

