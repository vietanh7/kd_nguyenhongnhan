//
//  ProductsViewModel.swift.swift
//  InitBaseProject
//
//  Created by Nguyen Hong Nhan on 28/10/2021.
//

import Foundation
import Combine

private let Limit = 5

final class ProductsViewModel {
    
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
        case didUpdateDataSuccess(dataModel: ProductModel, atIndex: Int)
        
    }
    
    // Action
    enum Action {
        case onAppear
        case onRefreshData
        case onLoadMoreData
        case onUpdateFavorite(dataModel: ProductModel, atIndex: Int)
        case onLogout
    }
    
    
    //MARK: - Properties
    // Publisher & store
    @Published var listModels: [ProductModel] = []
    @Published var isLoading: Bool = false
    
    @Published var isLoggedIn: Bool = false
    
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
        case .onAppear:
            onAppear()
            
        case .onRefreshData:
            print("ViewModel -> View")
            self.onRefreshData()
            
        case .onLoadMoreData:
            print("ViewModel -> View")
            //self.onLoadMoreData()
            
        case .onUpdateFavorite(let dataModel, let index):
            print("ViewModel -> View")
            self.onUpdateFavorite(dataModel: dataModel, atIndex: index)
            
        case .onLogout:
            self.onLogout()
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
    
    private func onLogout() {
        UserDefaultsHelper.signOut()
        self.isLoggedIn = false
    }
    
    private func onAppear() {
        if UserDefaultsHelper.isLoggedIn() {
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }
    }
    
    private func onRefreshData() {
        self.getListData()
    }
    
    
    private func onUpdateFavorite(dataModel: ProductModel, atIndex: Int) {
//        DispatchQueue.global().asyncAfter(deadline: .now()+0.15) { [weak self] in
//            guard let self = self else { return }
//            dataModel.isFavorite = !(dataModel.isFavorite ?? false)
//
//            self.state.send(.didUpdateDataSuccess(dataModel: dataModel, atIndex: atIndex))
//        }
    }
    
    
    private func getListData() {
        dataCancellable = []

        let getProductPublisher = try? API.Product.getProducts()

        _ = getProductPublisher?
            .sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                print("DONE - getProductPublisher")
            }
        }, receiveValue: { (data, response) in
            if let string = String(data: data, encoding: .utf8) {
                print(string)
                do {
                    let decoder = JSONDecoder()
                    let models = try decoder.decode([ProductModel].self, from: data)
                    
                    DLog("count", models.count)
                    
                    self.listModels = models
                    
                    self.isNoMoreData = models.isEmpty ? true : false
                    
                    // reload UI
                    self.dataLoaded = true
                    self.listModels = models

                    self.state.send(.didRefreshDataSuccess)

                } catch {
                    print(error)
                    self.state.send(.error(message: error.localizedDescription))
                }
            }
        })
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
