//
//  FlickrImage.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation

import Foundation

struct FlickrImage: Codable {
    let title: String
    let link: String
    let media: Media
    let description: String?
    let author: String?
    let published: String?

    // Media struct to handle image links
    struct Media: Codable {
        let m: String
    }

    // Formatter to convert date string into a more readable format
    func formattedPublishedDate() -> String {
        guard let publishedDate = published else { return "Unknown Date" }
        
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: publishedDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return "Invalid Date"
    }
}
