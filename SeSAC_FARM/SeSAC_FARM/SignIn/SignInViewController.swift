//
//  SignInViewController.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/02.
//

import UIKit
import JGProgressHUD

class SignInViewController: UIViewController {
    
    let mainView = SignInView()
    let viewModel = SignInViewModel()
    let hud = JGProgressHUD()
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.textLabel.text = "Loading"
        self.navigationItem.title = "새싹농장 로그인"
        
        mainView.identifierTextField.addTarget(self, action: #selector(identifierTextFieldDidChange(_:)), for: .editingChanged)
        mainView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        mainView.signInButton.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func identifierTextFieldDidChange(_ textfield: UITextField) {
        viewModel.identifier.value = textfield.text ?? ""
        detectTextFieldFill()
    }
    
    @objc func passwordTextFieldDidChange(_ textfield: UITextField) {
        viewModel.password.value = textfield.text ?? ""
        detectTextFieldFill()
    }
    
    @objc func signInButtonClicked() {
        print(#function)
        hud.show(in: self.view)
        viewModel.signIn {
            print("complete!")
            self.hud.dismiss(afterDelay: 0)
            guard let token = UserDefaults.standard.string(forKey: "token") else{
                //로그인에 실패했으면, userdefaults의 token 값을 nil로 만들어줬다.
                //로그인에 실패했다는 alert를 띄워주자
                
                //1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
                //let alert = UIAlertController(title: "타이틀 테스트", message: "메시지가 입력되었습니다.", preferredStyle: .alert)
                let alert = UIAlertController(title: "로그인 실패", message: "아이디 또는 패스워드를 확인해주세요.", preferredStyle: .alert)
                
                //2. UIAlertAction 생성: 버튼들을...
                let ok = UIAlertAction(title: "확인", style: .default)

                //3. 1 + 2
                alert.addAction(ok)
                
                //4. present
                self.present(alert, animated: true, completion: nil)

                return
            }
            
            //로그인 성공
            print(UserDefaults.standard.string(forKey: "token"))
            //1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
            //let alert = UIAlertController(title: "타이틀 테스트", message: "메시지가 입력되었습니다.", preferredStyle: .alert)
            let alert = UIAlertController(title: "로그인 성공", message: "새싹농장에 오신걸 환영합니다!", preferredStyle: .alert)
            
            //2. UIAlertAction 생성: 버튼들을...
            let ok = UIAlertAction(title: "확인", style: .default) { action in
                //확인 버튼이 눌리면, post view controller로 화면 전환
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: PostViewController())
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            }

            //3. 1 + 2
            alert.addAction(ok)
            
            //4. present
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func detectTextFieldFill() {
        if viewModel.identifier.value != "" && viewModel.password.value != "" {
            DispatchQueue.main.async {
                self.mainView.signInButton.backgroundColor = UIColor(named: "sesac_green")
                self.mainView.signInButton.isEnabled = true
            }
        } else {
            DispatchQueue.main.async {
                self.mainView.signInButton.backgroundColor = UIColor.lightGray
                self.mainView.signInButton.isEnabled = false
            }
        }
    }
}
