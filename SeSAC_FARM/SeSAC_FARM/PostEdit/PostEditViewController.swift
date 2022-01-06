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
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
    }
    
    func postUpload() {
        hud.show(in: self.view)
        
        if let postId = self.postData?.id {
            viewModel.postEdit(text: postTextView.text, id: postId) {
                self.hud.dismiss(animated: true)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        

    }
    
    @objc func completeButtonClicked() {
        print(#function)
        
        view.endEditing(true)
        postUpload()
    }
    
}
