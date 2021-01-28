//
//  NetworkGatewayType.swift
//  Data
//
//  Created by Andrey Krotov on 27.01.2021.
//

import Foundation
import RxSwift

public protocol NetworkGatewayType {
    func request<DataType: Decodable>(urlString: String, method: HTTPMethod) -> Single<DataType>
    func requestData(urlString: String) -> Single<Data>
}

// MARK: - Public types

public enum HTTPMethod: String {
    case get = "GET"
}
