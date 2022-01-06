//
//  PostDetailViewModel.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/03.
//

import Foundation

class PostDetailViewModel {
    
    var commentData: [PostCommentElement]?
    
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
                    self.commentData = comment
                }
                
                completion()
            }
            
        }
        
    }
    
    
}
