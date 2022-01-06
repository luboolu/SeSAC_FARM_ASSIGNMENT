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
    
    func getComment(id: Int, completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            print("get post api start")
            
            //http://test.monocoding.com:1231/posts
            //Header - Authorization : Bearer + jwt
            //http://test.monocoding.com:1231/comments?post=468

            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion()
                return
            }
            
            APIService.getComments(token: token, postId: id) { comment, apierror, usererror in
                
                if let comment = comment {
                    if comment.count > 0 {
                        print(comment[0].comment)
                    }
                    
                    self.commentData = comment
                }
                
                completion()
            }
            
        }
        
    }
    
    func deletePost(id: Int, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            print("delete post api start")
            
            //http://test.monocoding.com:1231/posts/id
            //Header - Authorization : Bearer + jwt

            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion()
                return
            }
            
            APIService.deletePost(token: token, postId: id) { post, apierror, usererror in
                

                completion()
            }
            
        }
    }
    
    
    func reloadPost(id: Int, completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            print("post reload api start")
            
            //http://test.monocoding.com:1231/posts
            //Header - Authorization : Bearer + jwt
            //http://test.monocoding.com:1231/comments?post=468

            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion()
                return
            }
            
            APIService.reloadPost(token: token, postId: id) { post, apierror, usererror in
                
                if let post = post {
                    self.postData = post
                    //print(post)

                }
                
                completion()
                
            }
            
        }
        
    }
    
    
}
