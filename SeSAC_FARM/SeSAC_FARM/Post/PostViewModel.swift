//
//  PostViewModel.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/02.
//

import Foundation

class PostViewModel {
    
    var postData: [PostElement]?
    
    
    func getPost(completion: @escaping (APIResult?) -> (Void)) {
        
        DispatchQueue.main.async {
            print("get post api start")
            
            //http://test.monocoding.com:1231/posts
            //Header - Authorization : Bearer + jwt
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion(.unauthorized)
                return
            }
            
            APIService.getPost(token: token) { post, apiresult, usererror in
                
                if let post = post {
                    self.postData = post
                }
                
                print(apiresult)
                print(usererror)
                
                completion(apiresult)
            }
            
        }
        

    }
}
