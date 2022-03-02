//
//  HeaderFooterSection.swift
//  InitBaseProject
//
//  Created by Nguyen Hong Nhan on 15/11/2021.
//

import UIKit

class HeaderFooterSection: UITableViewHeaderFooterView {
    
    let viewCard: UIView = {
        let view = UIView()
        view.backgroundColor = DebugColor.view.associatedColor
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.linesCornerRadius = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
                
        setupView()
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
        
        viewCard.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        titleLabel.backgroundColor = DebugColor.view.associatedColor
    }
    
}
