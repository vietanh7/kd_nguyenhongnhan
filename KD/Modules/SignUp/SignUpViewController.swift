//
//  SignUpViewController.swift
//  DemoApp
//
//  Created by Nguyen Hong Nhan on 24/11/2021.
//

import UIKit

private let maxLengthUsername: Int = 50
private let maxLengthPassword: Int = 18

class SignUpViewController: BaseViewController {
    
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
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let passwordTextField: PasswordTextField = {
        let textField = PasswordTextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    var viewModel = SignUpViewModel(username: "", password: "")
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Config View
    override func setupData() {
        super.setupData()
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.edgesForExtendedLayout = []
        view.backgroundColor = .white
        
        title = "Register"
        
        // Navigation Bar
        let clearBarButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear))
        self.navigationItem.rightBarButtonItem = clearBarButton
        
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
        
        //MARK: - TextFields
        vStackContainer.addArrangedSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        usernameTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        usernameTextField.delegate = self
        
        vStackContainer.addArrangedSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        passwordTextField.delegate = self
        
        
        // MARK: - Buttons
        vStackContainer.addArrangedSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
    }
    
    //MARK: Binding
    override func bindingToView() {
        // username
        viewModel.$username
            .assign(to: \.text, on: usernameTextField)
            .store(in: &subscriptions)

        // password
        viewModel.$password
            .assign(to: \.text, on: passwordTextField)
            .store(in: &subscriptions)
        
        // enable & alpha button Login
        viewModel.isEnableButton
            .map { $0 != nil }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: &subscriptions)

        viewModel.isEnableButton
            .map {
                return ($0 != nil) ? 1.0 : 0.5
            }
            .receive(on: RunLoop.main)
            .assign(to: \.alpha, on: signUpButton)
            .store(in: &subscriptions)
        
        // show/hide loading
        viewModel.$isLoading
            .sink(receiveValue: { isLoading in
                if isLoading {
                    self.showLoading()
                } else {
                    self.hideLoading()
                }
            })
            .store(in: &subscriptions)
    }
    
    
    override func bindingToViewModel() {
        usernameTextField.publisher
            .sink { value in
                self.viewModel.username = value
            }
            .store(in: &subscriptions)
        
        passwordTextField.publisher
            .sink { value in
                self.viewModel.password = value
            }
            .store(in: &subscriptions)
    }
    
    //MARK: - Navigation
    override func router() {
        viewModel.state
            .sink { [weak self] state in
                if case .error(let message) = state {
                    self?.showAlert(imageName: nil, title: "Alert", message: message, positiveTitleButton: nil, positiveCompletion: nil)
                    
                } else if case .didSignUpSuccess = state {
                    self?.showAlert(title: "Alert", message: "Register success, please login.", positiveTitleButton: nil, positiveCompletion: { [weak self] in
                        DispatchQueue.main.async {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    })
                    
                }
            }.store(in: &subscriptions)
    }
    
    // MARK: - Actions
    @objc func clear() {
        viewModel.action.send(.clear)
    }
    @objc private func signUpButtonTapped(sender: UIButton) {
        if viewModel.onValidateDataInput() {
            viewModel.action.send(.signUp)
        }
    }
    
    // MARK: - Helper functions
    
}

//MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let newText = currentText.replacingCharacters(in: stringRange, with: string)
                
        if textField == usernameTextField {
            return newText.count <= maxLengthUsername
        }
        if textField == passwordTextField {
            return newText.count <= maxLengthPassword
        }
        
        return true
    }
    
    @objc
    func textFieldEditingDidChange(_ textField: UITextField) {
#if DEBUG
        if textField == usernameTextField {
            let phoneString = textField.text?.trim()
            switch phoneString {
            case "11":
                let username = "test0203@gmail.com"
                let password = "1q2w"

                textField.text = username
                passwordTextField.text = password
                signUpButton.isEnabled = true
                signUpButton.alpha = 1.0
                
                viewModel.username = username
                viewModel.password = password

            default:()
            }
        }
#endif

    }
        
}

