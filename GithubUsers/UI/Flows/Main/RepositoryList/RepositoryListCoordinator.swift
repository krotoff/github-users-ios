//
//  RepositoryListCoordinator.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import UIKit
import RxSwift
import Service
import Model

public enum RepositoryListRoute {
    case show(controller: UIViewController)
    case showDetails(repository: Repository)
}

public final class RepositoryListCoordinator: RoutableCoordinator<RepositoryListRoute> {
    
    // MARK: - Private properties
    
    private let usersService: UsersServiceType
    private let repositoriesService: RepositoriesServiceType
    private let imageService: ImageServiceType
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    public init(usersService: UsersServiceType, repositoriesService: RepositoriesServiceType, imageService: ImageServiceType) {
        self.usersService = usersService
        self.repositoriesService = repositoriesService
        self.imageService = imageService
    }
    
    // MARK: - Internal methods
    
    public override func start(animated: Bool = true) {
        let controller = RepositoryListViewController()
        let viewModel = RepositoryListViewModel(
            usersService: usersService,
            repositoriesService: repositoriesService,
            imageService: imageService
        )
        
        controller.configure(viewModel: viewModel)
        controller.onCompleted = { [weak self] in self?.onCompleted() }
        
        viewModel.repositoryToShow
            .subscribe { [weak self] repository in
                self?.openRoute?(.showDetails(repository: repository))
            }
            .disposed(by: disposeBag)
        
        openRoute?(.show(controller: controller))
    }
}
