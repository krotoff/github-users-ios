//
//  FileSystemGateway.swift
//  Data
//
//  Created by Andrey Krotov on 28.01.2021.
//

import Foundation
import RxSwift

final class FileSystemGateway: FileSystemGatewayType {
    
    // MARK: - Private properties
    
    private var directory: URL { FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] }
    
    // MARK: - Internal methods
    
    func getData(name: String) -> Single<Data> {
        .create { [unowned self] observer in
            do {
                observer(.success(try Data(contentsOf: self.directory.appendingPathComponent(name))))
            } catch {
                observer(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    func writeData(_ data: Data, name: String) -> Single<Void> {
        .create { [unowned self] observer in
            do {
                observer(.success(try data.write(to: self.directory.appendingPathComponent(name))))
            } catch {
                observer(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}
