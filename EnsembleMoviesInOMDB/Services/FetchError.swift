//
//  FetchError.swift
//  EnsembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import Foundation

enum FetchError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidJsonParse
    case apiError(APIError)

    var description: String {
        switch self {
        case .invalidURL:
            "Invalid server URL"
        case .invalidResponse:
            "Invalid server response"
        case .invalidData:
            "Invalid server data"
        case .invalidJsonParse:
            "Invalid json parsing"
        case .apiError(let error):
            "Server error: \(error.error)"
        }
    }
}

struct APIError: Codable {
    var response: String
    var error: String

    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case error = "Error"
    }
}
