//
//  AppCoordinator.swift
//  GithubUsers
//
//  Created by Andrey Krotov on 28.01.2021.
//

import UIKit
import UI
import Service
import Data
import Model

final class AppCoordinator: Coordinator {
    
    // MARK: - Private properties
    
    private let window: UIWindow
    private let serviceFactory: ServiceFactory
    private let gatewayFactory: GatewayFactory
    private var navigationController: UINavigationController?
    
    // MARK: - Initialization
    
    init(window: UIWindow, serviceFactory: ServiceFactory, gatewayFactory: GatewayFactory) {
        self.window = window
        self.serviceFactory = serviceFactory
        self.gatewayFactory = gatewayFactory
        
        super.init()
    }
    
    // MARK: - RoutableCoordinator methods
    
    internal override func start(animated: Bool = true) {
        window.backgroundColor = .systemBackground
        
        startAppFlow()
    }
    
    // MARK: - Private methods
    
    private func startAppFlow() {
        navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        showRepositoryList()
    }
    
    private func showRepositoryList() {
        let coordinator = RepositoryListCoordinator(
            usersService: serviceFactory.users,
            repositoriesService: serviceFactory.repositories,
            imageService: serviceFactory.images
        )
        coordinator.configureCallbacks(
            openRoute: { [weak self] route in
                switch route {
                case .show(let controller):
                    self?.navigationController?.setViewControllers([controller], animated: false)
                case .showDetails(let repository):
                    self?.showRepositoryDetails(repository)
                }
            },
            onCompleted: {}
        )
        storeAndStart(coordinator)
    }
    
    private func showRepositoryDetails(_ repository: Repository) {
        let coordinator = RepositoryDetailsCoordinator(repositoriesService: serviceFactory.repositories, repository: repository)
        coordinator.configureCallbacks(
            openRoute: { [weak self] route in
                switch route {
                case .show(let controller):
                    self?.navigationController?.present(controller, animated: true)
                }
            },
            onCompleted: { [unowned coordinator, weak self] in
                self?.free(coordinator)
            }
        )
        storeAndStart(coordinator)
    }
}

