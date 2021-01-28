//
//  LocalGatewayType.swift
//  Data
//
//  Created by Andrey Krotov on 28.01.2021.
//

import Foundation
import RxSwift

public protocol LocalGatewayType {
    func update<DataType: Any>(_ value: DataType, key: String)
    func observeArray<DataType: Hashable>(key: String) -> Observable<[DataType]?>
}
