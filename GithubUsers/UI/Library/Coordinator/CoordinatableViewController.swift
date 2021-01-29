//
//  CoordinatableViewController.swift
//  UI
//
//  Created by Andrey Krotov on 28.01.2021.
//

import UIKit

open class CoordinatableViewController: UIViewController {
    
    // MARK: - Internal properties
    
    var onCompleted: (() -> Void)?
    
    // MARK: - View lifecycle
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let navController = navigationController {
            let vcWasDeleted = !navController.viewControllers.contains(self)
            let vcIsOnlyOne = navController.viewControllers.count == 1
            let unownedNavVC = navController.parent == nil && navController.presentedViewController == nil
                
            if vcWasDeleted || (vcIsOnlyOne && unownedNavVC) {
                onCompleted?()
            }
        } else  {
            onCompleted?()
        }
    }
}
