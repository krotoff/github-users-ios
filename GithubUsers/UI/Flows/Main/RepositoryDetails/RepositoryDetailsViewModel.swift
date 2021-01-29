//
//  RepositoryDetailsViewModel.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import RxSwift
import Service
import Model

final class RepositoryDetailsViewModel {
    
    // MARK: - Internal types
    
    struct ScreenViewModel: Equatable {
        let id: Int
        let size: Int
        let name: String
        let createdAt: Date
        let description: String?
        let fork: Bool
        let isLiked: Bool
    }
    
    // MARK: - Internal properties
    
    let source = BehaviorSubject<ScreenViewModel?>(value: nil)
    
    // MARK: - Private properties
    
    private let users = BehaviorSubject<DataSourceState<User>>(value: .isLoading)
    
    private let repositoriesService: RepositoriesServiceType
    private let repository: Repository
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(repositoriesService: RepositoriesServiceType, repository: Repository) {
        self.repositoriesService = repositoriesService
        self.repository = repository
        
        bind()
    }
    
    // MARK: - Internal methods
    
    func changeLikeState(isLiked: Bool) {
        repositoriesService.updateRepositoryLike(id: repository.id, isLiked: isLiked)
    }
    
    // MARK: - Private methods
    
    private func bind() {
        repositoriesService.likedRepositories
            .map { [weak self] likedIDs -> ScreenViewModel? in
                guard let self = self else { return nil }
                
                let repository = self.repository
                let isLiked = likedIDs.contains(repository.id)
                
                return ScreenViewModel(
                    id: repository.id,
                    size: repository.size,
                    name: repository.name,
                    createdAt: repository.createdAt,
                    description: repository.description,
                    fork: repository.fork,
                    isLiked: isLiked
                )
            }
            .bind(to: source)
            .disposed(by: disposeBag)
    }
}
