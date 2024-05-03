//
//  Search.swift
//  EnsembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import Foundation

struct Search: Codable {
    var movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}
