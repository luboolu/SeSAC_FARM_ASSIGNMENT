//
//  UploadPost.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/06.
//

import Foundation

// MARK: - UploadPost
struct UploadPost: Codable {
    let id: Int
    let text: String
    let user: UploadPostUser
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, text, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - User
struct UploadPostUser: Codable {
    let id: Int
    let username, email, provider: String
    let confirmed: Bool
    let role: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, username, email, provider, confirmed, role
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
