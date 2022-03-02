//
//  SearchBarTxt.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

import UIKit

class SearchBarTxt: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 10)
    let icon    = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        icon.image = UIImage(systemName: "magnifyingglass.circle")?.withRenderingMode(.alwaysOriginal)
        icon.contentMode = .scaleAspectFill
        addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(15)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
