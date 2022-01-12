//
//  PostAddViewModel.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/06.
//

import Foundation

class PostAddViewModel {
    
    func uploadPost(text: String, completion: @escaping (APIResult?) -> Void) {
        
        DispatchQueue.main.async {
            print("upload post api start")
            
            //http://test.monocoding.com:1231/posts
            //Body: text
            //Header - Authrization
            
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion(.unauthorized)
                return
            }
            
            APIService.uploadPost(token: token, text: text) { post, apiresult, usererror in

                if let post = post {
                    print(post)
                }
                
                completion(apiresult)
                
            }
            
        }
        
    }
    
}
