//
//  ProductsViewController.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

import UIKit

class ProductsViewController: BaseViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let vStackContainer: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fillProportionally
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = 5
        return vStack
    }()
    
    let gotoSignUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(gotoSignUpButtonTapped(sender:)), for: .touchUpInside)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10.0
        return button
    }()
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _NavController.setNavigationBarHidden(false, animated: true)
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.edgesForExtendedLayout = []
        view.backgroundColor = .white
        
        title = "Products"
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            $0.left.bottom.right.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            //$0.height.equalTo(1500)
        }
        
        contentView.addSubview(vStackContainer)
        vStackContainer.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 100, left: 15, bottom: 0, right: 15))
        }
        
        
        // hStask: contain button register/login
        // MARK: - hStackButtons
        let hStackButtons: UIStackView = {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.alignment = .trailing
            hStack.distribution = .fillEqually
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.spacing = 1
            return hStack
        }()
        vStackContainer.addArrangedSubview(hStackButtons)
        hStackButtons.snp.makeConstraints { make in
            make.left.right.equalTo(0)
        }

        hStackButtons.addArrangedSubview(gotoSignUpButton)
        gotoSignUpButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.bottom.equalTo(0)
        }

        hStackButtons.addArrangedSubview(gotoLoginButton)
        gotoLoginButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.bottom.equalTo(0)
        }
        
        
        
    }
    
    // MARK: - Actions
    @objc private func gotoSignUpButtonTapped(sender: UIButton) {
        let viewController = LoginViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
      
    }
    
    // MARK: - Actions
    @objc private func gotoLoginButtonTapped(sender: UIButton) {
        let viewController = LoginViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
      
    }
    

}
