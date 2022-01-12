//
//  PostDetailViewModel.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/03.
//

import Foundation

class PostDetailViewModel {
    
    var commentData: [PostCommentElement]?
    var postData: PostElement?
    
    //댓글 가져오기
    func getComment(id: Int, completion: @escaping (APIResult?) -> Void) {
        
        DispatchQueue.main.async {
            print("get comment api start")
            
            //http://test.monocoding.com:1231/posts
            //Header - Authorization : Bearer + jwt
            //http://test.monocoding.com:1231/comments?post=468

            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion(.unauthorized)
                return
            }
            
            APIService.getComments(token: token, postId: id) { comment, apiresult, usererror in
                
                if let comment = comment {
                    self.commentData = comment
                }
                
                completion(apiresult)
            }
            
        }
        
    }
    
    //댓글 업로드
    func uploadComment(id: Int, text: String, completion: @escaping (APIResult?) -> Void) {
        
        DispatchQueue.main.async {
            print("upload comment api start")
            
            //http://test.monocoding.com:1231/posts
            //Header - Authorization : Bearer + jwt
            //http://test.monocoding.com:1231/comments?post=468

            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion(.unauthorized)
                return
            }
            
            
            APIService.postComments(token: token, postId: id, comment: text) { comment, apiresult, usererror in
                

                completion(apiresult)
            }
            
        }
        
    }
    
    //댓글 삭제
    func deleteComment(postId: Int, commentId: Int, completion: @escaping (APIResult?) -> Void) {
        
        DispatchQueue.main.async {
            print("upload comment api start")
            
            //http://test.monocoding.com:1231/posts
            //Header - Authorization : Bearer + jwt
            //http://test.monocoding.com:1231/comments?post=468

            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion(.unauthorized)
                return
            }
            
            
            APIService.deleteComments(token: token, commentId: commentId, postId: postId) { comment, apiresult, usererror in
                
                
                completion(apiresult)
            }
            
        }
        
    }
    
    func deletePost(id: Int, completion: @escaping (APIResult?) -> Void) {
        DispatchQueue.main.async {
            print("delete post api start")
            
            //http://test.monocoding.com:1231/posts/id
            //Header - Authorization : Bearer + jwt

            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion(.unauthorized)
                return
            }
            
            APIService.deletePost(token: token, postId: id) { post, apiresult, usererror in
                
                completion(apiresult)
            }
            
        }
    }
    
    
    func reloadPost(id: Int, completion: @escaping (APIResult?) -> Void) {
        
        DispatchQueue.main.async {
            print("post reload api start")
            
            //http://test.monocoding.com:1231/posts
            //Header - Authorization : Bearer + jwt
            //http://test.monocoding.com:1231/comments?post=468

            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion(.unauthorized)
                return
            }
            
            APIService.reloadPost(token: token, postId: id) { post, apiresult, usererror in
                
                if let post = post {
                    self.postData = post
                }
                
                
                completion(apiresult)
                
            }
            
        }
        
    }
    
    
}
