//
//  RepositoryDetailsCoordinator.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import UIKit
import Service
import Model

public enum RepositoryDetailsRoute {
    case show(controller: UIViewController)
}

public final class RepositoryDetailsCoordinator: RoutableCoordinator<RepositoryDetailsRoute> {
    
    // MARK: - Private properties
    
    private let repositoriesService: RepositoriesServiceType
    private let repository: Repository
    
    // MARK: - Initialization
    
    public init(repositoriesService: RepositoriesServiceType, repository: Repository) {
        self.repositoriesService = repositoriesService
        self.repository = repository
    }
    
    // MARK: - Internal methods
    
    public override func start(animated: Bool = true) {
        let controller = RepositoryDetailsViewController()
        let viewModel = RepositoryDetailsViewModel(repositoriesService: repositoriesService, repository: repository)
        controller.configure(viewModel: viewModel)
        controller.onCompleted = { [weak self] in self?.onCompleted() }
        
        openRoute?(.show(controller: controller))
    }
}

