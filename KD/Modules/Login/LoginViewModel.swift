//
//  LoginViewModel.swift
//  BookF
//
//  Created by Nguyen Hong Nhan on 28/08/2021.
//

import Foundation
import Combine

final class LoginViewModel {
    
    //MARK: - Properties
    // Publisher & store
    @Published var username: String?
    @Published var password: String?
    @Published var isLoading: Bool = false
    
    // Model
    
    // State
    enum State {
        case initial
        case error(message: String)
        case gotoHome
        case forgotPassword
        case didGetResultConfirmSignInWithSMSMFACode
        case didGetResultConfirmSignUp
    }
    
    // Action
    enum Action {
        case clear
        case login
        case gotoForgotPassword
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
            self.clear()
            
        case .login:
            print("ViewModel -> View")
            
            self.validateDataInput()
                .sink { completion in
                    switch completion {
                    case .failure(let err):
                        print("Error is \(err.localizedDescription)")
                        
                        let mess = err.localizedDescription
                        self.state.send(.error(message: mess))
                        
                    case .finished:
                        print("Finished")
                    }
                    
                } receiveValue: { (username, password) in
                    self.signIn()
                }
                .store(in: &subscriptions)

        
        case .gotoForgotPassword:
            state.send(.forgotPassword)
            
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
                        
        case .gotoHome:
            print("LOGINED")
            
        case .forgotPassword:
            print("Forgot password")
            
        case .didGetResultConfirmSignInWithSMSMFACode:
            print("didGetResultConfirmSignInWithSMSMFACode")
            
        case .didGetResultConfirmSignUp:
            print("didGetResultConfirmSignUp")
            
        }
    }
    // MARK: - Availables
    private var availableUsername: AnyPublisher<String?, Never> {
        return $username
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { username in
                return Future { promise in
                    // way 1:
                    ValidationService.availableDataInput(username ?? "") { available in
                        promise(.success(available ? username : nil))
                    }
                    
                    // way 2:
//                    if let uname = username, uname.count>0 {
//                        promise(.success(username))
//                    } else {
//                        promise(.success(nil))
//                    }
                    
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var availablePassword: AnyPublisher<String?, Never> {
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
    
    var triggerEnableButton: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(availableUsername, availablePassword)
            .receive(on: RunLoop.main)
            .map { username, password in
                guard let _ = username, let _ = password else { return false }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Validated
    private var validatedUsername: AnyPublisher<String?, Error> {
        return Future { promise in
            do {
                let email = try ValidationService.validateEmail(self.username?.trim())
                print("valid email =", email)
                            
                promise(.success(email))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
            
    }
    
    private var validatedPassword: AnyPublisher<String?, Error> {
        return Future { promise in
            do {
                let password = try ValidationService.validatePassword(self.password?.trim() ?? "")

                promise(.success(password))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    //MARK: - Private property
    private let dispathGroup = DispatchGroup()
    
    private func clear() {
        username = ""
        password = ""
    }
    
    func validateDataInput() -> Future<(String, String), Error> {
        return Future<(String, String), Error> { [weak self] promise in
            do {
                let email = try ValidationService.validateEmail(self?.username?.trim())
                print("valid email =", email)
                
                let password = try ValidationService.validatePassword(self?.password?.trim() ?? "")
                print("valid password =", password)
                
                promise(.success((email, password)))
            } catch {
                print("_error=", error.localizedDescription)
                promise(.failure(error))
            }
        }
    }
    
    
    //MARK: - Call Api
    private func signIn() {
        // TODO: - call api login
        DLog("call api login")
        DLog("username", username)
        DLog("password", password)
    }
    
    
    
}
