//
//  MovieEntity.swift
//  Moviefy
//
//  Created by A-Team Intern on 30.09.21.
//

import Foundation
import RealmSwift

class MovieEntity: Object {
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var originalTitle: String?
    @Persisted var title: String?
    @Persisted var posterPath: String?
    @Persisted var budget: String?
    @Persisted var overview: String?
    @Persisted var popularity: Float = 0.0
    @Persisted var releaseDate: String?
    @Persisted var runtime: String?
    @Persisted var imageData: Data?
    @Persisted var genreIds = RealmSwift.List<Int>()
    
    convenience init(movie: Movie?) {
        self.init()
        
        self.id = movie?.movieResponse.id
        self.originalTitle = movie?.movieResponse.originalTitle
        self.title = movie?.movieResponse.title
        self.posterPath = movie?.movieResponse.posterPath
        self.budget = movie?.movieResponse.budget
        self.overview = movie?.movieResponse.overview
        self.popularity = movie?.movieResponse.popularity ?? 0.0
        self.releaseDate = movie?.movieResponse.releaseDate
        self.runtime = movie?.movieResponse.runtime
        self.imageData = movie?.imageData
        self.genreIds.append(objectsIn: movie?.movieResponse.genreIds ?? [])
    }
}
