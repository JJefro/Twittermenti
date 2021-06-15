//
//  Secrets.swift
//  Twittermenti
//
//  Created by Jevgenijs Jefrosinins on 14/05/2021.
//

import Foundation

struct Secrets {
    
    static var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
                fatalError("Couldn't find file 'Secrets.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API key") as? String else {
                fatalError("Couldn't find key 'API key' in 'Secrets.plist'.")
            }
            if (value.starts(with: "_")) {
                fatalError("Register for a developer account and get an API key")
            }
            return value
        }
    }
    
    static var apiKeySecret: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
                fatalError("Couldn't find file 'TMDB-Info.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API Secret key") as? String else {
                fatalError("Couldn't find key 'API Secret key' in 'Secrets.plist'.")
            }
            if (value.starts(with: "_")) {
                fatalError("Register for a developer account and get an API key")
            }
            return value
        }
    }
}
