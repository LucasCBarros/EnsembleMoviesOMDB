//
//  Movie.swift
//  ensembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import Foundation

struct Movie: Codable {
    var title: String
    var released: String
    var imdbID: String
    var poster: String
    var posterImage: Data?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case released = "Year"
        case imdbID = "imdbID"
        case poster = "Poster"
    }
}
