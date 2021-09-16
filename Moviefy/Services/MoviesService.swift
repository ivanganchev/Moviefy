//
//  MoviesService.swift
//  Moviefy
//
//  Created by A-Team Intern on 30.08.21.
//

import Foundation

class MoviesService {
    let session = URLSession.shared
    static var genres: [Int:String]?
    
    private static func provideService(url:inout URLComponents, params: [String:String]?, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        var queryItems: [URLQueryItem] = url.queryItems ?? []
        params?.forEach({ (key: String, value: String) in
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        })
        url.queryItems = queryItems
        guard let url = url.url else { return }
        let authHeader = "Bearer " + Secrets.apiKey
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    func fetchMoviesByCategory(movieCategoryPath: String, page: Int, completion: @escaping (Result<MoviesResponse, Error>) -> ()) {
        var url = URLComponents(string: EndPoint.defaultLink + movieCategoryPath)!
        MoviesService.provideService(url: &url, params: ["page": String(page), "language": "en-US"], completion: {(data, response, error) in
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
    
    func fetchMovieImage(imageUrl: String, completion: @escaping(Data?) -> ()) {
        let urlComponents = URLComponents(string: EndPoint.imageLink + imageUrl)
        guard let url = urlComponents?.url else {
            return
        }
        
        self.session.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                return
            }
            completion(data)
        }.resume()
    }
    
    static func loadMoviesGenreList(){
        var url = URLComponents(string: EndPoint.defaultLink + EndPoint.genresPath)!
        
        MoviesService.provideService(url: &url, params: ["language": "en-US"], completion: {(data, response, error) in
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
}

