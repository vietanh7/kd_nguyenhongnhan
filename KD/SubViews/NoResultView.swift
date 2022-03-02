//
//  NoResultView.swift
//  Gratitapp
//
//  Created by Nguyen Hong Nhan on 5/24/21.
//

import UIKit

// guide: NoResultView(imageName: "noResult_icon", title: "Lorem Ipsum", message: "Lorem Ipsum is simply dummy text \nof the printing industry.")
public class NoResultView: UIView {
    
    // MARK: - Layout structure
    /* --- layout structure ---
     view
        - vStack
            - iconImageView
            - vStackTitle
                - titleLabel
                - messageLabel
     */
    
    let vStack = UIStackView()
    let vStackTitle = UIStackView()
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        title.textColor = .black
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    
    var messageLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        title.textColor = .black
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    
    var idex: Int = 1
    
    // MARK: - Init View
    // #1
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // #2
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // #3
    public convenience init(imageName: String, title: String, message: String) {
        self.init(frame: .zero)
        self.iconImageView.image = UIImage(named: imageName)
        self.titleLabel.text = title
        self.messageLabel.text = message
        
        setupView()
    }
    
    // MARK: - Setup View
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // layout property
        
        vStack.axis  = NSLayoutConstraint.Axis.vertical
        vStack.distribution  = UIStackView.Distribution.equalSpacing
        vStack.alignment = UIStackView.Alignment.center
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = 30
        
        vStackTitle.axis  = NSLayoutConstraint.Axis.vertical
        vStackTitle.distribution  = UIStackView.Distribution.equalSpacing
        vStackTitle.alignment = UIStackView.Alignment.center
        vStackTitle.translatesAutoresizingMaskIntoConstraints = false
        vStackTitle.spacing = 5
        
        // layout constraint
        
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        vStack.addArrangedSubview(iconImageView)
        iconImageView.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(130)
            $0.centerX.equalToSuperview()
        }
        
        vStack.addArrangedSubview(vStackTitle)
        vStackTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        vStackTitle.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        vStackTitle.addArrangedSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
    }
}
