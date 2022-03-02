//
//  NavigationController.swift
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

import UIKit

class AppNavigationController: UINavigationController {

    public static let sharedInstance    = AppNavigationController(rootViewController: SplashViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
