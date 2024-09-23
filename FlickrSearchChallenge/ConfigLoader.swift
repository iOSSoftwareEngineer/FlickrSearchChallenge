//
//  to.swift
//  FlickrSearchChallenge
//
//  Created by Richard B. Rubin on 9/23/24.
//

import Foundation

// Helper class to load the config from the plist
class ConfigLoader {
    static func loadConfigValue(forKey key: String) -> String? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            return nil
        }
        return dict[key] as? String
    }
}
