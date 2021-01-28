//
//  FileSystemGatewayType.swift
//  Data
//
//  Created by Andrey Krotov on 28.01.2021.
//

import RxSwift

public protocol FileSystemGatewayType {
    func getData(name: String) -> Single<Data>
    func writeData(_ data: Data, name: String) -> Single<Void>
}
