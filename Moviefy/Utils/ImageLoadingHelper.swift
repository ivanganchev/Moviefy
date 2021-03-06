//
//  ImageLoadingHelper.swift
//  Moviefy
//
//  Created by A-Team Intern on 1.11.21.
//

import UIKit

class ImageLoadingHelper {
    let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 400
        return cache
    }()
    
    func loadImages(movies: [Movie], completion: (() -> Void)? = nil) {
        let group = DispatchGroup()
        
        movies.forEach { (movie) in
            group.enter()
            guard let posterPath = movie.movieResponse.posterPath else {
                return
            }
            
            let path = NSString(string: posterPath)
            
            MoviesService().fetchMovieImage(imageUrl: path as String, completion: {result in
                switch result {
                case .success(let data):
                    group.leave()
                    guard let loadedImage = UIImage(data: data) else {
                        return
                    }
                    self.cache.setObject(loadedImage, forKey: path)
                case .failure(let err):
                    print(err)
                    group.leave()
                }
            })
        }
        
        group.notify(queue: .main, execute: {
            completion?()
        })
    }
    
    func loadImage(movie: Movie, completion: ((UIImage) -> Void)? = nil) {
        guard let posterPath = movie.movieResponse.posterPath else {
            return
        }
        
        let path = NSString(string: posterPath)
        
        MoviesService().fetchMovieImage(imageUrl: path as String, completion: {result in
            switch result {
            case .success(let data):
                guard let loadedImage = UIImage(data: data) else {
                    return
                }
                self.cache.setObject(loadedImage, forKey: path)
                completion?(loadedImage)
            case .failure(let err):
                print(err)
            }
        })
    }
    
    func loadImageView(cell: ThumbnailCell, movie: Movie, index: Int) {
        guard let path = movie.movieResponse.posterPath else {
            cell.cellImageView.image = UIImage(named: "not_loaded_image.jpg")
            return
        }

        if let cachedImage = self.cache.object(forKey: NSString(string: path)) {
            cell.cellImageView.image = cachedImage
        } else {
            self.loadImage(movie: movie) { image in
                DispatchQueue.main.async {
                    if cell.cellIndex == index {
                        cell.cellImageView.image = image
                    }
                }
            }
        }
    }
}
