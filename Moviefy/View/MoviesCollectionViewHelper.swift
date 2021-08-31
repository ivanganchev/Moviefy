//
//  MoviesCollectionViewHelper.swift
//  Moviefy
//
//  Created by A-Team Intern on 30.08.21.
//

import Foundation
import UIKit

class MoviesCollectionViewHelper: NSObject, UICollectionViewDataSource {
    
    var movies:Array<Movie> = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as! MoviesCollectionViewCell
        cell.backgroundColor = .yellow
        
        return cell
    }
}

//Mark: Data fetching

extension MoviesCollectionViewHelper {
    func fetchMovies() {
        MoviesService().fetchMoviesByCategory(page: "1", completion: {response, err  in
            self.movies = (response?.movies)!   
        })
        
    }
}


