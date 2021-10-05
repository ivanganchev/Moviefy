//
//  MoviesResponse.swift
//  Moviefy
//
//  Created by A-Team Intern on 27.08.21.
//

import Foundation

struct MoviesResponse : Codable {
    let page: Int
    let movies: [MovieResponse]?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case movies = "results"
    }
}
