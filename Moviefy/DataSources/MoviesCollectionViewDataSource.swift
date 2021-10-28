//
//  MoviesCollectionViewHelper.swift
//  Moviefy
//
//  Created by A-Team Intern on 30.08.21.
//

import UIKit

class MoviesCollectionViewDataSource: NSObject {
    private var movies = [Movie]()
    let cache = NSCache<NSString, UIImage>()
    
    func fetchMovies(movieCategoryPath: String, completion: @escaping () -> Void) {
        MoviesService().fetchMoviesByCategory(movieCategoryPath: movieCategoryPath, page: 1, completion: { result in
           switch result {
           case .success(let moviesResponse):
                let movies = moviesResponse.movies?.map { (movieResponse) -> Movie in
                    return Movie(movieResponse: movieResponse)
                }
                self.movies = movies ?? []
                completion()
           case .failure(let err):
               print(err)
           }
       })
    }
    
    func loadImages(completion: @escaping () -> Void) {
        self.movies.forEach { (movie) in
            guard let posterPath = movie.movieResponse.posterPath else {
                return
            }
            
            let path = NSString(string: posterPath)
            
            MoviesService().fetchMovieImage(imageUrl: path as String, completion: {result in
                switch result {
                case .success(let data):
                    movie.imageData = data
                    self.cache.setObject(UIImage(data: data)!, forKey: path)
                case .failure(let err):
                    print(err)
                }
            })
        }
        completion()
    }
    
    func loadImage(movie: Movie, completion: ((UIImage) -> Void)? = nil) {
        guard let posterPath = movie.movieResponse.posterPath else {
            return
        }
        
        let path = NSString(string: posterPath)
        
        MoviesService().fetchMovieImage(imageUrl: path as String, completion: {result in
            switch result {
            case .success(let data):
                movie.imageData = data
                let loadedImage = UIImage(data: data)!
                self.cache.setObject(loadedImage, forKey: path)
                completion!(loadedImage)
            case .failure(let err):
                print(err)
            }
        })
    }
}

extension MoviesCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as? MoviesCollectionViewCell else {
            return MoviesCollectionViewCell()
        }
        
        cell.tag = indexPath.row
        self.loadImageView(cell: cell, index: indexPath.row)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension MoviesCollectionViewDataSource {
    func loadImageView(cell: MoviesCollectionViewCell, index: Int) {
        let movie = self.movies[index]
        
        guard let path = movie.movieResponse.posterPath else {
            cell.imageView.image = UIImage(named: "not_loaded_image.jpg")
            return
        }
        
        if let cachedImage = self.cache.object(forKey: NSString(string: path)) {
            cell.imageView.image = cachedImage
        } else {
            self.loadImage(movie: movie) { image in
                DispatchQueue.main.async {
                    if cell.tag == index {
                        cell.imageView.image = image
                    }
                }
            }
        }
    }
}

extension MoviesCollectionViewDataSource {
    func getMovieAt(index: Int) -> Movie? {
        if index < self.movies.count {
            return self.movies[index]
        }
        return nil
    }
}
