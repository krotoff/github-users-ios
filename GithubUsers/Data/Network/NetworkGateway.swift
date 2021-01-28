//
//  NetworkGateway.swift
//  Data
//
//  Created by Andrey Krotov on 27.01.2021.
//

import Foundation
import RxSwift

final class NetworkingGateway: NetworkGatewayType {
    
    // MARK: - Private properties
    
    private let decoder = JSONDecoder()
    
    // MARK: - Internal methods
    
    func request<DataType: Decodable>(urlString: String, method: HTTPMethod) -> Single<DataType> {
        requestData(urlString: urlString)
            .flatMap { [unowned self] data in
                do {
                    return .just(try self.decoder.decode(DataType.self, from: data))
                } catch {
                    print("#ERR:", urlString, error)
                    return .error(error)
                }
            }
    }
    
    func requestData(urlString: String) -> Single<Data> {
        .create { [weak self] observer in
            let urlDataTask = self?.createDataTask(urlString: urlString, method: .get) { (data, response, error) in
                if let error = error {
                    print("#ERR:", urlString, error)
                    observer(.failure(error))
                } else if let data = data {
                    observer(.success(data))
                } else {
                    print("#ERR:", urlString, UnknownError())
                    observer(.failure(UnknownError()))
                }
            }
            
            urlDataTask?.resume()
            
            return Disposables.create {
                urlDataTask?.cancel()
            }
        }
    }
    
    // MARK: - Private methods
    
    func createDataTask(
        urlString: String,
        method: HTTPMethod,
        completion: @escaping ((Data?, URLResponse?, Error?) -> Void)
    ) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            print("#ERR: No URL from string", urlString)
            return nil
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
        request.httpMethod = method.rawValue
        
        return URLSession.shared.dataTask(with: request, completionHandler: completion)
    }
}

private struct UnknownError: Error {}
