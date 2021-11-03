//
//  ApiResponseCustomError.swift
//  Moviefy
//
//  Created by A-Team Intern on 26.10.21.
//

import Foundation

enum ApiResponseCustomError: Error {
    case noMoviesFound
    case currentlyFetching
    var description: String {
        switch self {
        case .noMoviesFound:
            return Messages.noMoviesFound
        case .currentlyFetching:
            return Messages.currentlyFetching
        }
    }
}

class Messages {
    static let noMoviesFound = "No movies found"
    static let currentlyFetching = "Currently fetching"
}
