//
//  MoviesService.swift
//  Moviefy
//
//  Created by A-Team Intern on 30.08.21.
//

import Foundation

class MoviesService {
    let session = URLSession.shared
    
    private func provideService(url:inout URLComponents, params: [String:String]?, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let keys = [String] (params!.keys)
//        keys?.forEach { k in
//            url.queryItems?.append(URLQueryItem(name: k, value: params?[k]))
//        }
        
        let queryItems = [URLQueryItem(name: keys[0], value: params![keys[0]]), URLQueryItem(name: keys[1], value: params![keys[1]])]
        url.queryItems = queryItems
        guard let url = url.url else { return }
        let authHeader = "Bearer " + Secrets.apiKey
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        self.session.dataTask(with: request) {(data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    func fetchMoviesByCategory(movieCategoryPath: String, page: Int, completion: @escaping (Result<MoviesResponse, Error>) -> ()) {
        var url = URLComponents(string: EndPoint.defaultLink + movieCategoryPath)!
        provideService(url: &url, params: ["page": String(page), "language": "en-US"], completion: {(data, response, error) in
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
        
        self.session.dataTask(with: url) {data, response, error in
            guard let data = data else {
                return
            }
            completion(data)
        }.resume()
    }
}

