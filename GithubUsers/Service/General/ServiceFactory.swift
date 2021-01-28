//
//  ServiceFactory.swift
//  Service
//
//  Created by Andrey Krotov on 28.01.2021.
//

import Foundation

public final class ServiceFactory {
    
}

public enum DataSourceState<Element> {
    case isLoading
    case isFailed(error: Error)
    case isReady(source: [Element])
}
