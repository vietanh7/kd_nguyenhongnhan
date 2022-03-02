//
//  UITableView_EXT.swift
//  Gratitapp
//
//  Created by Nguyen Hong Nhan on 5/24/21.
//

import UIKit

extension UITableView {
    
    func showNoResultView(iconName: String? = nil, title: String? = nil, message: String? = nil) {
        let imgName = iconName ?? "outline_data_array_black_48pt"
        let title = title ?? "title"
        let message = message ?? "message"
        let contentView = UIView(frame:  CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        let noResultView = NoResultView(imageName: imgName, title: title, message: message)
        
        contentView.addSubview(noResultView)
        noResultView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        self.backgroundView = contentView
        self.separatorStyle = .none
    }
    
    func restoreNoResultView() {
        self.backgroundView = nil
    }
    
    func scroll(to: scrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    
    enum scrollsTo {
        case top,bottom
    }
    
    func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }
}

extension UICollectionView {
    func showNoResultView(iconName: String? = nil, title: String? = nil, message: String? = nil) {
        let imgName = iconName ?? "outline_data_array_black_48pt"
        let title = title ?? "title"
        let message = message ?? "message"
        let contentView = UIView(frame:  CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        let noResultView = NoResultView(imageName: imgName, title: title, message: message)
        
        contentView.addSubview(noResultView)
        noResultView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        self.backgroundView = contentView
        //self.separatorStyle = .none
    }
    
    func restoreNoResultView() {
        self.backgroundView = nil
    }
}
