//
//  ProductsViewController.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

import UIKit
import ESPullToRefresh
import SkeletonView
import Combine

class ProductsViewController: BaseViewController {
    
    private var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
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
    
    let hStackButtons: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .trailing
        hStack.distribution = .fillEqually
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = 1
        return hStack
    }()
    let gotoSignUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(gotoSignUpButtonTapped(sender:)), for: .touchUpInside)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    let gotoLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(gotoLoginButtonTapped(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    let gotoLogoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(gotoLogoutButtonTapped(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    let hStackAdding: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .trailing
        hStack.distribution = .fillProportionally
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = 5
        return hStack
    }()
    
    let searchBar: SearchBarTxt = {
        let searchBar = SearchBarTxt()
        searchBar.placeholder = NSLocalizedString("Search By SKU", comment: "")
        searchBar.backgroundColor = .white
        searchBar.textColor = .black
        searchBar.layer.cornerRadius = 20
        searchBar.returnKeyType = .search
        searchBar.setShadow()
        return searchBar
    }()
    
    let gotoAddProductButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.setTitle("Add Product", for: .normal)
        button.addTarget(self, action: #selector(gotoAddProductButtonTapped(sender:)), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10.0
        return button
    }()


    
    
    private let tableView       = UITableView()
    // MARK: - Properties
    let viewModel = ProductsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _NavController.setNavigationBarHidden(false, animated: true)
        
        viewModel.action.send(.onAppear)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData() // if cell layout error
        // disable scroll when show skeleton
        tableView.isScrollEnabled = (viewModel.dataLoaded == false) ? false : true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
    }
    
    // MARK: Private Helper Methods
    
    private func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            //self.viewModel.onRefreshData()
            self.viewModel.action.send(.onRefreshData)
        }
        
    }
    
    private func loadMoreData() {
        if viewModel.isNoMoreData == false {
            viewModel.action.send(.onLoadMoreData)
        } else {
            self.tableView.es.noticeNoMoreData()
        }
    }
    
    //MARK: - Config View
    override func setupData() {
        super.setupData()
        
        viewModel.action.send(.onRefreshData)
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.edgesForExtendedLayout = []
        view.backgroundColor = .white
        
        title = "Products"
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.left.right.equalToSuperview()
            //make.height.equalTo(50)
        }
        
        headerView.addSubview(vStackContainer)
        vStackContainer.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
        
        
        // hStask: contain button register/login
        // MARK: - hStackButtons
        
        vStackContainer.addArrangedSubview(hStackButtons)
        hStackButtons.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalTo(40)
        }

        hStackButtons.addArrangedSubview(gotoSignUpButton)
        gotoSignUpButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
        }

        hStackButtons.addArrangedSubview(gotoLoginButton)
        gotoLoginButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
        }
        
        hStackButtons.addArrangedSubview(gotoLogoutButton)
        gotoLogoutButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
        }
        
        
        // adding & search
        vStackContainer.addArrangedSubview(hStackAdding)
        hStackAdding.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.height.equalTo(40)
        }
        
        hStackAdding.addArrangedSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
        }
        searchBar.delegate = self

        hStackAdding.addArrangedSubview(gotoAddProductButton)
        gotoAddProductButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.width.equalTo(150)
        }
        
        setupTableView()
    }
    
    private func setupUILoggedIn() {
        self.gotoLoginButton.isHidden = true
        self.gotoSignUpButton.isHidden = true
        self.gotoLogoutButton.isHidden = false
        self.gotoAddProductButton.alpha = 1.0
        self.gotoAddProductButton.isUserInteractionEnabled = true
    }
    
    private func setupUILogout() {
        self.gotoLoginButton.isHidden = false
        self.gotoSignUpButton.isHidden = false
        self.gotoLogoutButton.isHidden = true
        self.gotoAddProductButton.alpha = 0.5
        self.gotoAddProductButton.isUserInteractionEnabled = false
    }
    
    //MARK: Binding
    override func bindingToView() {
        
        viewModel.$listModels
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [unowned self] values in
                print("receiver values = ", values.count)
                print("table reload with ", viewModel.listModels.count)

                self.tableView.reloadData()
            }
            .store(in: &subscriptions)
        
        // show/hide loading
        viewModel.$isLoading
            .sink(receiveValue: { isLoading in
                if isLoading {
                    self.showLoading()
                } else {
                    self.hideLoading()
                }
            })
            .store(in: &subscriptions)
        
        viewModel.$isLoggedIn
            .sink(receiveValue: { isLoggedIn in
                if isLoggedIn {
                    self.setupUILoggedIn()
                } else {
                    self.setupUILogout()
                }
            })
            .store(in: &subscriptions)
    }
    
    override func bindingToViewModel() {
        
    }
    
    //MARK: - Navigation
    override func router() {
        viewModel.state
            .sink { [weak self] state in
                
                switch state {
                case .error(let message):
                    self?.showAlert(imageName: nil, title: "Alert", message: message, positiveTitleButton: nil, positiveCompletion: nil)
                    
                case .didRefreshDataSuccess:
                    self?.didRefreshDataSuccess()
                    
                case .didLoadMoreDataSuccess:
                    self?.didLoadMoreDataSuccess()
                    
                case .didUpdateDataSuccess(let dataModel, let atIndex):
                    self?.didUpdateDataSuccess(dataModel: dataModel, atIndex: atIndex)
                    
                default:
                    break
                }
            }.store(in: &subscriptions)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.separatorStyle = .none
        //tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 0
        tableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: "SkeletonTableViewCell")
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview()
        }
        
        
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
//        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
//        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        self.tableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refreshData()
        }
