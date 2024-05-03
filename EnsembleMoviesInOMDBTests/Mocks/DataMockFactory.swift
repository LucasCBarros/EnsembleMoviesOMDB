//
//  DataMockFactory.swift
//  EnsembleMoviesInOMDBTests
//
//  Created by Lucas C Barros on 2024-05-01.
//

import Foundation
@testable import EnsembleMoviesInOMDB
import UIKit

class DataMockFactory {
    static func getMockFromJson(from fileName: String) -> Data? {
        do {
            guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "json") else { return nil }
            let data = try Data(contentsOf: fileUrl)
            return data
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }

    static func buildMovieMock() -> Movie {
        return Movie(title: "Title",
                     released: "1991",
                     imdbID: "123",
                     poster: "posterURL",
                     posterImage: nil)
    }

    static func buildSearchMoviesMock() -> Search {
        let search = Search(movies: [
            Movie(title: "Movie01",
                  released: "1991",
                  imdbID: "111",
                  poster: "posterURL1",
                  posterImage: nil),
            Movie(title: "Movie02",
                  released: "1992",
                  imdbID: "222",
                  poster: "posterURL2",
                  posterImage: nil),
            Movie(title: "Movie03",
                  released: "1993",
                  imdbID: "333",
                  poster: "posterURL3",
                  posterImage: nil)
        ])
        return search
    }

    static func buildImageDataMock() -> Data {
        return UIImage(systemName: "star")?.pngData() ?? Data(count: 10)
    }
}
