//
//  ServiceFactory.swift
//  Service
//
//  Created by Andrey Krotov on 28.01.2021.
//

import Foundation
import Data

public final class ServiceFactory {
    
    // MARK: - Public properties
    
    public lazy var users: UsersServiceType = { UsersService(network: self.gatewayFactory.network, baseURL: self.baseURL) }()
    
    public lazy var repositories: RepositoriesServiceType = {
        RepositoriesService(local: self.gatewayFactory.local, network: self.gatewayFactory.network)
    }()
    
    public lazy var images: ImageServiceType = {
        ImageService(network: self.gatewayFactory.network, fileSystem: self.gatewayFactory.fileSystem)
    }()
    
    // MARK: - Private properties
    
    private let gatewayFactory: GatewayFactory
    private let baseURL: String
    
    // MARK: - Initialization
    
    public init(gatewayFactory: GatewayFactory, baseURL: String) {
        self.gatewayFactory = gatewayFactory
        self.baseURL = baseURL
    }
}

public enum DataSourceState<Element: Equatable> {
    case isLoading
    case isFailed(error: Error)
    case isReady(source: [Element])
}

extension DataSourceState: Equatable {
    public static func == (lhs: DataSourceState<Element>, rhs: DataSourceState<Element>) -> Bool {
        switch lhs {
        case .isLoading:
            return rhs == .isLoading
        case .isFailed(let lhsError):
            switch rhs {
            case .isFailed(let rhsError):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
            }
        case .isReady(let lhsSource):
            switch rhs {
            case .isReady(let rhsSource):
                return lhsSource == rhsSource
            default:
                return false
            }
        }
    }
}
