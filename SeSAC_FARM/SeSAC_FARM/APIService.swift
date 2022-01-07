//
//  APIService.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/01.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case noData
    case failed
    case invalidData
}

class APIService {
    
    //회원가입 SignUp
    static func signUp(username: String, email: String, password: String, completion: @escaping (User?, APIError?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.signup)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "username=\(username)&email=\(email)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
        
        //URLSession.request(.shared, endpoint: request, completion: completion)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {

                guard error == nil else {
                    completion(nil, .failed, nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil, .noData, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse, nil)
                    return
                }
                
                guard response.statusCode == 200 else {
                    do {
                        let decoder = JSONDecoder()
                        let errorData = try decoder.decode(UserError.self, from: data)
                        completion(nil, .invalidResponse, errorData)
                        return
                    } catch {
                        completion(nil, .failed, nil)
                        return
                    }
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(User.self, from: data)
                    completion(userData, nil, nil)
                } catch {
                    completion(nil, .invalidData, nil)
                }
            }
        }).resume()
  
        
    }
    
    //로그인 sign in
    static func signIn(identifier: String, password: String, completion: @escaping (User?, APIError?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.signin)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "identifier=\(identifier)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
        
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {

                guard error == nil else {
                    completion(nil, .failed, nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil, .noData, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse, nil)
                    return
                }
                
                guard response.statusCode == 200 else {
                    do {
                        let decoder = JSONDecoder()
                        let errorData = try decoder.decode(UserError.self, from: data)
                        completion(nil, .invalidResponse, errorData)
                        return
                    } catch {
                        completion(nil, .failed, nil)
                        return
                    }
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(User.self, from: data)
                    completion(userData, nil, nil)
                } catch {
                    completion(nil, .invalidData, nil)
                }
            }
        }).resume()
  
        
    }
    
    //게시판 가져오기
    static func getPost(token: String, completion: @escaping (Post?, APIError?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.post)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        print(url)
//        print(token)
//        print(request)
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
//                print(error)
//                print(response)
//                print(data)
                guard error == nil else {
                    completion(nil, .failed, nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil, .noData, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse, nil)
                    return
                }
                
                guard response.statusCode == 200 else {
                    do {
                        let decoder = JSONDecoder()
                        let errorData = try decoder.decode(UserError.self, from: data)
                        completion(nil, .invalidResponse, errorData)
                        return
                    } catch {
                        completion(nil, .failed, nil)
                        return
                    }
                }
                
                do {
                    print("디코딩 시작##")
                    let decoder = JSONDecoder()
                    let postData = try decoder.decode(Post.self, from: data)
                    completion(postData, nil, nil)
                } catch {
                    print("디코딩 실패")
                    completion(nil, .invalidData, nil)
                }
            }
        }).resume()
  
        
    }
    
    //댓글 가져오기
    static func getComments(token: String, postId: Int, completion: @escaping (PostComments?, APIError?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.comment)?post=\(postId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
//        print(url)

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {

                guard error == nil else {
                    completion(nil, .failed, nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil, .noData, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse, nil)
                    return
                }
                
                guard response.statusCode == 200 else {
                    completion(nil, .failed, nil)
                    return
                }
                
                do {
                    print("디코딩 시작##")
                    let decoder = JSONDecoder()
                    let commentData = try decoder.decode(PostComments.self, from: data)
                    completion(commentData, nil, nil)
                } catch {
                    print("디코딩 실패")
                    completion(nil, .invalidData, nil)
                }
            }
        }).resume()
  
    }
    
    //댓글 업로드
    static func postComments(token: String, postId: Int, comment: String, completion: @escaping (PostCommentElement?, APIError?, PostCommentError?) -> (Void)) {
        
        let url = URL(string: "\(URL.comment)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "comment=\(comment)&post=\(postId)".data(using: .utf8, allowLossyConversion: false)
 
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                
                guard error == nil else {
                    completion(nil, .failed, nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil, .noData, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse, nil)
                    return
                }
                
                guard response.statusCode == 200 else {
                    do {
                        let decoder = JSONDecoder()
                        let errorData = try decoder.decode(PostCommentError.self, from: data)
                        completion(nil, .invalidResponse, errorData)
                        return
                    } catch {
                        completion(nil, .failed, nil)
                        return
                    }
                }
                
                do {
                    print("디코딩 시작##")
                    let decoder = JSONDecoder()
                    let commentData = try decoder.decode(PostCommentElement.self, from: data)
                    print("디코딩 결과")
                    print(commentData)
                    completion(commentData, nil, nil)
                } catch {
                    print("디코딩 실패")
                    completion(nil, .invalidData, nil)
                }
            }
        }).resume()
  
        
    }
    
    //게시글 업로드
    static func uploadPost(token: String, text: String, completion: @escaping (UploadPost?, APIError?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.uploadPost)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        //URLSession.request(.shared, endpoint: request, completion: completion)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {

                guard error == nil else {
                    completion(nil, .failed, nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil, .noData, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse, nil)
                    return
                }
                
                guard response.statusCode == 200 else {
                    do {
                        let decoder = JSONDecoder()
                        let errorData = try decoder.decode(UserError.self, from: data)
                        completion(nil, .invalidResponse, errorData)
                        return
                    } catch {
                        completion(nil, .failed, nil)
                        return
                    }
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(UploadPost.self, from: data)
                    completion(userData, nil, nil)
                } catch {
                    completion(nil, .invalidData, nil)
                }
            }
        }).resume()
  
    }
    
    //게시글 삭제
    static func deletePost(token: String, postId: Int, completion: @escaping (UploadPost?, APIError?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.uploadPost)/\(postId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {

                guard error == nil else {
                    completion(nil, .failed, nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil, .noData, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse, nil)
                    return
                }
                
                guard response.statusCode == 200 else {
                    do {
                        let decoder = JSONDecoder()
                        let errorData = try decoder.decode(UserError.self, from: data)
                        completion(nil, .invalidResponse, errorData)
                        return
                    } catch {
                        completion(nil, .failed, nil)
                        return
                    }
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(UploadPost.self, from: data)
                    completion(userData, nil, nil)
                } catch {
                    completion(nil, .invalidData, nil)
                }
            }
        }).resume()
  
    }
    
    //게시글 수정
    static func editPost(token: String, postId: Int, text: String, completion: @escaping (UploadPost?, APIError?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.uploadPost)/\(postId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {

                guard error == nil else {
                    completion(nil, .failed, nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil, .noData, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse, nil)
                    return
                }
                
                guard response.statusCode == 200 else {
                    do {
                        let decoder = JSONDecoder()
                        let errorData = try decoder.decode(UserError.self, from: data)
                        completion(nil, .invalidResponse, errorData)
                        return
                    } catch {
                        completion(nil, .failed, nil)
                        return
                    }
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(UploadPost.self, from: data)
                    completion(userData, nil, nil)
                } catch {
                    completion(nil, .invalidData, nil)
                }
            }
        }).resume()
  
    }
    
    //게시글 새로고침
    static func reloadPost(token: String, postId: Int, completion: @escaping (PostElement?, APIError?, UserError?) -> (Void)) {
        
        let url = URL(string: "\(URL.uploadPost)/\(postId)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {

                guard error == nil else {
                    completion(nil, .failed, nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil, .noData, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse, nil)
                    return
                }
                
                guard response.statusCode == 200 else {
                    do {
                        let decoder = JSONDecoder()
                        let errorData = try decoder.decode(UserError.self, from: data)
                        completion(nil, .invalidResponse, errorData)
                        return
                    } catch {
                        completion(nil, .failed, nil)
                        return
                    }
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(PostElement.self, from: data)
                    completion(userData, nil, nil)
                } catch {
                    completion(nil, .invalidData, nil)
                }
            }
        }).resume()
  
    }
    
}
