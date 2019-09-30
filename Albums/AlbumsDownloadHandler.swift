//
//  AlbumsDownloadHandler.swift
//  Albums
//
//  Created by Ahmed Moussa on 9/26/19.
//  Copyright © 2019 Ahmed Moussa. All rights reserved.
//
/*
 Contains Album model codable struct to assist in parsing the recieved json and storing model data
 
 Includes function that handles fetching the latest json data
*/

import Foundation
import UIKit

public struct Album: Codable {
    struct genre: Codable {
        let name: String
    }
    let name: String
    let artistName: String
    let artworkUrl100: String
    let genres: [genre]
    let releaseDate: String
    let copyright: String
    let url: String
}

fileprivate struct jsonResult: Codable {
    struct Feed: Codable {
        let title: String
        let results: [Album]
    }
    let feed: Feed
}

class JsonHelper {
    static func parseJSON(data: Data, completion: (_ result: [Album]) -> Void) {
        do {
            let json = try JSONDecoder().decode(jsonResult.self, from: data)
            let albums: [Album] = json.feed.results
            completion(albums)
        }
        catch let error {
            print(error)
        }
    }
    
    //Fetch JSON function handles fetching the latest json data, parsing into Album structs, and returning array of albums on compleion
    static func fetchJson(completion: @escaping (_ result: [Album]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/100/explicit.json") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        self.parseJSON(data: data, completion: completion)
                    }
                    }.resume()
            }
        }
    }
}
