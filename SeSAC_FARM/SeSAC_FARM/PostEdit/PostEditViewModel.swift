//
//  PostEditViewModel.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/06.
//

import Foundation

class PostEditViewModel {
    
    func postEdit(text: String, id: Int, completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            print("post edit api start")
            
            //http://test.monocoding.com:1231/posts
            //Header - Authorization : Bearer + jwt
            //http://test.monocoding.com:1231/comments?post=468

            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion()
                return
            }
            
            APIService.editPost(token: token, postId: id, text: text) { post, apierror, usererror in
                
                print(apierror)
                print(usererror)
                
                completion()
                
            }
            
        }
        
    }
    

    
}
