//
//  Movie.swift
//  Moviefy
//
//  Created by A-Team Intern on 26.08.21.
//

import Foundation

struct MovieResponse: Codable {
    let originalTitle: String?
    let title: String?
    let posterPath: String?
    let budget: String?
    let overview: String?
    let popularity: Float
    let releaseDate: String?
    let runtime: String?
    
    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case title = "title"
        case posterPath = "poster_path"
        case budget = "budget"
        case overview = "overview"
        case popularity = "popularity"
        case releaseDate = "release_date"
        case runtime = "runtime"
    }
}
