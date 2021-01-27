//
//  DateDecoder.swift
//  Model
//
//  Created by Andrey Krotov on 27.01.2021.
//

import Foundation

public extension KeyedDecodingContainer {
    /// Formatters should be ordered by priority: the first correct will be chosen
    func decodeDate(forKey key: Self.Key, with formatters: [DateFormatter]) throws -> Date? {
        guard let stringDate = try decodeIfPresent(String.self, forKey: key), !stringDate.isEmpty else {
            print("#ERR: Can't decode stringDate: decoding Data is not a String")
            return nil
        }
        guard let date = formatters.compactMap({ $0.date(from: stringDate) }).first else {
            print("#ERR: Can't format date from string: \(stringDate) with formatters: \(formatters.map { $0.dateFormat })")
            return nil
        }
        
        return date
    }
}
