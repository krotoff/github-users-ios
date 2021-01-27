//
//  User.swift
//  Model
//
//  Created by Andrey Krotov on 27.01.2021.
//

import Foundation

struct User: Codable {
    
    // MARK: - Private types
    
    private enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case reposURL = "repos_url"
    }
    
    // MARK: - Private properties
    
    private let login: String
    private let avatarURL: String
    private let reposURL: String
}
