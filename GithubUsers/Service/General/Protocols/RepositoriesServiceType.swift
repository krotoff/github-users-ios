//
//  RepositoriesServiceType.swift
//  Service
//
//  Created by Andrey Krotov on 28.01.2021.
//

import Foundation
import RxSwift
import Model

public protocol RepositoriesServiceType {
    var repositories: BehaviorSubject<[Int: DataSourceState<Repository>]> { get }
    var likedRepositories: BehaviorSubject<[Int]> { get }
    
    func getRepositories(for users: [Int: String])
    func updateRepositoryLike(id: Int, isLiked: Bool)
}
