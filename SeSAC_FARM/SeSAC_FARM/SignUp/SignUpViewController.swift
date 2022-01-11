//
//  SignUpViewController.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/01.
//

import UIKit
import SnapKit
import JGProgressHUD

class SignUpViewController: UIViewController {
    
    let mainView = SignUpView()
    let viewModel = SignUpViewModel()
    let hud = JGProgressHUD()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.textLabel.text = "Loading"
        self.navigationItem.title = "새싹농장 가입하기"
    
        
        mainView.emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        mainView.nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldDidChange(_:)), for: .editingChanged)
        mainView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        mainView.passwordConfirmTextField.addTarget(self, action: #selector(passwordConfirmTextFieldDidChange(_:)), for: .editingChanged)
        
        mainView.signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        
    }
    

    
    @objc func emailTextFieldDidChange(_ textfield: UITextField) {
        viewModel.email.value = textfield.text ?? ""
        detectTextFieldFill()
    }
    
    @objc func nicknameTextFieldDidChange(_ textfield: UITextField) {
        viewModel.nickname.value = textfield.text ?? ""
        detectTextFieldFill()
    }
    
    @objc func passwordTextFieldDidChange(_ textfield: UITextField) {
        viewModel.password.value = textfield.text ?? ""
        detectTextFieldFill()
    }
    
    @objc func passwordConfirmTextFieldDidChange(_ textfield: UITextField) {
        viewModel.passwordConfirm.value = textfield.text ?? ""
        detectTextFieldFill()
    }
    
    @objc func signUpButtonClicked() {
        print(#function)
        hud.show(in: self.view)
        
        if mainView.passwordTextField.text == mainView.passwordConfirmTextField.text {
            //비밀번호, 비밀번호 확인 서로 동일하면 api 통신 시작
            
            viewModel.signUp {
                self.hud.dismiss(afterDelay: 0)
                
                guard let token = UserDefaults.standard.string(forKey: "token") else{
                    //로그인에 실패했으면, userdefaults의 token 값을 nil로 만들어줬다.
                    //로그인에 실패했다는 alert를 띄워주자
                    
                    //1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
                    let alert = UIAlertController(title: "Failed", message: "\(self.viewModel.error?.message[0].messages[0].message ?? "")", preferredStyle: .alert)
                    
                    //2. UIAlertAction 생성: 버튼들을...
                    let ok = UIAlertAction(title: "확인", style: .default)

                    //3. 1 + 2
                    alert.addAction(ok)
                    
                    //4. present
                    self.present(alert, animated: true, completion: nil)

                    return
                }
                
                //로그인 성공
                //print(UserDefaults.standard.string(forKey: "token"))
                //1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
                //let alert = UIAlertController(title: "타이틀 테스트", message: "메시지가 입력되었습니다.", preferredStyle: .alert)
                let alert = UIAlertController(title: "회원가입 성공", message: "새싹농장에 오신걸 환영합니다!", preferredStyle: .alert)
                
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
        } else {
            self.hud.dismiss(afterDelay: 0)
            //1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
            let alert = UIAlertController(title: "Failed", message: "비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
            
            //2. UIAlertAction 생성: 버튼들을...
            let ok = UIAlertAction(title: "확인", style: .default)

            //3. 1 + 2
            alert.addAction(ok)
            
            //4. present
            self.present(alert, animated: true, completion: nil)

            return
        }
        

    }
    
    func detectTextFieldFill() {
        if viewModel.email.value != "" && viewModel.nickname.value != "" && viewModel.password.value != "" && viewModel.passwordConfirm.value != "" {
            DispatchQueue.main.async {
                self.mainView.signUpButton.backgroundColor = UIColor(named: "sesac_green")
                self.mainView.signUpButton.setTitle("시작하기", for: .normal)
                self.mainView.signUpButton.isEnabled = true
            }
        } else {
            DispatchQueue.main.async {
                self.mainView.signUpButton.backgroundColor = UIColor.lightGray
                self.mainView.signUpButton.setTitle("가입하기", for: .normal)
                self.mainView.signUpButton.isEnabled = false
            }
        }
    }
    
    

    
}
