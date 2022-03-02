//
//  SkeletonTableViewCell.swift
//  InitBaseProject
//
//  Created by Nguyen Hong Nhan on 01/11/2021.
//

import UIKit
import SnapKit
import SkeletonView

private let regularConfig = UIImage.SymbolConfiguration(weight: .regular)
private let semiBoldConfig = UIImage.SymbolConfiguration(weight: .semibold)

class SkeletonTableViewCell: UITableViewCell {
    
    let viewCard: UIView = {
        let view = UIView()
        view.backgroundColor = DebugColor.view.associatedColor
        return view
    }()
    
    let vStackContainer: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.distribution = .equalSpacing
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = 5
        return vStack
    }()
    
    let hStackUserInfo: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .leading
        hStack.distribution = .fillProportionally
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = 5
        return hStack
    }()
    
    let viewText: UIView = {
        let view = UIView()
        view.backgroundColor = DebugColor.view.associatedColor
        return view
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = DebugColor.subView.associatedColor
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.backgroundColor = DebugColor.view.associatedColor
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = DebugColor.view.associatedColor
        return label
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.isScrollEnabled = false
        //textView.sizeToFit()
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.textAlignment = .left
        textView.textColor = .black
        textView.isSelectable = false
        textView.backgroundColor = DebugColor.view.associatedColor
        return textView
    }()
    
    let updateFavoriteButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitle("Love", for: .normal)
        button.imageEdgeInsets.left = -6
        if #available(iOS 13.0, *) {
            button.setImage(
                UIImage(systemName: "heart", withConfiguration: regularConfig), for: .normal)
            button.setImage(UIImage(systemName: "heart.fill", withConfiguration: semiBoldConfig), for: .selected)
        } else {
            // Fallback on earlier versions
        }
        
//        button.addTarget(self, action: #selector(updateFavoriteButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    let selectButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitle("Detail", for: .normal)
        button.imageEdgeInsets.left = -6
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "arrow.right", withConfiguration: regularConfig), for: .normal)
            button.setImage(UIImage(systemName: "arrow.right", withConfiguration: semiBoldConfig), for: .selected)
        } else {
            // Fallback on earlier versions
        }
        
//        button.addTarget(self, action: #selector(selectButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    let viewContainAvatar = UIView()
    let viewLabels = UIView()
    let vStackLabels: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .fill
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = 3
        return vStack
    }()
    
    let hStackButtons: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fillEqually
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = 1
        return hStack
    }()
    
    let topSeparatorView = UIView()
    let bottomSeparatorView = UIView()
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        imageView.backgroundColor = DebugColor.subView.associatedColor
        return imageView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .white
        
        setupView()
        showAnimate()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup View
    
    func setupView() {
        self.backgroundColor = .white
         
        contentView.addSubview(viewCard)
        viewCard.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
        
        viewCard.addSubview(vStackContainer)
        contentView.addSubview(vStackContainer)
        vStackContainer.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        // MARK: - topSeparatorView
        
        topSeparatorView.backgroundColor = .lightGray
        vStackContainer.addArrangedSubview(topSeparatorView)
        topSeparatorView.snp.makeConstraints { make in
            make.height.equalTo(8.0)
            make.left.right.equalTo(0)
        }
        
        // MARK: - hStackUserInfo
        vStackContainer.addArrangedSubview(hStackUserInfo)
        hStackUserInfo.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(0)
        }

       
        viewContainAvatar.backgroundColor = DebugColor.view.associatedColor

        hStackUserInfo.addArrangedSubview(viewContainAvatar)
        viewContainAvatar.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0).priority(.low)
        }

        viewContainAvatar.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.left.equalTo(16)
            make.right.equalTo(-8)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
        }

        
        hStackUserInfo.addArrangedSubview(viewLabels)
        viewLabels.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0).priority(.high)
        }

        

        viewLabels.addSubview(vStackLabels)
        vStackLabels.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(8)
            make.bottom.equalTo(0)
        }

        vStackLabels.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(-10)
        }
        vStackLabels.addArrangedSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(-10)
        }
        
        // MARK: - viewText
        vStackContainer.addArrangedSubview(viewText)
        viewText.snp.makeConstraints { make in
            make.left.right.equalTo(0)
        }

        viewText.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }

        // MARK: - viewPhoto

        // MARK: - hStackButtons
        
        vStackContainer.addArrangedSubview(hStackButtons)
        hStackButtons.snp.makeConstraints { make in
            make.left.right.equalTo(0)
        }

        hStackButtons.addArrangedSubview(updateFavoriteButton)
        updateFavoriteButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.bottom.equalTo(0)
        }

        hStackButtons.addArrangedSubview(selectButton)
        selectButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.bottom.equalTo(0)
        }
        
        // MARK: - bottomSeparatorView
        
        bottomSeparatorView.backgroundColor = .lightGray
        vStackContainer.addArrangedSubview(bottomSeparatorView)
        bottomSeparatorView.snp.makeConstraints { make in
            make.height.equalTo(8.0)
            make.left.right.equalTo(0)
        }
        // end
        
        if let index = self.vStackContainer.arrangedSubviews.firstIndex(of: hStackUserInfo) {
            self.vStackContainer.insertArrangedSubview(photoImageView, at: index + 1)
            photoImageView.snp.makeConstraints { make in
                make.width.equalToSuperview().offset(-30)
                make.height.equalTo(photoImageView.snp.width).multipliedBy(0.75)
                //make.height.equalTo(200)
            }
        }
        
        // MARK: - isSkeletonable
        contentView.isSkeletonable = true
        //viewCard.isSkeletonable = true
        vStackContainer.isSkeletonable = true
        hStackUserInfo.isSkeletonable = true
        viewContainAvatar.isSkeletonable = true
        avatarImageView.isSkeletonable = true
        viewLabels.isSkeletonable = true
        vStackLabels.isSkeletonable = true
        titleLabel.isSkeletonable = true
        subTitleLabel.isSkeletonable = true
        viewText.isSkeletonable = true
        contentTextView.isSkeletonable = true
        hStackButtons.isSkeletonable = true
        updateFavoriteButton.isSkeletonable = true
        selectButton.isSkeletonable = true
        topSeparatorView.isSkeletonable = true
        bottomSeparatorView.isSkeletonable = true
        photoImageView.isSkeletonable = true
        
    }
    
    private func showAnimate() {
        [contentView].forEach {
            $0.showGradientSkeleton(usingGradient: .init(baseColor: .lightGray ) , transition: .crossDissolve(0.25))
        }
    }
    
}
