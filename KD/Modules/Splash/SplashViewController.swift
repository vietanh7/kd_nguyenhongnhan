//
//  SplashViewController.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

import UIKit

class SplashViewController: UIViewController {
        
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        label.backgroundColor = DebugColor.view.associatedColor
        label.text = "Welcome to Klikdokter"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    private func setupUI(){
        self.edgesForExtendedLayout = []
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _NavController.setNavigationBarHidden(true, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
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
