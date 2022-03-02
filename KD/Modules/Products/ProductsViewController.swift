//
//  ProductsViewController.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

import UIKit

class ProductsViewController: BaseViewController {

    let gotoLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(gotoLoginButtonTapped(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        print("products screen")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _NavController.setNavigationBarHidden(false, animated: true)
    }
    
    override func setupUI() {
        view.backgroundColor = .white // to visually distinguish the protected part
        title = "Products"
    }
    
    // MARK: - Actions
    @objc private func gotoLoginButtonTapped(sender: UIButton) {
//        let viewController = LoginViewController()
//        self?.navigationController?.pushViewController(viewController, animated: true)
      
    }
    

}
