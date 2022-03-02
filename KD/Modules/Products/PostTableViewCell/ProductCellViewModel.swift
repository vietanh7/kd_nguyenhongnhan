//
//  ProductCellViewModel.swift
//  Demo-Combine
//
//  Created by Nguyen Hong Nhan on 29/12/2021.
//

import Foundation
import Combine

final class ProductCellViewModel {
    var product: UserModel
    
    init(product: UserModel) {
        self.product = product
    }
}
