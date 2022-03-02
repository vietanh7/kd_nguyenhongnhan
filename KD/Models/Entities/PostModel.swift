//
//  PostModel.swift
//  Demo-Combine
//
//  Created by Nguyen Hong Nhan on 30/12/2021.
//

class PostModel: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
    var isFavorite: Bool? = false
    var avatarUrl: String? = nil
}

// https://jsonplaceholder.typicode.com/posts
/*[
 {
     "userId": 2,
     "id": 11,
     "title": "et ea vero quia laudantium autem",
     "body": "delectus reiciendis molestiae occaecati non minima eveniet qui voluptatibus\naccusamus in eum beatae sit\nvel qui neque voluptates ut commodi qui incidunt\nut animi commodi"
   },
 ...
 ]
 */
