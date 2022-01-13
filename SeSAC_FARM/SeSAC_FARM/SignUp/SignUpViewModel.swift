//
//  SignUpViewModel.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/01.
//

import Foundation

class SignUpViewModel {
    
    var nickname: Observable<String> = Observable("")
    var email: Observable<String> = Observable("")
    var password: Observable<String> = Observable("")
    var passwordConfirm: Observable<String> = Observable("")
    var error: UserError?
    
    func signUp(completion: @escaping (APIResult?) -> Void) {
        print("sign up api start")
        
        APIService.signUp(username: nickname.value, email: email.value, password: password.value) { data, apiresult, usererror in

            
            //회원가입 했으면, 토큰을 userdefault에 저장해야함!!
            if let data = data {
                print(data.jwt)
                UserDefaults.standard.set(data.jwt, forKey: "token")
                UserDefaults.standard.set(data.user.id, forKey: "userid")
            } else {
                self.error = usererror
                UserDefaults.standard.set(nil, forKey: "token")
                UserDefaults.standard.set(nil, forKey: "userid")
            }
            

            completion(apiresult)
        }
    }
    
}
