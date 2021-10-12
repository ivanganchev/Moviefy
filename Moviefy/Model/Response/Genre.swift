//
//  Genre.swift
//  Moviefy
//
//  Created by A-Team Intern on 13.09.21.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
