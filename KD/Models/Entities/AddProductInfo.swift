//
//  AddProductInfo.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

struct AddProductInfo: Codable {
    let sku: String
    let product_name: String
    let qty: Int
    let price: Double
    let unit: String
    let status: Int
}
