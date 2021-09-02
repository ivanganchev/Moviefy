//
//  MovieCategoryEndPoint.swift
//  Moviefy
//
//  Created by A-Team Intern on 2.09.21.
//

import Foundation

enum MovieCategoryEndPoint: String, CaseIterable {
    
    case topRatedMoviesEndPoint = "/movie/top_rated"
    case popularMoviesEndPoint = "/movie/popular"
    case upcomingMoviesEndPoint = "/movie/upcoming"
    case nowPlayingMoviesEndPoint = "/movie/now_playing"
}
