//
//  FlickrImage.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation

struct FlickrImage: Codable {
    let title: String
    let link: String
    let media: Media
    let dateTaken: String?
    let description: String
    let published: String?
    let author: String
    let tags: String
    
    struct Media: Codable {
        let m: String
    }

    enum CodingKeys: String, CodingKey {
        case title
        case link
        case media
        case dateTaken = "date_taken"
        case description
        case published
        case author
        case tags
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
