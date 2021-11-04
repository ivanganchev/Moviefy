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
    var imageLoadingHelper = ImageLoadingHelper()
    
    let movieService = MoviesService()
    
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    func fetchMovies(genres: [String], completion: @escaping (Result<Void, ApiMovieResponseError>) -> Void) {
        movieService.fetchMoviesByCategory(movieCategoryPath: self.movieCategoryPath!, page: self.currentPage, completion: { result in
               switch result {
               case .success(let moviesResponse):
                    let movieObjects = moviesResponse.movies?.map { (movieResponse) -> Movie in
                        return Movie(movieResponse: movieResponse)
                    }
                    movieObjects?.forEach({ movie in
                        if !self.movies.contains(movie) {
                            self.movies.append(movie)
                        }
                    })
                self.filterMovies(genres: genres)
                    self.currentPage += 1
                    completion(.success(()))
               case .failure(let err):
                    completion(.failure(err))
               }
           })
    }
    
    func filterMovies(genres: [String]) {
        guard !genres.isEmpty else {
            self.filteredMovies = self.movies
            return
        }

        self.filteredMovies = FilterHelper.filterByGenres(movies: self.movies, selectedGenres: genres, allGenres: MoviesService.genres)
    }
    
    func refreshMovies(genres: [String], completion: @escaping () -> Void) {
        self.movies = []
        self.filteredMovies = []
        self.currentPage = 1
        self.fetchMovies(genres: genres, completion: {_ in
            self.filterMovies(genres: genres)
            completion()
        })
   }
    
    func loadImages(completion: @escaping () -> Void) {
        self.imageLoadingHelper.loadImages(movies: self.movies, completion: {
            completion()
        })
    }
    
    func loadImageView(cell: CategoryCollectionViewCell, index: Int) {
        guard self.filteredMovies.count > index else {
            return
        }
        self.imageLoadingHelper.loadImageView(cell: cell, movie: self.filteredMovies[index], index: index)
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
        cell.cellIndex = indexPath.row
        self.loadImageView(cell: cell, index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind != UICollectionView.elementKindSectionFooter else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterIndicator.identifier, for: indexPath)
            footer.addSubview(self.activityIndicatorView)
            self.activityIndicatorView.frame = CGRect(origin: .zero, size: CGSize(width: collectionView.bounds.width, height: 50))
            return footer
        }
        return UICollectionReusableView()
    }
}

extension CategoryCollectionViewDataSource {
    func getMovieAt(index: Int) -> Movie? {
        if index < self.movies.count {
            return self.movies[index]
        }
        return nil
    }
    
    func getFilteredMovieAt(index: Int) -> Movie? {
        if index < self.filteredMovies.count {
            return self.filteredMovies[index]
        }
        return nil
    }
    
    func getMovies() -> [Movie] {
        return self.movies
    }
    
    func getFilteredMovies() -> [Movie] {
        return self.filteredMovies
    }
}
