//
//  PostDetailViewController.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/03.
//

import UIKit
import SnapKit
import JGProgressHUD
import Toast

class PostDetailViewController: UIViewController {
    
    let viewModel = PostDetailViewModel()
    let hud = JGProgressHUD()
    let style = ToastStyle()
    
    var postId = -1
    var selectedCommentID = -1
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var commentTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        
        return tableView
    }()
    
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .lightGray
        
        return imageView
    }()
    
    var nicknameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "닉네임"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "01/02"
        label.textColor = UIColor(cgColor: CGColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1))
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10, weight: .medium)
        
        return label
    }()
    
    var profileStackView1: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    var postContentTextView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .white
        textView.text = "새싹농장 가입인사 드려요!!!"
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.textColor = .black
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 15, weight: .medium)
       
        return textView
    }()
    
    var inputCommentView = UIView()
    
    var inputCommentTextField: UITextField = {
        let textField = UITextField()
        
        //textField.placeholder = "   댓글을 입력해주세요"
        textField.attributedPlaceholder = NSAttributedString(string: "  댓글을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textField.textColor = .black
        textField.textAlignment = .left
        textField.font = .systemFont(ofSize: 12, weight: .medium)
        textField.backgroundColor = .clear
        
        return textField
    }()
    
    var commentUploadButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1))
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        
        return button
        
    }()
    
    /******************************
     
     POST MENU SETTING
     
     ********************************************/
    
    //UIMenu 사용하기
    var postMenuItems: [UIAction] {
        return [
        UIAction(title: "수정", image: UIImage(systemName: "pencil"), handler: { _ in
            print("수정 clicked")
            
            if self.canEditable(selectecId: self.viewModel.postData?.user.id ?? -1) {
                print("수정할 수 있습니다")

                //게시글 수정 화면으로 화면전환
                let vc = PostEditViewController()
                vc.postData = self.viewModel.postData
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                print("수정할 수 없습니다")
                self.view.makeToast("본인의 게시글만 수정할 수 있습니다" ,duration: 2.0, position: .bottom, style: self.style)
            }
            
        }),
        UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in
            print("삭제 clicked")
            
            if self.canEditable(selectecId: self.viewModel.postData?.user.id ?? -1) {
                print("삭제할 수 있습니다")
                
                //1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
                //let alert = UIAlertController(title: "타이틀 테스트", message: "메시지가 입력되었습니다.", preferredStyle: .alert)
                let alert = UIAlertController(title: "주의", message: "게시글을 삭제하시겠습니까?", preferredStyle: .alert)
                
                //2. UIAlertAction 생성: 버튼들을...
                let ok = UIAlertAction(title: "확인", style: .default) { _ in
                    if let postId = self.viewModel.postData?.id {
                        self.hud.show(in: self.view)
                        
                        self.viewModel.deletePost(id: postId) {  result in
                            if result == .unauthorized {
                                print("사용자 정보 만료!")
                                self.hud.dismiss(animated: true)
                                self.updateToken()
                            } else if result == .succeed {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                                    self.hud.dismiss(animated: true)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }else {
                                self.hud.dismiss(animated: true)
                                
                                let alert = UIAlertController(title: "네트워크 통신 에러", message: "네트워크 상태를 확인해주세요", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "확인", style: .default)

                                alert.addAction(ok)

                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        

                        
                    }
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)

                //3. 1 + 2
                alert.addAction(ok)
                alert.addAction(cancel)

                //4. present
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("삭제할 수 없습니다")
                self.view.makeToast("본인의 게시글만 삭제할 수 있습니다" ,duration: 2.0, position: .bottom, style: self.style)
            }
        })
            ]
    }

    var postMenu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: postMenuItems)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.textLabel.text = "Loading"
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        
        let editButton = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: postMenu)

        self.navigationItem.rightBarButtonItem = editButton
        
        //데이터 로드
        //reloadPost(id: self.postId)
        
        setupView()
        setupConstraints()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("수정 후 리로드")
        
        reloadPost(id: self.postId)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
