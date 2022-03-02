//
//  SkeletonHeaderFooterSection.swift
//  InitBaseProject
//
//  Created by Nguyen Hong Nhan on 15/11/2021.
//

import UIKit

class SkeletonHeaderFooterSection: UITableViewHeaderFooterView {
    
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
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
                
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    
    private func setupView() {
        self.backgroundColor = .white
         
        contentView.addSubview(viewCard)
        viewCard.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
        
        viewCard.addSubview(vStackContainer)
        vStackContainer.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        // MARK: - topSeparatorView
        let topSeparatorView = UIView()
        topSeparatorView.backgroundColor = .lightGray
        vStackContainer.addArrangedSubview(topSeparatorView)
        topSeparatorView.snp.makeConstraints { make in
            make.height.equalTo(50.0)
            make.left.right.equalTo(0)
        }
        
        
        contentView.isSkeletonable = true
        viewCard.isSkeletonable = true
        topSeparatorView.isSkeletonable = true
    }
    
    private func showAnimate() {
        [contentView].forEach {
            $0.showGradientSkeleton(usingGradient: .init(baseColor: .lightGray ) , transition: .crossDissolve(0.25))
        }
    }
}
