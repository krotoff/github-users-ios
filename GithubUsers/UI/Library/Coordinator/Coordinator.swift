//
//  Coordinator.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import Foundation

public protocol CoordinatorType {
    var identifier: UUID { get }
    
    func start(animated: Bool)
    func stop(animated: Bool)
    func stop(animated: Bool, completion: (() -> Void)?)
}

open class Coordinator: CoordinatorType {
    
    // MARK: - Public properties
    
    public let identifier = UUID()
    
    // MARK: - Internal properties
        
    var onCompleted: (() -> Void)!
    
    // MARK: - Private properties
    
    private var childCoordinators = [UUID: CoordinatorType]()
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - CoordinatorType methods
    
    open func start(animated: Bool = true) {
        fatalError("#ERR: Method start(animated:) for \(Self.self) should be implemented")
    }
    
    open func stop(animated: Bool = true) {
        stop(animated: animated, completion: nil)
    }
    
    open func stop(animated: Bool = true, completion: (() -> Void)?) {}
    
    // MARK: - Open methods
    
    @discardableResult
    open func configureCallbacks(onCompleted: @escaping (() -> Void)) -> Coordinator {
        self.onCompleted = onCompleted
        
        return self
    }
    
    // MARK: - Public methods
    
    public func storeAndStart(_ coordinator: CoordinatorType, animated: Bool = true) {
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.start(animated: animated)
    }
    
    public func free(_ coordinator: CoordinatorType, animated: Bool = true, completion: (() -> Void)? = nil) {
        coordinator.stop(animated: animated, completion: completion)
        childCoordinators.removeValue(forKey: coordinator.identifier)
    }
    
    public func freeAllChildren(animated: Bool = true) {
        childCoordinators.values.forEach { [weak self] coordinator in
            self?.free(coordinator, animated: animated)
        }
    }
}

open class RoutableCoordinator<Route>: Coordinator {
    
    // MARK: - Internal properties
    
    var openRoute: ((Route) -> Void)?
    
    // MARK: - Open methods
    
    @discardableResult
    open func configureCallbacks(openRoute: @escaping ((Route) -> Void), onCompleted: @escaping (() -> Void)) -> Coordinator {
        self.openRoute = openRoute
        
        return super.configureCallbacks(onCompleted: onCompleted)
    }
}
