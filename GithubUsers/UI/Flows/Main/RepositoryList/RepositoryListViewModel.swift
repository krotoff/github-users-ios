//
//  RepositoryListViewModel.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import RxSwift
import Service
import Model

final class RepositoryListViewModel {
    
    // MARK: - Internal types
    
    struct SectionViewModel: Equatable {
        let id: Int
        let reposURL: String
        let imageData: Data?
        let title: String
        let cells: DataSourceState<CellViewModel>
    }
    
    struct CellViewModel: Equatable {
        let id: Int
        let name: String
        let isLiked: Bool
    }
    
    // MARK: - Internal properties
    
    let source = BehaviorSubject<DataSourceState<SectionViewModel>>(value: .isLoading)
    let repositoryToShow = PublishSubject<Repository>()
    
    // MARK: - Private properties
    
    private let users = BehaviorSubject<DataSourceState<User>>(value: .isLoading)
    
    private let usersService: UsersServiceType
    private let repositoriesService: RepositoriesServiceType
    private let imageService: ImageServiceType
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(usersService: UsersServiceType, repositoriesService: RepositoriesServiceType, imageService: ImageServiceType) {
        self.usersService = usersService
        self.repositoriesService = repositoriesService
        self.imageService = imageService
        
        bind()
    }
    
    // MARK: - Internal methods
    
    func fetch() {
        usersService.getUsers()
    }
    
    func fetchRepositories(of user: Int, urlString: String) {
        repositoriesService.getRepositories(for: [user: urlString])
    }
    
    func changeLikeState(for id: Int, isLiked: Bool) {
        repositoriesService.updateRepositoryLike(id: id, isLiked: isLiked)
    }
    
    func showRepositoryDetails(id: Int, userID: Int) {
        if let repositories = try? repositoriesService.repositories.value(), let userRepositories = repositories[userID] {
            switch userRepositories {
            case .isReady(let source):
                if let repository = source.first(where: { $0.id == id }) {
                    repositoryToShow.onNext(repository)
                }
            case .isLoading, .isFailed: break
            }
        }
    }
    
    // MARK: - Private methods
    
    private func bind() {
        usersService.users
            .do { [weak self] state in
                switch state {
                case .isReady(let source):
                    var reposToFetch = [Int: String]()
                    var imagesToFetch = [Int: String]()
                    source.forEach { user in
                        reposToFetch[user.id] = user.reposURL
                        imagesToFetch[user.id] = user.avatarURL
                    }
                    self?.repositoriesService.getRepositories(for: reposToFetch)
                    self?.imageService.getImages(for: imagesToFetch)
                default: break
                }
            }
            .bind(to: users)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(users, repositoriesService.repositories, repositoriesService.likedRepositories, imageService.imagesData)
            .map { [weak self] in self?.mapSource(users: $0.0, repositories: $0.1, likes: $0.2, images: $0.3) ?? .isLoading }
            .bind(to: source)
            .disposed(by: disposeBag)
    }
    
    private func mapSource(
        users: DataSourceState<User>,
        repositories: [Int: DataSourceState<Repository>],
        likes: [Int],
        images: [Int: Data]
    ) -> DataSourceState<SectionViewModel> {
        switch users {
        case .isLoading:
            return .isLoading
        case .isFailed(let error):
            return .isFailed(error: error)
        case .isReady(let users):
            let sections = users
                .map { user -> SectionViewModel in
                    let cells = repositories[user.id].map  { mapCells(repositories: $0, likes: likes) }
                    return SectionViewModel(
                        id: user.id,
                        reposURL: user.reposURL,
                        imageData: images[user.id],
                        title: user.login,
                        cells: cells ?? .isLoading
                    )
                }
            
            return .isReady(source: sections)
        }
    }
    
    private func mapCells(repositories: DataSourceState<Repository>, likes: [Int]) -> DataSourceState<CellViewModel> {
        switch repositories {
        case .isLoading:
            return .isLoading
        case .isFailed(let error):
            return .isFailed(error: error)
        case .isReady(let repositories):
            let cells = repositories
                .map { repository in
                    CellViewModel(id: repository.id, name: repository.name, isLiked: likes.contains(repository.id))
                }
            
            return .isReady(source: cells)
        }
    }
}
