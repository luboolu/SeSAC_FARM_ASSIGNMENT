//
//  CommentEditViewModel.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/10.
//

import UIKit

class CommentViewModel {
    
    //댓글 수정
    func editComment(postId: Int, commentId: Int, text: String, completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            print("edit comment api start")
            
            //http://test.monocoding.com:1231/posts
            //Header - Authorization : Bearer + jwt
            //http://test.monocoding.com:1231/comments?post=468

            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion()
                return
            }
            
            APIService.editComments(token: token, commentId: commentId, postId: postId, text: text){ comment, apierror, usererror in
                
                
                completion()
            }
            
        }
        
    }
    
}
