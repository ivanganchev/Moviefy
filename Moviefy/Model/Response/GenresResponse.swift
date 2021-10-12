//
//  GenresResponse.swift
//  Moviefy
//
//  Created by A-Team Intern on 13.09.21.
//

import Foundation

struct GenresResponse: Codable {
    let genres: [Genre]
        
    enum CodingKeys: String, CodingKey {
        case genres 
    }
}
