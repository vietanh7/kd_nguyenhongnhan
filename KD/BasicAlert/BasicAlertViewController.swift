//
//  BasicAlertViewController.swift
//  InitBaseProject
//
//  Created by Nguyen Hong Nhan on 16/11/2021.
//

import UIKit

enum AlertType {
    case confirmation // 2 buttons: cancel vs ok
    case warning // 1 button: ok
}
class BasicAlertViewController: UIViewController {
    private var alertWindow: UIWindow!
    private let alertSize = UIScreen.main.bounds.width * 0.85
    
    // MARK: - Layout structure
    /*
     contentView
        - vStackContainer (used to hide component un use)
            - viewContainPhoto
                - photoImageView
            - viewLabel
                - titleLabel
            - viewMessage
                - messageLabel
            - hStackButtons
                - negativeButton
                - positiveButton
     */
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = false
        return view
    }()
    
    let vStackContainer: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fillProportionally
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = 5
        return vStack
    }()
    
    let viewContainImage: UIView = {
        let view = UIView()
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        return imageView
    }()
    
    let viewTitle: UIView = {
        let view = UIView()
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        label.backgroundColor = DebugColor.view.associatedColor
        return label
    }()

    let viewMessage: UIView = {
        let view = UIView()
        return view
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = DebugColor.view.associatedColor
        return label
    }()
    
    let hStackButtons: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fillEqually
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = 10
        return hStack
    }()
    
    let negativeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.addTarget(self, action: #selector(negativeButtonTapped(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let positiveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.addTarget(self, action: #selector(positiveButtonTapped(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    var alertType: AlertType
    var titleString: String
    var messageString: String
    var imageName: String
    var negativeTitleButton: String
    var positiveTitleButton: String
    
    // MARK: - Callback funcs
    var didPositiveButtonTapped: (()->Void)?
    var didNegativeButtonTapped: (()->Void)?
    
    // MARK: - Init
    init(alertType: AlertType, imageName: String? = nil, title: String? = nil, message: String? = nil, negativeTitleButton: String? = nil, positiveTitleButton: String? = nil) {
        self.alertType = alertType //?? .warning
        self.imageName = imageName ?? ""
        self.titleString = title ?? "Title"
        self.messageString = message ?? "Message"
        self.negativeTitleButton = negativeTitleButton ?? "Cancel"
        self.positiveTitleButton = positiveTitleButton ?? "Ok"
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported. You must create this view controller with a parameters")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupData()
    }
    
    // MARK: - Helper functions
    private func setupView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(alertSize)
            make.height.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-30)
        }
        
        containerView.addSubview(vStackContainer)
        vStackContainer.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(0)
            make.bottom.equalTo(-20)
            make.right.equalTo(0)
        }

        vStackContainer.addArrangedSubview(viewContainImage)
        viewContainImage.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        viewContainImage.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        vStackContainer.addArrangedSubview(viewTitle)
        viewTitle.snp.makeConstraints { make in
            make.left.right.equalTo(0)
        }
        viewTitle.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
        }
        
        vStackContainer.addArrangedSubview(viewMessage)
        viewMessage.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.greaterThanOrEqualTo(100)
        }
        viewMessage.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }

        let viewHStack = UIView()
        vStackContainer.addArrangedSubview(viewHStack)
        viewHStack.addSubview(hStackButtons)
        hStackButtons.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }

        hStackButtons.addArrangedSubview(negativeButton)
        negativeButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.bottom.equalTo(0)
        }

        hStackButtons.addArrangedSubview(positiveButton)
        positiveButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.bottom.equalTo(0)
        }
        
        // end
    }
    
    private func setupData() {
        self.imageView.image = UIImage(named: imageName)
        self.titleLabel.text = titleString
        self.messageLabel.text = messageString
        self.negativeButton.setTitle(negativeTitleButton, for: .normal)
        self.positiveButton.setTitle(positiveTitleButton, for: .normal)
        
        viewContainImage.isHidden = (self.imageName == "") ? true : false
        negativeButton.isHidden = (alertType == .warning) ? true : false
        
        if alertType == .warning {
            hStackButtons.snp.remakeConstraints { make in
                make.left.equalTo(70)
                make.right.equalTo(-70)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
            }
        }
    }

    // MARK: - Actions

    @objc private func negativeButtonTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        alertWindow = nil
        _AppDelegate.window?.makeKeyAndVisible()
        didNegativeButtonTapped?()
    }

    @objc private func positiveButtonTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        alertWindow = nil
        _AppDelegate.window?.makeKeyAndVisible()
        didPositiveButtonTapped?()
    }

    func show(animated: Bool, completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.alertWindow = UIWindow(frame: UIScreen.main.bounds)
            self.alertWindow.rootViewController = UIViewController()
            self.alertWindow.windowLevel = .alert + 1
            self.alertWindow.makeKeyAndVisible()
            self.alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
        }
    }

    

}
