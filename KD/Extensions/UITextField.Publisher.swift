//
//  UITextField.Publisher.swift
//  Demo-Combine
//
//  Created by Nguyen Hong Nhan on 27/12/2021.
//

import Foundation
import Combine

//extension UITextField {
//    
//    /**
//     guide:
//     countTextField.textPublisher
//     .sink { value in
//     self.count = Int(value) ?? 0
//     }
//     .store(in: &subscriptions)
//     */
//    var publisher: AnyPublisher<String, Never> {
//        NotificationCenter.default.publisher(
//            for: UITextField.textDidChangeNotification,
//               object: self
//        )
//            .compactMap { ($0.object as? UITextField)?.text }
//            .eraseToAnyPublisher()
//    }
//    
//}
