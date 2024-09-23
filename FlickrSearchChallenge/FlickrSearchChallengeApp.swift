//
//  FlickrSearchChallengeApp.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import SwiftUI

@main
struct FlickrSearchChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(FlickrSearchViewModel()) // Inject the ViewModel into the environment
        }
    }
}
