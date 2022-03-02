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
        case loginSuccess
    }
    
    // Action
    enum Action {
        case clear
        case login
    }
    
    // Actions
    let action = PassthroughSubject<Action, Never>()
    
    // State
    let state = CurrentValueSubject<State, Never>(.initial)
    
    // Subscriptions
    var subscriptions = [AnyCancellable]()
    var dataCancellable = [AnyCancellable]()
    
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
            
        case .loginSuccess:
            print("loginSuccess")
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
        dataCancellable = []
        DLog("username", username)
        DLog("password", password)

        let loginInfo = LoginInfo(email: username ?? "", password: password ?? "")

        let postUserPublisher = try? postUserLogin(user: loginInfo)

        _ = postUserPublisher?
            .sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                print("DONE - postUserPublisher")
            }
        }, receiveValue: { (data, response) in
            if let string = String(data: data, encoding: .utf8) {
                print(string)
                do {
                    let decoder = JSONDecoder()
                    let responeModel = try decoder.decode(ResponseModel.self, from: data)
                    print("token", responeModel.token ?? "")
                    if let token = responeModel.token {
                        self.state.send(.loginSuccess)
                        UserDefaultsHelper.setData(value: token, key: .token)
                    } else {
                        if let error = responeModel.error {
                            self.state.send(.error(message: error))
                        }
                    }
                } catch {
                    print(error)
                }
            }
        })
            .store(in: &dataCancellable)
        

    }
    
    // With Combine we return a DataTaskPublisher instead of using the completion handler of the DataTask
    func postUserLogin(user: LoginInfo) throws -> URLSession.DataTaskPublisher {
        let headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]
        let encoder = JSONEncoder()
        guard let postData = try? encoder.encode(user) else {
            throw APIError.invalidResponse
        }
        guard let url = URL(string: API.Config.endPointURL+"auth/login") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        return session.dataTaskPublisher(for: request)
    }
    
}

struct LoginInfo: Codable {
    let email: String
    let password: String
}
