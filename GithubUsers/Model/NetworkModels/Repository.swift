//
//  Repository.swift
//  Model
//
//  Created by Andrey Krotov on 27.01.2021.
//

import Foundation

public struct Repository: Codable & Equatable {
    
    // MARK: - Private types
    
    private enum CodingKeys: String, CodingKey {
        case id
        case size
        case name
        case createdAt = "created_at"
        case description
        case fork
    }
    
    // MARK: - Private properties
    
    public let id: Int
    public let size: Int // KBs
    public let name: String
    public let createdAt: Date
    public let description: String?
    public let fork: Bool
    
    // MARK: - Initialization
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        size = try container.decode(Int.self, forKey: .size)
        name = try container.decode(String.self, forKey: .name)
        createdAt = try container.decodeDate(forKey: .createdAt, with: [.iso8601WithSecsAndShortTimeZone])!
        description = try container.decodeIfPresent(String.self, forKey: .description)
        fork = try container.decode(Bool.self, forKey: .fork)
    }
}
