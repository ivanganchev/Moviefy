//
//  CategoryCollectionViewDataSource.swift
//  Moviefy
//
//  Created by A-Team Intern on 3.09.21.
//

import UIKit

class CategoryCollectionViewDataSource: NSObject {
    private var movies = [Movie]()
    private var filteredMovies = [Movie]()
    var movieCategoryPath: String?
    private var currentPage = 1
    let cache = NSCache<NSString, UIImage>()
    
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    func fetchMovies(completion: @escaping () -> Void) {
        MoviesService().fetchMoviesByCategory(movieCategoryPath: self.movieCategoryPath!, page: self.currentPage, completion: { result in
               switch result {
               case .success(let moviesResponse):
                let movieObjects = moviesResponse.movies?.map { (movieResponse) -> Movie in
                    return Movie(movieResponse: movieResponse)
                }
                movieObjects?.forEach({ movie in
                    if !self.movies.contains(movie) {
                        self.movies.append(movie)
                        self.filteredMovies.append(movie)
                    }
                })
                self.currentPage += 1
                completion()	
               case .failure(let err):
                   print(err)
               }
           })
    }
    
    func loadImages(completion: (() -> Void)? = nil) {
        self.filteredMovies.forEach { (movie) in
            guard let posterPath = movie.movieResponse.posterPath else {
                return
            }
            
            let path = NSString(string: posterPath)
            
            MoviesService().fetchMovieImage(imageUrl: path as String, completion: { result in
                switch result {
                case .success(let data):
                    movie.imageData = data
                    self.cache.setObject(UIImage(data: data)!, forKey: path)
                case .failure(let err):
                    print(err)
                }
            })
        }
        completion?()
    }
    
    func loadImage(index: Int, completion: ((UIImage) -> Void)? = nil) {
        guard index >= 0 && index < self.filteredMovies.count else {
            return
        }
        
        let movie: Movie = self.filteredMovies[index]
        
        guard let posterPath = movie.movieResponse.posterPath else {
            return
        }
        
        let path = NSString(string: posterPath)
        
        MoviesService().fetchMovieImage(imageUrl: path as String, completion: { result in
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
    
    func filterMovies(genres: [String]) {
        guard !genres.isEmpty else {
            self.filteredMovies = self.movies
            return
        }

        self.filteredMovies = FilterHelper.getMoviesByGenres(movies: self.movies, selectedGenres: genres, allGenres: MoviesService.genres)
        print()
    }
    
    func refreshMovies(genres: [String], completion: @escaping () -> Void) {
        self.movies = []
        self.filteredMovies = []
        self.currentPage = 1
        self.fetchMovies {
            self.filterMovies(genres: genres)
            completion()
        }
   }
}

extension CategoryCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return CategoryCollectionViewCell()
        }
        cell.tag = indexPath.row
        self.loadImageView(cell: cell, index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterIndicator.identifier, for: indexPath)
            footer.addSubview(self.activityIndicatorView)
            self.activityIndicatorView.frame = CGRect(origin: .zero, size: CGSize(width: collectionView.bounds.width, height: 50))
            return footer
        }
        return UICollectionReusableView()
    }
}

extension CategoryCollectionViewDataSource {
    func loadImageView(cell: UICollectionViewCell, index: Int) {
        guard let cell = cell as? CategoryCollectionViewCell else { return }
        
        let movie: Movie
        if self.filteredMovies.count > index {
           movie = self.filteredMovies[index]
        } else {
            return
        }
    
        guard let path = movie.movieResponse.posterPath else {
            cell.imageView.image = UIImage(named: "not_loaded_image.jpg")
            return
        }
        
        if let cachedImage = self.cache.object(forKey: NSString(string: path)) {
            cell.imageView.image = cachedImage
        } else {
            self.loadImage(index: index) { image in
                DispatchQueue.main.async {
                    if cell.tag == index {
                        cell.imageView.image = image
                    }
                }
            }
        }
    }
    
    func getMovieAt(index: Int) -> Movie {
        return self.movies[index]
    }
    
    func getFilteredMovieAt(index: Int) -> Movie {
        return self.filteredMovies[index]
    }
    
    func getMovies() -> [Movie] {
        return self.movies
    }
    
    func getFilteredMovies() -> [Movie] {
        return self.filteredMovies
    }
}
