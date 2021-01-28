//
//  UsersService.swift
//  Service
//
//  Created by Andrey Krotov on 28.01.2021.
//

import Foundation
import RxSwift
import Data
import Model

final class UsersService: UsersServiceType {
    
    // MARK: - Internal properties
    
    let users = BehaviorSubject<DataSourceState<User>>(value: .isLoading)
    
    // MARK: - Private properties
    
    private let network: NetworkGatewayType
    /*
     Да, базовые урлы лучше хранить в самом нетворке, но его, как и прочие гейтуэи, я сделал синглтоном во избежание наложений,
     а урлы на репы отдельные, потому решил сделать так.
    */
    private let baseURLString: String
    private var requestDisposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(network: NetworkGatewayType, baseURL: String) {
        self.network = network
        self.baseURLString = baseURL
    }
    
    // MARK: - Internal methods
    
    func getUsers() {
        requestDisposeBag = DisposeBag()
        
        network.request(urlString: baseURLString, method: .get)
            .subscribe(
                onSuccess: { [unowned self] users in
                    self.users.onNext(.isReady(source: users))
                },
                onFailure: { [unowned self] error in
                    self.users.onNext(.isFailed(error: error))
                }
            )
            .disposed(by: requestDisposeBag)
    }
}
