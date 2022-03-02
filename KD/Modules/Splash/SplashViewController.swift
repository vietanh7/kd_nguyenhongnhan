//
//  SplashViewController.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

import UIKit

class SplashViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        
        self.view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _NavController.setNavigationBarHidden(true, animated: true)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.gotoProducts()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //_NavController.setNavigationBarHidden(false, animated: true)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func gotoProducts() {
        let viewController = ProductsViewController()
        _NavController.setViewControllers([viewController], animated: true)
    }

}
