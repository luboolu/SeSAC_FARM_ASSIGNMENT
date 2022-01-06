//
//  PostDetailViewController.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/03.
//

import UIKit
import SnapKit
import JGProgressHUD

class PostDetailViewController: UIViewController {
    
    let viewModel = PostDetailViewModel()
    var postData: PostElement?
    let hud = JGProgressHUD()
    
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
        textView.isScrollEnabled = false
        textView.textColor = .black
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 15, weight: .medium)
       
        return textView
    }()
    
    var inputCommentTextField: UITextField = {
        let textField = UITextField()
        
        //textField.placeholder = "   댓글을 입력해주세요"
        textField.attributedPlaceholder = NSAttributedString(string: "  댓글을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textField.textColor = .black
        textField.textAlignment = .left
        textField.font = .systemFont(ofSize: 12, weight: .medium)
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1))
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 0.5 * 44
        
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.textLabel.text = "Loading"
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        
        
        setupView()
        setupConstraints()
        

        if let postData = self.postData {
            nicknameLabel.text = "\(postData.user.username)"
            postContentTextView.text = "\(postData.text)"
            dateLabel.text = "\(postData.createdAt)"
            
            getCommentData(id: postData.id)
        }


        
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
        
        //commentTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(inputCommentTextField)
        
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
        }
        
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(postContentTextView.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            //make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        inputCommentTextField.snp.makeConstraints { make in
            make.top.equalTo(commentTableView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(44)
        }
 
    }
    
    func getCommentData(id: Int) {
        hud.show(in: self.view)
        viewModel.getComment(id: id) {
            self.commentTableView.reloadData()
            self.hud.dismiss(afterDelay: 0)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as? CommentTableViewCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        //cell.nicknameLabel.text = "바미"
        
        if let data = self.viewModel.commentData {
            let row = data[indexPath.row]
            
            cell.nicknameLabel.text = "\(row.user.username)"
            cell.commentTextView.text = "\(row.comment)"
//            cell.nicknameLabel.text = "\(row.user.)"
//            cell.commentTextView.text = "\(row)"
        }
        
        
        return cell
    }
    
    
}
