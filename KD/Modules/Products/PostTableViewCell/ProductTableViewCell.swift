//
//  ProductTableViewCell.swift
//  Demo-Combine
//
//  Created by Nguyen Hong Nhan on 30/12/2021.
//

import UIKit
import SnapKit


private let regularConfig = UIImage.SymbolConfiguration(weight: .regular)
private let semiBoldConfig = UIImage.SymbolConfiguration(weight: .semibold)

protocol ProductTableViewCellDelegate: AnyObject {
    func onSelectButtonTapped(dataModel: UserModel, index: Int)
    func onDeleteButtonTapped(dataModel: UserModel, index: Int)
}

class ProductTableViewCell: UITableViewCell {
    
    weak var delegate: ProductTableViewCellDelegate?

    
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
        
    let selectButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitle("Edit", for: .normal)
        button.imageEdgeInsets.left = -6
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "arrow.right", withConfiguration: regularConfig), for: .normal)
            button.setImage(UIImage(systemName: "arrow.right", withConfiguration: semiBoldConfig), for: .selected)
        } else {
            // Fallback on earlier versions
        }
        
        button.addTarget(self, action: #selector(selectButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitle("Delete", for: .normal)
        button.imageEdgeInsets.left = -6
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "trash.circle", withConfiguration: regularConfig), for: .normal)
            button.setImage(UIImage(systemName: "trash.circle.fill", withConfiguration: semiBoldConfig), for: .selected)
        } else {
            // Fallback on earlier versions
        }
        
        button.addTarget(self, action: #selector(deleteButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - didSet DataModel
    var index: Int? = nil
    var dataModel: UserModel? {
        didSet{
            
//            print("Called after setting the new value")
            guard let dataModel = dataModel else {
                return
            }
            titleLabel.text = "Index \(dataModel.id)"
            subTitleLabel.text =  dataModel.name
        }
        willSet(myNewValue) {

//            print("Called before setting the new value")
            titleLabel.text = ""
            subTitleLabel.text = ""
        }
    }
    
    
    // MARK: - Init
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clearData()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .white
        
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
        
        viewCard.addSubview(vStackContainer)
        vStackContainer.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        // MARK: - topSeparatorView
        let topSeparatorView = UIView()
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

        let viewLabels = UIView()
        hStackUserInfo.addArrangedSubview(viewLabels)
        viewLabels.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0).priority(.high)
        }

        let vStackLabels: UIStackView = {
            let vStack = UIStackView()
            vStack.axis = .vertical
            vStack.alignment = .leading
            vStack.distribution = .fill
            vStack.translatesAutoresizingMaskIntoConstraints = false
            vStack.spacing = 3
            return vStack
        }()

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

        // MARK: - viewPhoto

        // MARK: - hStackButtons
        let hStackButtons: UIStackView = {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.alignment = .center
            hStack.distribution = .fillEqually
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.spacing = 1
            return hStack
        }()
        vStackContainer.addArrangedSubview(hStackButtons)
        hStackButtons.snp.makeConstraints { make in
            make.left.right.equalTo(0)
        }

        hStackButtons.addArrangedSubview(selectButton)
        selectButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.bottom.equalTo(0)
        }

        hStackButtons.addArrangedSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.bottom.equalTo(0)
        }
        
        // MARK: - bottomSeparatorView
        let bottomSeparatorView = UIView()
        bottomSeparatorView.backgroundColor = .lightGray
        vStackContainer.addArrangedSubview(bottomSeparatorView)
        bottomSeparatorView.snp.makeConstraints { make in
            make.height.equalTo(8.0)
            make.left.right.equalTo(0)
        }
        // end
        
    }
    
    // MARK: - Setup Data
    
    private func clearData() {
        titleLabel.text = ""
        subTitleLabel.text = ""
    }
    
    public func setupData(data: UserModel, index: Int) {
        self.dataModel =  data
        self.index = index
    }
    
    // MARK: - Actions
    
    @objc func selectButtonTapped(sender: UIButton) {
        guard let data = self.dataModel, let index = self.index else { return }
        delegate?.onSelectButtonTapped(dataModel: data, index: index)
    }
    
    @objc func deleteButtonTapped(sender: UIButton) {
        guard let data = self.dataModel, let index = self.index else { return }
        delegate?.onDeleteButtonTapped(dataModel: data, index: index)
    }
    
    
}
