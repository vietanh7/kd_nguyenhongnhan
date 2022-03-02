//
//  BasicModel.swift
//  InitBaseProject
//
//  Created by Nguyen Hong Nhan on 28/10/2021.


// https://jsonplaceholder.typicode.com/posts
//{
//    "userId": 2,
//    "id": 11,
//    "title": "et ea vero quia laudantium autem",
//    "body": "delectus reiciendis molestiae occaecati non minima eveniet qui voluptatibus\naccusamus in eum beatae sit\nvel qui neque voluptates ut commodi qui incidunt\nut animi commodi"
//  },


class BasicModel: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
    var isFavorite: Bool? = false
    var avatarUrl: String? = nil
    var photoUrl: String? = nil
}

