//
//  UsersServiceType.swift
//  Service
//
//  Created by Andrey Krotov on 28.01.2021.
//

import Foundation
import RxSwift
import Model

public protocol UsersServiceType {
    var users: BehaviorSubject<DataSourceState<User>> { get }
    
    func getUsers()
}
