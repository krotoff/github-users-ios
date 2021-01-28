//
//  RepositoriesService.swift
//  Service
//
//  Created by Andrey Krotov on 28.01.2021.
//

import Foundation
import RxSwift
import Data
import Model

final class RepositoriesService: RepositoriesServiceType {
    
    // MARK: - Internal properties
    
    let repositories = BehaviorSubject<[Int: DataSourceState<Repository>]>(value: [:])
    let likedRepositories = BehaviorSubject<[Int]>(value: [])
    
    // MARK: - Private properties
    
    private let local: LocalGatewayType
    private let network: NetworkGatewayType
    private let likedRepositoriesKey = "github_users.liked_repositories_key"
    private var requestDisposeBag = DisposeBag()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(local: LocalGatewayType, network: NetworkGatewayType) {
        self.local = local
        self.network = network
    }
    
    // MARK: - Internal methods
    
    func getRepositories(for users: [Int: String]) {
        requestDisposeBag = DisposeBag()
        var newRepositories = (try? repositories.value()) ?? [:]
        users.keys.forEach { id in
            switch newRepositories[id] {
            case .isLoading, .isReady: break
            case .isFailed, .none: newRepositories[id] = .isLoading
            }
        }
        repositories.onNext(newRepositories)
        
        users.forEach { (id, urlString) in
            network.request(urlString: urlString, method: .get)
                .subscribe(
                    onSuccess: { [unowned self] repositories in
                        self.updateRepositoryList(id: id, state: .isReady(source: repositories))
                    },
                    onFailure: { [unowned self] error in
                        self.updateRepositoryList(id: id, state: .isFailed(error: error))
                    }
                )
                .disposed(by: requestDisposeBag)
        }
    }
    
    func updateRepositoryLike(id: Int, isLiked: Bool) {
        var likes = (try? likedRepositories.value()) ?? []
        if let index = likes.firstIndex(of: id), !isLiked {
            likes.remove(at: index)
        } else if isLiked, likes.firstIndex(of: id) == nil {
            likes.append(id)
        }
        local.update(likes, key: likedRepositoriesKey)
    }
    
    // MARK: - Private methods
    
    private func bind() {
        local.observeArray(key: likedRepositoriesKey)
            .map { $0 ?? [] }
            .bind(to: likedRepositories)
            .disposed(by: disposeBag)
    }
    
    private func updateRepositoryList(id: Int, state: DataSourceState<Repository>) {
        var newRepositories = (try? repositories.value()) ?? [:]
        newRepositories[id] = state
        repositories.onNext(newRepositories)
    }
}
