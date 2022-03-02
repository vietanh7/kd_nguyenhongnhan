//
//  BaseViewController.swift
//  InitBaseProject
//
//  Created by Nguyen Hong Nhan on 12/10/2021.
//

import UIKit
import Combine

protocol BaseProtocol: AnyObject {
    //MARK: - Properties
    var subscriptions: [AnyCancellable] { get set }
    
    //MARK: - Configuration
    func setupUI()
    func setupData()
    func bindingToView()
    func bindingToViewModel()
    
    //MARK: - Navigation
    func router()
}

class BaseViewController: UIViewController, BaseProtocol {
    
    //MARK: - Properties
    var subscriptions = [AnyCancellable]()
    
    //MARK: - Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
        bindingToView()
        bindingToViewModel()
        router()
    }
    
    //MARK: - Configuration
    func setupData() { }
    
    func setupUI() { }
    
    func bindingToView() { }
    
    func bindingToViewModel() { }
    
    //MARK: - Navigation
    func router() { }
    
    //MARK: - Publish functions
    func alert(title: String, text: String?) -> AnyPublisher<Void, Never> {
        let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        return Future { resolve in
            alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
                resolve(.success(()))
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }.handleEvents(receiveCancel: {
            self.dismiss(animated: true)
        }).eraseToAnyPublisher()
    }
    
    deinit {
        subscriptions.removeAll()
        NotificationCenter.default.removeObserver(self)
    }
    
    public func setupBackgroundView(imageName: String? = nil) {
        if let imageName = imageName {
            let imageView: UIImageView = {
                let imageView = UIImageView(frame: .zero)
                imageView.image = UIImage(named: imageName)
                imageView.contentMode = .scaleToFill
                imageView.translatesAutoresizingMaskIntoConstraints = false
                return imageView
            }()
            view.insertSubview(imageView, at: 0)
            imageView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        } else {
            view.backgroundColor = .red
        }
    }
    
    public func setupNavBackButton(imageName: String? = nil) {
        var image = UIImage()
        if let nameString = imageName {
            image = UIImage(named: nameString) ?? UIImage()
        } else {
            // use icon from assets
            //image = imageFromBundle("outline_arrow_back_white_48pt")
            
            // use icon from material
            image = UIImage(systemName: "arrow.left") ?? UIImage()
        }
        let backButton = UIBarButtonItem.init(image: image.withRenderingMode(.alwaysOriginal),
                                              style: .plain,
                                              target: self,
                                              action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    public func hideNavigationBarBottomLine() {
        if #available(iOS 13.0, *) {
            if let navigationBar = navigationController?.navigationBar {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.shadowColor = .clear
                appearance.shadowImage = UIImage()
                appearance.backgroundColor = .clear
                
                navigationBar.standardAppearance = appearance
                navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
            }
        } else {
            // Fallback on earlier versions
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    
    public func clearNavigationBarColor() {
        if #available(iOS 13.0, *) {
            if let navigationBar = navigationController?.navigationBar {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .clear
                
                navigationBar.standardAppearance = appearance
                navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
            }
        } else {
            // Fallback on earlier versions
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = UIColor.clear
        }
    }
    
    //MARK: - Actions
    
    @objc open func backButtonTapped() {
        if self.isModalPresenting {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Internal funcs
    
    internal func imageFromBundle(_ named: String) -> UIImage {
        return UIImage(named: named, in: Bundle(for: BaseViewController.self), compatibleWith: nil) ?? UIImage()
    }
    
}

extension BaseViewController: BaseViewModelOutput {
    func didStartRequestAPI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoading()
        }
    }
    
    func didFinishRequestAPI() {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.hideLoading()
        }
    }
    
    func didGetErrorMessage(errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showAlert(title: "Oops!", message: errorMessage, positiveTitleButton: "Ok", positiveCompletion: nil)
        }
    }
    
    func didGetSuccessMessage(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showAlert(title: title, message: message, positiveTitleButton: "Ok", positiveCompletion: nil)
        }
    }
    
}
