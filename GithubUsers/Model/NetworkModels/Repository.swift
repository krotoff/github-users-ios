//
//  Repository.swift
//  Model
//
//  Created by Andrey Krotov on 27.01.2021.
//

import Foundation

struct Repository: Codable {
    
    // MARK: - Private types
    
    private enum CodingKeys: String, CodingKey {
        case id
        case size
        case createdAt = "created_at"
        case description
        case fork
    }
    
    // MARK: - Private properties
    
    private let id: Int
    private let size: Int // KBs
    private let createdAt: Date
    private let description: String?
    private let fork: Bool
    
    // MARK: - Initialization
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        size = try container.decode(Int.self, forKey: .size)
        createdAt = try container.decodeDate(forKey: .createdAt, with: [.iso8601WithSecsAndShortTimeZone])!
        description = try container.decodeIfPresent(String.self, forKey: .description)
        fork = try container.decode(Bool.self, forKey: .fork)
    }
}
