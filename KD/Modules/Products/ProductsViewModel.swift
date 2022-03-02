//
//  ProductsViewModel.swift.swift
//  InitBaseProject
//
//  Created by Nguyen Hong Nhan on 28/10/2021.
//

import Foundation
import Combine

//protocol BasicTableViewViewModelOutput: BaseViewModelOutput {
//    func didRefreshDataSuccess()
//    func didLoadMoreDataSuccess()
//    func didUpdateDataSuccess(dataModel: UserModel, atIndex: Int)
//}

private let Limit = 5



final class ProductsViewModel {
    //    weak var delegate: BasicTableViewViewModelOutput?
    
    //MARK: - Define
    enum FetchDataType {
        case refreshData
        case loadMoreData
    }
    
    // State
    enum State {
        case initial
        case error(message: String)
        case didRefreshDataSuccess
        case didLoadMoreDataSuccess
        case didUpdateDataSuccess(dataModel: UserModel, atIndex: Int)
        
    }
    
    // Action
    enum Action {
        case onRefreshData
        case onLoadMoreData
        case onUpdateFavorite(dataModel: UserModel, atIndex: Int)
    }
    
    
    //MARK: - Properties
    // Publisher & store
    @Published var listModels: [UserModel] = []
    @Published var isLoading: Bool = false
    
    // Actions
    let action = PassthroughSubject<Action, Never>()
    
    // State
    let state = CurrentValueSubject<State, Never>(.initial)
    
    // Subscriptions
    var subscriptions = [AnyCancellable]()
    var dataCancellable = [AnyCancellable]()
    
    //MARK: - Init
    init() {
        // state
        state
            .sink { [weak self] state in
                self?.processState(state)
            }.store(in: &subscriptions)
        
        // action
        action
            .sink { [weak self] action in
                self?.processAction(action)
            }.store(in: &subscriptions)
    }
    
    //MARK: - Private functions
    // process Action
    private func processAction(_ action: Action) {
        switch action {
        case .onRefreshData:
            print("ViewModel -> View")
            self.onRefreshData()
            
        case .onLoadMoreData:
            print("ViewModel -> View")
            self.onLoadMoreData()
            
        case .onUpdateFavorite(let dataModel, let index):
            print("ViewModel -> View")
            self.onUpdateFavorite(dataModel: dataModel, atIndex: index)
            
        }
    }
    
    // process State
    private func processState(_ state: State) {
        switch state {
        case .initial:
            print("ViewModel -> State: initial")
            isLoading = false
            
        case .error(message: _):
            print("ViewModel -> State: error")
            
        case .didRefreshDataSuccess:
            print("ViewModel -> State: didRefreshDataSuccess")
            
        case .didLoadMoreDataSuccess:
            print("ViewModel -> State: didLoadMoreDataSuccess")
            
        case .didUpdateDataSuccess(dataModel: _, atIndex: _):
            print("ViewModel -> State: didUpdateDataSuccess")
        }
    }
    
    
    // Properties
    private var offset = 0
    private var limit = Limit
    var isNoMoreData = false
    var dataLoaded = false
    
    private func onRefreshData() {
        self.getListData(offset: 0, limit: self.limit, fetchDataType: .refreshData)
    }
    
    private func onLoadMoreData() {
        self.getListData(offset: self.offset, limit: self.limit, fetchDataType: .loadMoreData)
    }
    
    
    private func onUpdateFavorite(dataModel: UserModel, atIndex: Int) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.15) { [weak self] in
            guard let self = self else { return }
            dataModel.isFavorite = !(dataModel.isFavorite ?? false)
            
            //self.delegate?.didUpdateDataSuccess(dataModel: dataModel, atIndex: atIndex)
            self.state.send(.didUpdateDataSuccess(dataModel: dataModel, atIndex: atIndex))
        }
    }
    
    
    private func getListData(offset: Int, limit: Int, fetchDataType: FetchDataType) {
        dataCancellable = []
        API.getListObject(endPoint: API.User.EndPoint.users(offset: offset, limit: limit).urlString, type: UserModel.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                    
                    //self.delegate?.didGetErrorMessage?(errorMessage: err.localizedDescription)
                    
                    let mess = err.localizedDescription
                    self.state.send(.error(message: mess))
                    
                case .finished:
                    print("Finished")
                    
                }
            } receiveValue: {  [weak self] models in
                guard let self = self else { return }
                
                self.isNoMoreData = models.isEmpty ? true : false
                
                let results = models.map({ (user) -> UserModel in
                    user.avatarUrl = "https://picsum.photos/200?index=\(user.id)"
                    return user
                })
                
                // reload UI
                self.dataLoaded = true
                if fetchDataType == .refreshData {
                    self.listModels = results
                    //self.delegate?.didRefreshDataSuccess()
                    
                    self.state.send(.didRefreshDataSuccess)
                } else {
                    self.listModels.append(contentsOf: results)
                    
                    //self.delegate?.didLoadMoreDataSuccess()
                    self.state.send(.didLoadMoreDataSuccess)
                }
                
                // MUST set value for offset here b/c after that the list maybe delete item
                self.offset = self.listModels.count
                
                //let data = try! JSONEncoder().encode(self.listModels[0])
                //print(String(data: data, encoding: .utf8)!)
            }
            .store(in: &dataCancellable)
        
    }
}

//MARK: - TableView
extension ProductsViewModel {
    func numberOfRows(in section: Int) -> Int {
        self.listModels.count
    }
    
    func productCellViewModel(at indexPath: IndexPath) -> ProductCellViewModel {
        ProductCellViewModel(product: self.listModels[indexPath.row])
    }
    
}
