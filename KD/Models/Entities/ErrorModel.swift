//
//  ErrorModel.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

struct ErrorModel: Codable {
    let error: String?
    let success: Bool?
    let message: String?
}

//{
//    "success": false,
//    "message": "Item already exists!",
//    "data": null
//}
