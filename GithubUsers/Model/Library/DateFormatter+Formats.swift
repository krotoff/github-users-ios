//
//  DateFormatter+Formats.swift
//  Model
//
//  Created by Andrey Krotov on 27.01.2021.
//

import Foundation

public extension DateFormatter {
    
    // MARK: - Public properties
    
    static let iso8601WithSecsAndShortTimeZone = iso8601(with: "yyyy-MM-dd'T'HH:mm:ss'Z'")
    
    // MARK: - Private methods
    
    private static func iso8601(with dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        return formatter
    }
}
