//
//  SignInViewModel.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/02.
//

import Foundation

class SignInViewModel {
    
    var identifier: Observable<String> = Observable("")
    var password: Observable<String> = Observable("")
    
    func signIn(completion: @escaping () -> Void) {
        print("sign in api start")
        
        APIService.signIn(identifier: identifier.value, password: password.value) { data, error, usererror in
            
            if let usererror = usererror {
                print(usererror.message[0].messages[0].message)
            }
            
            //로그인 했으면, 토큰을 userdefault에 저장해야함!!
            if let data = data {
                print(data.jwt)
                UserDefaults.standard.set(data.jwt, forKey: "token")
                UserDefaults.standard.set(data.user.id, forKey: "userid")
            } else {
                UserDefaults.standard.set(nil, forKey: "token")
                UserDefaults.standard.set(nil, forKey: "userid")
            }
            
            
            
            completion()
        }
    }
    
}

