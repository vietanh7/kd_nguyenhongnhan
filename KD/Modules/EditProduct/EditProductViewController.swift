//
//  EditProductViewController.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

import UIKit

private let maxLengthUsername: Int = 50

protocol EditProductViewControllerDelegate: AnyObject {
    func onUpdateButtonTapped(dataModel: ProductModel)
}
class EditProductViewController: BaseViewController {
    
    weak var delegate: EditProductViewControllerDelegate?
    
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
    
    let skuTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "SKU"
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        textField.isUserInteractionEnabled = false
        textField.isEnabled = false
        return textField
    }()
    
    let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Product name"
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        return textField
    }()
    let qltTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Quality"
        textField.keyboardType = .numberPad
        return textField
    }()
    let priceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Price"
        textField.keyboardType = .numberPad
        return textField
    }()
    let unitTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Unit"
        textField.keyboardType = .default
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    var viewModel: EditProductViewModel
    init(dataModel: ProductModel) {
        viewModel = EditProductViewModel(dataModel: dataModel)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        title = "Edit product"
        
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
        vStackContainer.addArrangedSubview(skuTextField)
        skuTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        skuTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        skuTextField.delegate = self
        
        vStackContainer.addArrangedSubview(productNameTextField)
        productNameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        productNameTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        productNameTextField.delegate = self
        
        vStackContainer.addArrangedSubview(unitTextField)
        unitTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        unitTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        unitTextField.delegate = self
        
        vStackContainer.addArrangedSubview(qltTextField)
        qltTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        qltTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        qltTextField.delegate = self
        
        vStackContainer.addArrangedSubview(priceTextField)
        priceTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        priceTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControl.Event.editingChanged)
        priceTextField.delegate = self
        
        //MARK: - Buttons
        vStackContainer.addArrangedSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
    }
    
    //MARK: Binding
    override func bindingToView() {
        // username
        viewModel.$sku
            .assign(to: \.text, on: skuTextField)
            .store(in: &subscriptions)
        
        viewModel.$productName
            .assign(to: \.text, on: productNameTextField)
            .store(in: &subscriptions)
        
        viewModel.$qlt
            .assign(to: \.text, on: qltTextField)
            .store(in: &subscriptions)
        
        viewModel.$price
            .assign(to: \.text, on: priceTextField)
            .store(in: &subscriptions)
        
        viewModel.$unit
            .assign(to: \.text, on: unitTextField)
            .store(in: &subscriptions)
        
        // enable & alpha button Login
        viewModel.triggerEnableButton
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: saveButton)
            .store(in: &subscriptions)

        viewModel.triggerEnableButton
            .map {
                return ($0 == true) ? 1.0 : 0.5
            }
            .receive(on: RunLoop.main)
            .assign(to: \.alpha, on: saveButton)
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
        skuTextField.publisher
            .sink { value in
                self.viewModel.sku = value
            }
            .store(in: &subscriptions)
        
        productNameTextField.publisher
            .sink { value in
                self.viewModel.productName = value
            }
            .store(in: &subscriptions)
        
        qltTextField.publisher
            .sink { value in
                self.viewModel.qlt = value
            }
            .store(in: &subscriptions)
        
        priceTextField.publisher
            .sink { value in
                self.viewModel.price = value
            }
            .store(in: &subscriptions)
        
        unitTextField.publisher
            .sink { value in
                self.viewModel.unit = value
            }
            .store(in: &subscriptions)
        
    }
    
    //MARK: - Navigation
    override func router() {
        viewModel.state
            .sink { [weak self] state in
                switch state {
                    
                case .error(let message):
                    self?.showAlert(imageName: nil, title: "Alert", message: message, positiveTitleButton: nil, positiveCompletion: nil)
                    
                case .saveSuccess:
                    self?.showAlert(title: "Alert", message: "Update product success", positiveTitleButton: nil, positiveCompletion: { [weak self] in
                        
                        if let productModel = self?.viewModel.productModel {
                            self?.delegate?.onUpdateButtonTapped(dataModel: productModel)
                        }
                        
                        DispatchQueue.main.async {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    })
                    
                default:
                    break
                    
                }
            }.store(in: &subscriptions)
    }
        
    //MARK: - Actions
    
    @objc private func saveButtonTapped(sender: UIButton) {
        viewModel.action.send(.saveProduct)
    }
    
    // MARK: - Helper functions
   
}

//MARK: - UITextFieldDelegate
extension EditProductViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let newText = currentText.replacingCharacters(in: stringRange, with: string)

        if textField == skuTextField {
            return newText.count <= maxLengthUsername
        }

        return true
    }

    @objc
    func textFieldEditingDidChange(_ textField: UITextField) {
        //
    }
    
}
