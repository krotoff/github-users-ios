//
//  UserDefaultsGateway.swift
//  Data
//
//  Created by Andrey Krotov on 27.01.2021.
//

import Foundation
import RxSwift
import RxDataSources

final class UserDefaultsGateway: LocalGatewayType {
    
    // MARK: - Private properties
    
    private let storage = UserDefaults.standard
    
    // MARK: - Internal methods
    
    func update<DataType: Any>(_ value: DataType, key: String) {
        storage.setValue(value, forKey: key)
    }
    
    func observeArray<DataType: Hashable>(key: String) -> Observable<[DataType]?> { storage.rx.observe([DataType].self, key) }
}
