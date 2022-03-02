//
//  ProductModel.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

class ProductModel: Codable {
    var id: Int
    var sku: String
    var product_name: String
    var qty: Int
    var price: Double
    var unit: String
    var image: String?
    var status: Int? = 0
    var created_at: String
    var updated_at: String
}

//{
//        "id": 394,
//        "sku": "Vitacimin-500",
//        "product_name": "vitacimin5000",
//        "qty": 2000,
//        "price": 5000,
//        "unit": "new",
//        "image": null,
//        "status": 1,
//        "created_at": "2022-02-21T03:35:32.000000Z",
//        "updated_at": "2022-03-01T07:04:16.000000Z"
//    },
