//
//  APIService.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/01.
//

import Foundation

enum APIResult: Error {
    case invalidResponse
    case noData
    case failed
    case invalidData
    case unauthorized
    case succeed
}

class APIService {
    
    //회원가입 SignUp
    static func signUp(username: String, email: String, password: String, completion: @escaping (User?, APIResult?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.signup)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "username=\(username)&email=\(email)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
        
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    //로그인 sign in
    static func signIn(identifier: String, password: String, completion: @escaping (User?, APIResult?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.signin)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "identifier=\(identifier)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
        
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    //게시판 가져오기
    static func getPost(token: String, start: Int, limit: Int, completion: @escaping (Post?, APIResult?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.post)&_start=\(start)&_limit=\(limit)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    //댓글 가져오기
    static func getComments(token: String, postId: Int, completion: @escaping (PostComments?, APIResult?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.comment)?post=\(postId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    //댓글 업로드
    static func postComments(token: String, postId: Int, comment: String, completion: @escaping (PostCommentElement?, APIResult?, PostCommentError?) -> (Void)) {
        
        let url = URL(string: "\(URL.comment)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "comment=\(comment)&post=\(postId)".data(using: .utf8, allowLossyConversion: false)
 
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    //댓글 삭제
    static func deleteComments(token: String, commentId: Int, postId: Int, completion: @escaping (PostCommentElement?, APIResult?, PostCommentError?) -> (Void)) {
        
        let url = URL(string: "\(URL.comment)/\(commentId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.httpBody = "post=\(postId)".data(using: .utf8, allowLossyConversion: false)
 
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    //댓글 수정
    static func editComments(token: String, commentId: Int, postId: Int, text: String, completion: @escaping (PostCommentElement?, APIResult?, PostCommentError?) -> (Void)) {
        
        let url = URL(string: "\(URL.comment)/\(commentId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.httpBody = "post=\(postId)&comment=\(text)".data(using: .utf8, allowLossyConversion: false)
 
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    //게시글 업로드
    static func uploadPost(token: String, text: String, completion: @escaping (UploadPost?, APIResult?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.uploadPost)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    //게시글 삭제
    static func deletePost(token: String, postId: Int, completion: @escaping (UploadPost?, APIResult?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.uploadPost)/\(postId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    //게시글 수정
    static func editPost(token: String, postId: Int, text: String, completion: @escaping (UploadPost?, APIResult?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.uploadPost)/\(postId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    //게시글 새로고침
    static func reloadPost(token: String, postId: Int, completion: @escaping (PostElement?, APIResult?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.uploadPost)/\(postId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(.shared, endpoint: request, completion: completion)
  
    }
    
}
