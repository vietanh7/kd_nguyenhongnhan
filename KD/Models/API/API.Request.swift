//
//  API.Request.swift
//  Demo-Combine
//
//  Created by Nguyen Hong Nhan on 28/12/2021.
//

import Foundation
import Combine

extension API {
    
    static func getListObject<T: Decodable>(endPoint: String, id: Int? = nil, type: T.Type) -> Future<[T], Error> {
        return Future<[T], Error> { promise in
            guard let url = URL(string: endPoint) else {
                return promise(.failure(APIError.invalidURL))
            }
            print("endPointURL: \(url.absoluteString)")
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw APIError.invalidResponse
                    }
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .mapError { error -> APIError in
                    switch error {
                    case is URLError:
                        return .errorURL
                    case is DecodingError:
                        return .errorParsing
                    default:
                        return error as? APIError ?? .unknown
                    }
                }
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                }, receiveValue: {
                    promise(.success($0))
                })
                .store(in: &cancellables)
        }
    }
}
