//
//  ImageService.swift
//  Service
//
//  Created by Andrey Krotov on 28.01.2021.
//

import Foundation
import RxSwift
import Data

final class ImageService: ImageServiceType {
    
    // MARK: - Internal properties
    
    let imagesData = BehaviorSubject<[Int: Data]>(value: [:])
    
    // MARK: - Private properties
    
    private let network: NetworkGatewayType
    private let fileSystem: FileSystemGatewayType
    private var requestDisposeBag = DisposeBag()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(network: NetworkGatewayType, fileSystem: FileSystemGatewayType) {
        self.network = network
        self.fileSystem = fileSystem
    }
    
    // MARK: - Internal methods
    
    func getImages(for users: [Int: String]) {
        requestDisposeBag = DisposeBag()
        
        users.forEach(fetchImageData)
    }
    
    // MARK: - Private methods
    
    private func fetchImageData(id: Int, urlString: String) {
        fileSystem.getData(name: String(id))
            .subscribe(
                onSuccess: { [unowned self] data in
                    self.updateList(id: id, data: data)
                },
                onFailure: { [unowned self] _ in
                    self.downloadImage(id: id, urlString: urlString)
                }
            )
            .disposed(by: requestDisposeBag)
    }
    
    private func downloadImage(id: Int, urlString: String) {
        network.requestData(urlString: urlString)
            .do { [unowned self] data in
                self.fileSystem.writeData(data, name: String(id))
                    .subscribe()
                    .disposed(by: self.disposeBag)
            }
            .subscribe { [unowned self] data in
                self.updateList(id: id, data: data)
            }
            .disposed(by: requestDisposeBag)
    }
    
    private func updateList(id: Int, data: Data) {
        var list = (try? imagesData.value()) ?? [:]
        list[id] = data
        imagesData.onNext(list)
    }
}
