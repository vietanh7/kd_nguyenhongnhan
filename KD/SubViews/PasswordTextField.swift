//
//  PasswordTextField.swift
//  DemoApp
//
//  Created by Nguyen Hong Nhan on 24/11/2021.
//

import UIKit

class PasswordTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 30)
    private let showPasswordButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.textColor = .black
        //self.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.isSecureTextEntry = true
        self.autocapitalizationType = .none
        
        showPasswordButton.addTarget(self, action: #selector(showPasswordButtonTapped(sender:)), for: .touchUpInside)
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(showPasswordButton)
        NSLayoutConstraint.activate([
            showPasswordButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            showPasswordButton.heightAnchor.constraint(equalToConstant: 24),
            showPasswordButton.widthAnchor.constraint(equalToConstant: 24),
            showPasswordButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
    // MARK: - Helper functions
    @objc private func showPasswordButtonTapped(sender: UIButton) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        self.showPasswordButton.isSelected = !isSecureTextEntry
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
