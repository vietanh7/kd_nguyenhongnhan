//
//  PhotoTableViewCell.swift
//  InitBaseProject
//
//  Created by Nguyen Hong Nhan on 29/10/2021.
//

import UIKit

protocol PhotoTableViewCellDelegate: RegularTableViewCellDelegate {
    func onPhotoImageViewTapped(dataModel: BasicModel, index: Int)
}
class PhotoTableViewCell: RegularTableViewCell {

    weak var photoCellDelegate: PhotoTableViewCellDelegate?

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .white
        
        setupViewPhoto()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    
    private func setupViewPhoto() {
        if let index = self.vStackContainer.arrangedSubviews.firstIndex(of: hStackUserInfo) {
            self.vStackContainer.insertArrangedSubview(photoImageView, at: index + 1)
            photoImageView.snp.makeConstraints { make in
                make.width.equalToSuperview().offset(-30)
                make.height.equalTo(photoImageView.snp.width).multipliedBy(0.75)
                //make.height.equalTo(200)
            }
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(photoImageViewTapped(sender:)))
            photoImageView.addGestureRecognizer(tapGR)
            photoImageView.isUserInteractionEnabled = true
        }
    }
        
    public func setupDataPhoto(data: BasicModel, index: Int) {
        self.setupData(data: data, index: index)
        
        photoImageView.sd_setImage(with: URL(string: self.dataModel?.photoUrl ?? ""), placeholderImage: nil)
    }
    
    // MARK: - Actions
    
    @objc override func selectButtonTapped(sender: UIButton) {
        guard let data = self.dataModel, let index = self.index else { return }
        photoCellDelegate?.onSelectButtonTapped(dataModel: data, index: index)
    }
    
    @objc override func updateFavoriteButtonTapped(sender: UIButton) {
        guard let data = self.dataModel, let index = self.index else { return }
        photoCellDelegate?.onUpdateFavoriteButtonTapped(dataModel: data, index: index)
    }
    
    @objc override func avatarImageViewTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let data = self.dataModel, let index = self.index else { return }
            photoCellDelegate?.onAvatarImageViewTapped(dataModel: data, index: index)
        }
    }
    
    @objc func photoImageViewTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let data = self.dataModel, let index = self.index else { return }
            photoCellDelegate?.onPhotoImageViewTapped(dataModel: data, index: index)
        }
    }

}
