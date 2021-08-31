//
//  TokenResponse.swift
//  Moviefy
//
//  Created by A-Team Intern on 27.08.21.
//

import Foundation

struct TokenResponse : Codable {
    let requestToken: String?
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
}
