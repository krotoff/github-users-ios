//
//  AppDelegate.swift
//  GithubUsers
//
//  Created by Andrey Krotov on 27.01.2021.
//

import UIKit
import RxSwift
import UI
import Service
import Data

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Internal properties
    
    var window: UIWindow?
    
    // MARK: - Private properties
    
    private var coordinator: Coordinator?
    private let disposeBag = DisposeBag()
    private let likes = BehaviorSubject<[Int]?>(value: nil)
    
    // MARK: - UIApplicationDelegate methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let gatewayFactory = GatewayFactory()
        let serviceFactory = ServiceFactory(gatewayFactory: gatewayFactory, baseURL: "https://api.github.com/users")
        
        window = UIWindow()
        
        let coordinator = AppCoordinator(window: window!, serviceFactory: serviceFactory, gatewayFactory: gatewayFactory)
        coordinator.start()

        self.coordinator = coordinator
        
        return true
    }
}

