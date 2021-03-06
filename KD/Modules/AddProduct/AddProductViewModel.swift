//
//  AddProductViewModel.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

import Foundation
import Combine

final class AddProductViewModel {
    
    //MARK: - Properties
    // Publisher & store
    @Published var sku: String?
    @Published var productName: String?
    @Published var qlt: String?
    @Published var price: String?
    @Published var unit: String?
    @Published var isLoading: Bool = false
    
    // Model
    
    // State
    enum State {
        case initial
        case error(message: String)
        case addSuccess
    }
    
    // Action
    enum Action {
        case clear
        case addProduct
    }
    
    // Actions
    let action = PassthroughSubject<Action, Never>()
    
    // State
    let state = CurrentValueSubject<State, Never>(.initial)
    
    // Subscriptions
    var subscriptions = [AnyCancellable]()
    var dataCancellable = [AnyCancellable]()
    
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
    
    
    // process Action
    private func processAction(_ action: Action) {
        
        switch action {
        case .clear:
            self.clear()
            
        case .addProduct:
            print("ViewModel -> View")
            
            self.addProduct()
            
        }
    }
    
    // process State
    private func processState(_ state: State) {
        
        switch state {
        case .initial:
            sku = ""
            productName = ""
            qlt = ""
            price = ""
            unit = ""
            
        case .error(let message):
            print("Error: \(message)")
            
        case .addSuccess:
            print("addSuccess")
        }
    }
    // MARK: - Availables
    private var availableSku: AnyPublisher<String?, Never> {
        return $sku
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { username in
                return Future { promise in
                    // way 1:
                    ValidationService.availableDataInput(username ?? "") { available in
                        promise(.success(available ? username : nil))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var availableProductName: AnyPublisher<String?, Never> {
        return $productName
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { username in
                return Future { promise in
                    // way 1:
                    ValidationService.availableDataInput(username ?? "") { available in
                        promise(.success(available ? username : nil))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    var triggerEnableButton: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(availableSku, availableProductName)
            .receive(on: RunLoop.main)
            .map { sku, productName in
                guard let _ = sku, let _ = productName else { return false }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    
    
    //MARK: - Private property
    private let dispathGroup = DispatchGroup()
    
    private func clear() {
        sku = ""
        productName = ""
    }
    
    
    //MARK: - Call Api
    
    private func addProduct() {
        dataCancellable = []
        DLog("sku", sku)

        let addInfo = AddProductInfo(sku: sku ?? "", product_name: productName ?? "", qty: Int(qlt!) ?? 0, price: Double(price!) ?? 0, unit: unit ?? "1", status: 1)

        let postPublisher = try? API.Product.postAddProduct(productInfo: addInfo)

        _ = postPublisher?
            .sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                print("DONE - postAddProduct")
            }
        }, receiveValue: { (data, response) in
            if let string = String(data: data, encoding: .utf8) {
                print(string)
                do {
                    let decoder = JSONDecoder()
                    let productModel = try decoder.decode(ProductModel.self, from: data)
                    self.state.send(.addSuccess)
                    
                } catch {
                    print(error)
                    self.state.send(.error(message: string))
                }
            }
        })
            .store(in: &dataCancellable)
        
    }
}
