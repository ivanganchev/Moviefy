//
//  MoviesService.swift
//  Moviefy
//
//  Created by A-Team Intern on 30.08.21.
//

import Foundation

enum QueryItems: String {
    case page
    case language
    case query
}

class MoviesService {
    let session = URLSession.shared
    static var genres: [Int: String]?
    var dataTask: URLSessionDataTask?
    
    private static func provideService(url: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url) {(data, _, error) in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }
    }
    
    func fetchMoviesByCategory(movieCategoryPath: String, page: Int, completion: @escaping (Result<MoviesResponse, ApiMovieResponseError>) -> Void) {
        guard var urlComponents = URLComponents(string: Link.defaultLink + movieCategoryPath),
              let url = MoviesService.setQueryParams(urlComponents: &urlComponents, params: [QueryItems.page.rawValue: String(page), QueryItems.language.rawValue: "en-US"]) else {
            return
        }
        
        let request: URLRequest = MoviesService.setHeaders(url: url)
        
        self.dataTask = MoviesService.provideService(url: request, completion: {result in
            switch result {
            case .success(let data):
                guard var responseObj: MoviesResponse = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
                    return
                }
                
                self.dataTask = nil
                
                if let movies = responseObj.movies, !movies.isEmpty {
                    responseObj.movies = responseObj.movies.map {$0.filter({ $0.id != nil })}
                    completion(.success(responseObj))
                } else {
                    completion(.failure(ApiMovieResponseError.noMoviesFound))
                    print(ApiMovieResponseError.noMoviesFound)
                    return
                }
            case .failure(let err):
                print(err)
            }
        })
        self.dataTask?.resume()
    }
    
    func fetchMovieImage(imageUrl: String, completion: @escaping(Result<Data, Error>) -> Void) {
        let urlComponents = URLComponents(string: Link.imageLink + imageUrl)
        guard let url = urlComponents?.url else {
            return
        }
        let request = URLRequest(url: url)
        
        MoviesService.provideService(url: request) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let err):
                print(err)
            }
        }.resume()
    }
    
    static func loadMoviesGenreList() {
        guard var urlComponents = URLComponents(string: Link.defaultLink + EndPoint.genresPath),
              let url = MoviesService.setQueryParams(urlComponents: &urlComponents, params: [QueryItems.language.rawValue: "en-US"]) else {
            return
        }
        
        let request: URLRequest = MoviesService.setHeaders(url: url)
        
        MoviesService.provideService(url: request, completion: {result in
            switch result {
            case .success(let data):
                do {
                    let result: GenresResponse = try JSONDecoder().decode(GenresResponse.self, from: data)
                    MoviesService.genres = Dictionary(uniqueKeysWithValues: result.genres.map {($0.id, $0.name ?? "")})
                } catch let err {
                    print(err)
                    MoviesService.genres = nil
                }
            case .failure(let err):
                print(err)
            }

        }).resume()
    }
    
    func searchMovies(text: String, completion: @escaping (Result<MoviesResponse, ApiMovieResponseError>) -> Void) {
        guard var urlComponents = URLComponents(string: Link.defaultLink + EndPoint.searchPath),
              let url = MoviesService.setQueryParams(urlComponents: &urlComponents, params: [QueryItems.query.rawValue: text])
              else {
            return
        }
        
        let request: URLRequest = MoviesService.setHeaders(url: url)
        
        MoviesService.provideService(url: request, completion: {result in
            switch result {
            case .success(let data):
                guard var responseObj: MoviesResponse = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
                    return
                }
                if let movies = responseObj.movies, !movies.isEmpty {
                    responseObj.movies = responseObj.movies.map {$0.filter({ $0.id != nil })}
                    completion(.success(responseObj))
                } else {
                    completion(.failure(ApiMovieResponseError.noMoviesFound))
                    return
                }
            case .failure(let err):
                print(err)
            }
        }).resume()
    }
}

extension MoviesService {
    private static func setHeaders(url: URL) -> URLRequest {
        let authHeader = "Bearer " + Secrets.apiKey
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private static func setQueryParams(urlComponents: inout URLComponents, params: [String: String]) -> URL? {
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        params.forEach({ (key: String, value: String) in
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        })
        urlComponents.queryItems = queryItems
        let url = urlComponents.url
        return url
    }
}
