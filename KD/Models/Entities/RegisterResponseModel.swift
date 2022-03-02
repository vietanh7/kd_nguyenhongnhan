//
//  RegisterResponseModel.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

struct RegisterResponseModel: Codable {
    let error: String?
    let success: Bool?
    let message: String?
}

//{
//    "success": true,
//    "message": "Success register!",
//    "data": {
//        "email": "test0303@gmail.com",
//        "updated_at": "2022-03-02T13:52:58.000000Z",
//        "created_at": "2022-03-02T13:52:58.000000Z",
//        "id": 418
//    }
//}
