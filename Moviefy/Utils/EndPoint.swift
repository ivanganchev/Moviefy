//
//  EndPoint.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.09.21.
//

import Foundation

enum EndPoint {
    static let genresPath = "/genre/movie/list"
    static let searchPath = "/search/movie"
    
    enum MovieCategoryEndPoint: String, CaseIterable {
        case topRated = "/movie/top_rated"
        case popular = "/movie/popular"
        case upcoming = "/movie/upcoming"
        case nowPlaying = "/movie/now_playing"
    }
}
