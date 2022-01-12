//
//  PostEditViewController.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/06.
//

import UIKit
import SnapKit
import JGProgressHUD

class PostEditViewController: UIViewController, ViewRepresentable {

    let hud = JGProgressHUD()
    let viewModel = PostEditViewModel()
    var postData: PostElement?
    
    var postTextView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .white
        textView.text = ""
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.textColor = .black
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 15, weight: .light)
        textView.layer.borderColor = CGColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1)
        textView.layer.borderWidth = 3
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 10
       
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.textLabel.text = "Uploading"
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "게시글 수정"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonClicked))
        
        
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .white

        view.addSubview(postTextView)
        
        postTextView.text = self.postData?.text ?? ""
    }
    
    func setupConstraints() {

        postTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(250)
        }
        
    }
    
    func postUpload() {
        hud.show(in: self.view)
        
        if let postId = self.postData?.id {
            viewModel.postEdit(text: postTextView.text, id: postId) { result in
                if result == .unauthorized {
                    print("사용자 정보 만료!")
                    self.hud.dismiss(afterDelay: 0)
                    self.updateToken()
                } else {
                    self.hud.dismiss(animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }

        }
    }
    
    func updateToken() {
        let alert = UIAlertController(title: "로그인 정보 만료", message: "다시 로그인 해주세요", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default, handler: { _ in
            //확인 버튼이 눌리면, sign in view controller로 화면 전환
            self.navigationController?.pushViewController(SignInViewController(), animated: true)
        })

        alert.addAction(ok)

        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func completeButtonClicked() {
        print(#function)
        
        view.endEditing(true)
        postUpload()
    }
    
}
