//
//  SignUpViewModel.swift
//  DemoApp
//
//  Created by Nguyen Hong Nhan on 24/11/2021.
//

import UIKit
import Combine

final class SignUpViewModel {
        
    //MARK: - Properties
    // Publisher & store
    @Published var username: String?
    @Published var password: String?
    @Published var isLoading: Bool = false
    
    // State
    enum State {
        case initial
        case error(message: String)
        case didSignUpSuccess
    }
    
    // Action
    enum Action {
        case clear
        case signUp
    }
    
    // Actions
    let action = PassthroughSubject<Action, Never>()
    
    // State
    let state = CurrentValueSubject<State, Never>(.initial)
    
    // Subscriptions
    var subscriptions = [AnyCancellable]()
    
    
    init(username: String, password: String) {
                
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
            username = ""
            password = ""
            
        case .signUp:
            print("ViewModel -> View")
            self.signUp()

        }
    }
    
    // process State
    private func processState(_ state: State) {
        switch state {
        case .initial:
            username = ""
            password = ""
            
        case .error(let message):
            print("Error: \(message)")
                        
        case .didSignUpSuccess:
            print("SignUp Success")
            
        }
    }
    
    // Step 2: Define our validation streams
    var validatedUsername: AnyPublisher<String?, Never> {
        return $username
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { username in
                return Future { promise in
                    ValidationService.availableDataInput(username ?? "") { available in
                        promise(.success(available ?  username : nil))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    var validatedPassword: AnyPublisher<String?, Never> {
        return $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { password in
                return Future { promise in
                    ValidationService.availableDataInput(password ?? "") { available in
                        promise(.success(available ? password : nil))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    var isEnableButton: AnyPublisher<(String, String)?, Never> {
        return Publishers.CombineLatest(validatedUsername, validatedPassword)
            .receive(on: RunLoop.main)
            .map { username, password in
                guard let uname = username, let pwd = password else { return nil }
                return (uname, pwd)
            }
            .eraseToAnyPublisher()
    }
    
    
    //MARK: - Private property
    private var phoneNumberFormmatted: String?
    
    
    func onValidateDataInput() -> Bool {
        do {
            let email = try ValidationService.validateEmail(self.username?.trim())
            print("valid email =", email)
            
            let password = try ValidationService.validatePassword(password)
            print("valid password =", password)
            
            return true
        } catch {
            print("_error=", error.localizedDescription)
            
            let mess = error.localizedDescription
            self.state.send(.error(message: mess))
            return false
        }
    }
    
    func signUp() {
        // TODO: - call api signup
        DLog("call api signup")
        DLog("username", username)
        DLog("password", password)
    }

}




