//
//  AppDelegate.swift
//  GithubUsers
//
//  Created by Andrey Krotov on 27.01.2021.
//

import UIKit
import RxSwift
import Service
import Data

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Private properties
    
    private var serviceFactory: ServiceFactory!
    private let gatewayFactory = GatewayFactory()
    private let db = DisposeBag()
    
    // MARK: - UIApplicationDelegate methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        serviceFactory = ServiceFactory(gatewayFactory: gatewayFactory, baseURL: "https://api.github.com/users")
        
        return true
    }
}

