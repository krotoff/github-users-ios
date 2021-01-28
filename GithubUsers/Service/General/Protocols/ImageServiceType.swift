//
//  ImageServiceType.swift
//  Service
//
//  Created by Andrey Krotov on 28.01.2021.
//

import Foundation
import RxSwift

public protocol ImageServiceType {
    var imagesData: BehaviorSubject<[Int: Data]> { get }
    
    func getImages(for users: [Int: String])
}