//        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
//            self?.loadMoreData()
//        }
//        self.tableView.refreshIdentifier = "UsersIndentifier"
//        self.tableView.expiredTimeInterval = 20.0
        
        // TODO: - sample start to get data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            //self.tableView.es.autoPullToRefresh()
        }
        
        tableView.isSkeletonable = true
    }
    
    private func didDeleteCellAtIndex(index: Int) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .fade)
            self.tableView.endUpdates()
            
            self.tableView.reloadData()
            if self.viewModel.listModels.count == 0 {
                self.tableView.showNoResultView()
            } else {
                self.tableView.restoreNoResultView()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func gotoSignUpButtonTapped(sender: UIButton) {
        let viewController = SignUpViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
      
    }
    
    @objc private func gotoLoginButtonTapped(sender: UIButton) {
        let viewController = LoginViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func gotoLogoutButtonTapped(sender: UIButton) {
        
        viewModel.action.send(.onLogout)
        
    }
    
    @objc private func gotoAddProductButtonTapped(sender: UIButton) {
        let viewController = AddProductViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}


extension ProductsViewController {
    func didRefreshDataSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 , execute: {
            self.tableView.es.stopPullToRefresh()
            //self.tableView.reloadData()
            self.tableView.isScrollEnabled = true
            
            //self.viewModel.arrayModels.removeAll()
            if self.viewModel.listModels.count == 0 {
                self.tableView.showNoResultView()
            } else {
                self.tableView.restoreNoResultView()
            }
        })
    }
    
    func didLoadMoreDataSuccess() {
        DispatchQueue.main.async {
            self.tableView.es.stopLoadingMore()
            //self.tableView.reloadData()
            self.tableView.isScrollEnabled = true
        }
    }
    
    func didUpdateDataSuccess(dataModel: ProductModel, atIndex: Int) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath.init(row: atIndex, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
}

//MARK: - ProductTableViewCellDelegate
extension ProductsViewController: ProductTableViewCellDelegate {
    
    func onSelectButtonTapped(dataModel: ProductModel, index: Int) {
        print("onSelectButtonTapped")
        
        let viewController = EditProductViewController(dataModel: dataModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func onDeleteButtonTapped(dataModel: ProductModel, index: Int) {
        viewModel.action.send(.onDelete(dataModel: dataModel, atIndex: index))
    }
}

// MARK: - SkeletonTableViewDataSource, SkeletonTableViewDelegate
extension ProductsViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.dataLoaded == true {
            return viewModel.numberOfRows(in: section)
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.dataLoaded {
            guard 0..<(self.viewModel.listModels.count) ~= indexPath.row else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath as IndexPath)
                return cell
            }
            
            //let cellData = listModels[indexPath.row]
            let cellData = self.viewModel.productCellViewModel(at: indexPath).product
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
            cell.setupData(data: cellData, index: indexPath.row)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkeletonTableViewCell", for: indexPath) as! SkeletonTableViewCell
            return cell
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SkeletonTableViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }

    func collectionSkeletonView(_ skeletonView: UITableView, prepareCellForSkeleton cell: UITableViewCell, at indexPath: IndexPath) {
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        if viewModel.dataLoaded {
            return "HeaderIdentifier"
        } else {
            return "SkeletonHeaderFooterSection"
        }
    }

    // MARK: - Footer section
    // not work because using loadmore footer
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForFooterInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        if viewModel.dataLoaded {
            return "FooterIdentifier"
        } else {
            return nil
        }
    }

}

////MARK: - DetailViewModelOutput
//extension ProductsViewController: DetailViewControllerDelegate {
//    func onUpdateFavoriteButtonTapped(dataModel: BasicModel) {
//        print("onUpdateFavoriteButtonTapped")
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//
//    func onDeleteButtonTapped(dataModel: BasicModel) {
//        if let index = viewModel.listModels.firstIndex(where: {$0 === dataModel}) {
//            viewModel.listModels.remove(at: index)
//            //self.didDeleteCellAtIndex(index: index)
//        }
//    }
//}

extension ProductsViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let searchText:String = textField.text ?? ""
        Debounce<String>.input(searchText, comparedAgainst: self.searchBar.text ?? "") {_ in
//            self.interactor.searchListFriend(searchText)
        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        let searchText:String = textField.text ?? ""
        Debounce<String>.input(searchText, comparedAgainst: self.searchBar.text ?? "") {_ in
//            self.interactor.searchListFriend(searchText)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let searchText:String = textField.text ?? ""
        Debounce<String>.input(searchText, comparedAgainst: self.searchBar.text ?? "") {_ in
//            self.interactor.searchListFriend(searchText)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText:String = textField.text ?? ""
        Debounce<String>.input(searchText, comparedAgainst: self.searchBar.text ?? "") {_ in
//            self.interactor.searchListFriend(searchText)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let searchText:String = ""
        self.searchBar.text = ""
        Debounce<String>.input(searchText, comparedAgainst: self.searchBar.text ?? "") {_ in
//            self.interactor.searchListFriend(searchText)
        }
        return false
    }
}
