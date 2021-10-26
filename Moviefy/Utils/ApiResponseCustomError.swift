//
//  ApiResponseCustomError.swift
//  Moviefy
//
//  Created by A-Team Intern on 26.10.21.
//

import Foundation

enum ApiResponseCustomError: Error {
    case endOfPages
    case noMoviesFound
    var description: String {
        switch self {
        case .endOfPages:
            return Messages.endOfPages
        case .noMoviesFound:
            return Messages.noMoviesFound
        }
    }
}

class Messages {
    static let endOfPages = "You've reached maximum number of pages"
    static let noMoviesFound = "No movies found"
}
