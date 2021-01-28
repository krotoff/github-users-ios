//
//  GatewayFactory.swift
//  Data
//
//  Created by Andrey Krotov on 27.01.2021.
//

public final class GatewayFactory {
    
    // MARK: - Public properties
    
    public let network: NetworkGatewayType = { NetworkingGateway() }()
    public let local: LocalGatewayType = { UserDefaultsGateway() }()
    public let fileSystem: FileSystemGatewayType = { FileSystemGateway() }()
    
    // MARK: - Initialization
    
    public init() {}
}