//        let vc = PostViewController()
//        vc.getPost()
//        vc.reloadInputViews()
//
    }
    
    
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(profileImage)

        profileStackView1.addSubview(nicknameLabel)
        profileStackView1.addSubview(dateLabel)

        view.addSubview(profileStackView1)
        view.addSubview(postContentTextView)

        //댓글 테이블뷰
        view.addSubview(commentTableView)
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        commentTableView.delegate = self
        commentTableView.dataSource = self


        
        inputCommentView.addSubview(inputCommentTextField)
        view.addSubview(inputCommentView)

        inputCommentView.backgroundColor = UIColor(cgColor: CGColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1))
        inputCommentView.clipsToBounds = true
        inputCommentView.layer.cornerRadius = 10

        view.addSubview(commentUploadButton)

        commentUploadButton.addTarget(self, action: #selector(commentUploadButtonClicked), for: .touchUpInside)
    }
    
    func setupConstraints() {

        profileImage.snp.makeConstraints { make in

            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileStackView1.snp.top)
            make.leading.equalTo(profileStackView1.snp.leading)
            make.trailing.equalTo(profileStackView1.snp.trailing)
            make.height.equalTo(20)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.leading.equalTo(profileStackView1.snp.leading)
            make.trailing.equalTo(profileStackView1.snp.trailing)
            make.height.equalTo(20)
        }

        profileStackView1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)

        }

        postContentTextView.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.greaterThanOrEqualTo(88)
            make.height.lessThanOrEqualTo(200)
        }

        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(postContentTextView.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }



        inputCommentView.snp.makeConstraints { make in
            make.top.equalTo(commentTableView.snp.bottom).offset(4)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }

        inputCommentTextField.snp.makeConstraints { make in
            make.top.equalTo(inputCommentView.snp.top).offset(4)
            make.leading.equalTo(inputCommentView.snp.leading).offset(12)
            make.trailing.equalTo(inputCommentView.snp.trailing).offset(-4)
            make.bottom.equalTo(inputCommentView.snp.bottom).offset(-4)
        }

        commentUploadButton.snp.makeConstraints { make in
            make.top.equalTo(commentTableView.snp.bottom).offset(4)
            make.leading.equalTo(inputCommentView.snp.trailing).offset(4)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(33)
            make.width.equalTo(44)
        }


 
    }
    
    func canEditable(selectecId: Int) -> Bool {
        //현재 포스트의 수정, 삭제 권한을 가지고 있는지 확인
        print(#function)
        //포스트의 user.id == user default의 user id이면 true 반환, 아니면 false 반환
        let myId = UserDefaults.standard.integer(forKey: "userid")

        if myId == selectecId {
            return true
        } else {
            return false
        }
        
    }
    
    func getCommentData(id: Int) {
        //댓글 데이터 가져오기
        hud.show(in: self.view)
        viewModel.getComment(id: id) { result in
            
            if result == .unauthorized {
                print("사용자 정보 만료!")
                self.hud.dismiss(animated: true)
                self.updateToken()
            } else if result == .succeed {
                self.commentTableView.reloadData()
                self.hud.dismiss(animated: true)
            } else {
                self.hud.dismiss(animated: true)
                
                let alert = UIAlertController(title: "네트워크 통신 에러", message: "네트워크 상태를 확인해주세요", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)

                alert.addAction(ok)

                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }
    
    func postDelete(id: Int) {
        //게시글 삭제하기
        hud.show(in: self.view)
        viewModel.getComment(id: id) { result in
            if result == .unauthorized {
                print("사용자 정보 만료!")
                self.hud.dismiss(animated: true)
                self.updateToken()
            } else if result == .succeed {
                self.commentTableView.reloadData()
                self.hud.dismiss(animated: true)
            } else {
                self.hud.dismiss(animated: true)
                
                let alert = UIAlertController(title: "네트워크 통신 에러", message: "네트워크 상태를 확인해주세요", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)

                alert.addAction(ok)

                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func reloadPost(id: Int) {
        //게시글 새로고침
        hud.show(in: self.view)
        viewModel.reloadPost(id: id) { result in
            if result == .unauthorized {
                print("사용자 정보 만료!")
                self.hud.dismiss(animated: true)
                self.updateToken()
            } else if result == .succeed {
            
                if let postData = self.viewModel.postData {

                    self.nicknameLabel.text = "\(postData.user.username)"
                    self.postContentTextView.text = "\(postData.text)"
                    
                    var subStringDate = postData.createdAt.substring(from: 0, to: 18)
                    subStringDate.append("Z")
                    
                    // The default timeZone for ISO8601DateFormatter is UTC
                    let utcISODateFormatter = ISO8601DateFormatter()
                    let utcDate = utcISODateFormatter.date(from: subStringDate)!
                    
                    let df = DateFormatter()
                    df.locale = Locale(identifier: "ko_KR")
                    df.timeZone = TimeZone(abbreviation: "KST")
                    df.dateFormat = "MM/dd hh:mm"

                    let date = df.string(from: utcDate)
                    
                    
                    self.dateLabel.text = "\(date)"
                    
                    self.getCommentData(id: postData.id)
                }
                
                self.view.reloadInputViews()
                self.hud.dismiss(animated: true)
            } else {
                self.hud.dismiss(animated: true)
                
                let alert = UIAlertController(title: "네트워크 통신 에러", message: "네트워크 상태를 확인해주세요", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)

                alert.addAction(ok)

                self.present(alert, animated: true, completion: nil)
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
    
    @objc func commentUploadButtonClicked() {
        print(#function)
        //댓글 업로드
        hud.show(in: self.view)
        let comment = inputCommentTextField.text ?? ""
        
        viewModel.uploadComment(id: self.postId, text: comment) { result in
            if result == .unauthorized {
                print("사용자 정보 만료!")
                self.hud.dismiss(animated: true)
                self.updateToken()
            } else if result == .succeed {
                self.view.endEditing(true)
                self.inputCommentTextField.text = ""
                self.getCommentData(id: self.postId)
                self.hud.dismiss(animated: true)
            } else {
                self.hud.dismiss(animated: true)
                
                let alert = UIAlertController(title: "네트워크 통신 에러", message: "네트워크 상태를 확인해주세요", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)

                alert.addAction(ok)

                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    

    

}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.commentData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as? CommentTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none

        if let data = self.viewModel.commentData {
            let row = data[indexPath.row]

            cell.nicknameLabel.text = "\(row.user.username)"
            cell.commentTextView.text = "\(row.comment)"

            
            let editing = UIAction(title: "수정", image: UIImage(systemName: "pencil")) { _ in
                print("수정하기")
                if self.canEditable(selectecId: self.viewModel.commentData?[indexPath.row].user.id ?? -1) {
                    print("수정할 수 있습니다")

                    //댓글 수정 화면으로 화면전환
                    let vc = CommentEditViewController()
                    vc.commentData = self.viewModel.commentData?[indexPath.row]
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    print("수정할 수 없습니다")
                    self.view.makeToast("본인의 댓글만 수정할 수 있습니다" ,duration: 2.0, position: .bottom, style: self.style)
                }
            }
            
            let deleting = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                print("삭제하기")
                
                if self.canEditable(selectecId: self.viewModel.commentData?[indexPath.row].user.id ?? -1) {
                    print("삭제할 수 있습니다")
                    //삭제할건지 한번 더 물은 후에 삭제
                    //1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
                    let alert = UIAlertController(title: "주의", message: "댓글을 삭제하시겠습니까?", preferredStyle: .alert)
                    
                    //2. UIAlertAction 생성: 버튼들을...
                    let ok = UIAlertAction(title: "확인", style: .default) { _ in
                        if let postId = self.viewModel.postData?.id, let commentId = self.viewModel.commentData?[indexPath.row].id {
                            self.viewModel.deleteComment(postId: postId, commentId: commentId) { result in
                                if result == .unauthorized {
                                    print("사용자 정보 만료!")
                                    self.hud.dismiss(animated: true)
                                    self.updateToken()
                                } else if result == .succeed {
                                    self.getCommentData(id: postId)
                                } else {
                                    self.hud.dismiss(animated: true)
                                    
                                    let alert = UIAlertController(title: "네트워크 통신 에러", message: "네트워크 상태를 확인해주세요", preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "확인", style: .default)

                                    alert.addAction(ok)

                                    self.present(alert, animated: true, completion: nil)
                                }
                            }

                        }
                    }
                    let cancel = UIAlertAction(title: "취소", style: .cancel)

                    //3. 1 + 2
                    alert.addAction(ok)
                    alert.addAction(cancel)
                    
                    //4. present
                    self.present(alert, animated: true, completion: nil)
                    

                } else {
                    print("삭제할 수 없습니다")
                    self.view.makeToast("본인의 댓글만 삭제할 수 있습니다" ,duration: 2.0, position: .bottom, style: self.style)
                }
            }
            
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [editing, deleting])
            
            cell.commentButton.menu = menu
            cell.commentButton.showsMenuAsPrimaryAction = true
   
        }
        
        return cell
    }
}
