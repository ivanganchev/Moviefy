//
//  MoviesService.swift
//  Moviefy
//
//  Created by A-Team Intern on 30.08.21.
//

import Foundation

enum QueryItems: String {
    case page = "page"
    case language = "language"
    case query = "query"
}

class MoviesService {
    let session = URLSession.shared
    static var genres: [Int:String]?
    
    private static func provideService(url: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    func fetchMoviesByCategory(movieCategoryPath: String, page: Int, completion: @escaping (Result<MoviesResponse, Error>) -> ()) {
        guard var urlComponents = URLComponents(string: Link.defaultLink + movieCategoryPath) else {
            return
        }
        let url = MoviesService.setQueryParams(urlComponents: &urlComponents, params: [QueryItems.page.rawValue: String(page), QueryItems.language.rawValue: "en-US"])
        let request: URLRequest = MoviesService.setHeaders(url: url)
        
        MoviesService.provideService(url: request, completion: {(data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let obj:MoviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(obj))
                
            } catch let err {
                completion(.failure(err))
                print(err)
            }
        })
    }
    
    func fetchMovieImage(imageUrl: String, completion: @escaping(Result<Data, Error>) -> ()) {
        let urlComponents = URLComponents(string: Link.imageLink + imageUrl)
        guard let url = urlComponents?.url else {
            return
        }
        
        let request = URLRequest(url: url)
        
        MoviesService.provideService(url: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            completion(.success(data))
        }
    }
    
    static func loadMoviesGenreList(){
        guard var urlComponents = URLComponents(string: Link.defaultLink + EndPoint.genresPath) else {
            return
        }
        let url = MoviesService.setQueryParams(urlComponents: &urlComponents, params: [QueryItems.language.rawValue: "en-US"])
        let request: URLRequest = MoviesService.setHeaders(url: url)
        
        MoviesService.provideService(url: request, completion: {(data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let result: GenresResponse = try JSONDecoder().decode(GenresResponse.self, from: data)
                MoviesService.genres = Dictionary(uniqueKeysWithValues: result.genres.map {($0.id, $0.name ?? "")})
            } catch let err{
                print(err)
                MoviesService.genres = nil
            }
        })
    }
    
    func searchMovies(text: String, completion: @escaping (Result<MoviesResponse, Error>) -> ()) {
        guard var urlComponents = URLComponents(string: Link.defaultLink + EndPoint.searchPath) else {
            return
        }
        let url = MoviesService.setQueryParams(urlComponents: &urlComponents, params: [QueryItems.query.rawValue: text])
        let request: URLRequest = MoviesService.setHeaders(url: url)
        
        MoviesService.provideService(url: request, completion: {(data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let obj:MoviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(obj))
            } catch let err {
                completion(.failure(err))
                print(err)
            }
        })
    }
}

extension MoviesService {
    private static func setHeaders(url: URL) -> URLRequest {
        let authHeader = "Bearer " + Secrets.apiKey
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private static func setQueryParams(urlComponents: inout URLComponents, params: [String:String]) -> URL {
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        params.forEach({ (key: String, value: String) in
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        })
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        return url
    }
}
