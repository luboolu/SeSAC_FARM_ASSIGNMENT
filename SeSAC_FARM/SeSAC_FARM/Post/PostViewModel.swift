//
//  PostViewModel.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/02.
//

import Foundation

class PostViewModel {
    
    var postData: [PostElement]?
    //var pagenationData: [Post] = []
    
    
    func getPost(start: Int, limit: Int, completion: @escaping (APIResult?) -> (Void)) {
        
        DispatchQueue.main.async {
            print("get post api start")
            
            //http://test.monocoding.com:1231/posts
            //Header - Authorization : Bearer + jwt
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion(.unauthorized)
                return
            }
            
            APIService.getPost(token: token, start: 0, limit: 100) { post, apiresult, usererror in
                
                if let post = post {

                    self.postData = post
                    //self.pagenationData.append(post)
                    //print("start!!!!!!!!", start)
                    //print("count!!!!!!!!", self.pagenationData.count)

                    
                }
                
                completion(apiresult)
            }
            
        }
        

    }
}
