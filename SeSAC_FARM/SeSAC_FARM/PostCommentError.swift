//
//  PostCommentError.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/07.
//

import Foundation

// MARK: - PostCommentError
struct PostCommentError: Codable {
    let statusCode: Int
    let error, message: String
    let data: PostCommentErrorDataClass
}

// MARK: - DataClass
struct PostCommentErrorDataClass: Codable {
    let errors: PostCommentErrorErrors
}

// MARK: - Errors
struct PostCommentErrorErrors: Codable {
    let comment: [String]
}
