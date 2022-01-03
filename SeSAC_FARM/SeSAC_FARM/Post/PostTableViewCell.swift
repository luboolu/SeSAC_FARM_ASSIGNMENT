//
//  TableViewCell.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/02.
//

import UIKit
import SnapKit



class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"
    
    lazy var postTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "닉네임"
        label.backgroundColor = UIColor(cgColor: CGColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1))
        label.clipsToBounds = true
        label.layer.cornerRadius = 2
        label.textColor = UIColor(cgColor: CGColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1))
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        
        return label
    }()
    
    lazy var contentTextView: UITextView = {
        let textview = UITextView()
        
        textview.text = "내용"
        textview.isEditable = false
        textview.backgroundColor = .clear
        textview.textColor = .black
        textview.textAlignment = .left
        textview.font = .systemFont(ofSize: 15, weight: .medium)
        
        return textview
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "날짜"
        label.backgroundColor = .clear
        label.textColor = UIColor(cgColor: CGColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1))
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        
        return label
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .clear
        button.setTitle("댓글쓰기", for: .normal)
        button.setTitleColor(UIColor(cgColor: CGColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        button.tintColor = UIColor(cgColor: CGColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1))
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUi()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setUi() {
        
        addSubview(nicknameLabel)
        addSubview(contentTextView)
        addSubview(dateLabel)
        addSubview(commentButton)
        
    }
    
    func setConstraints() {
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(dateLabel.snp.top).offset(-4)
        }
       
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

    }

}

//extension PostTableViewCell {
//    public func bind(model: PostTableViewCellModel) {
//        nicknameLabel.text = model.nickname.text
//        contentTextView.text = model.content.text
//        dateLabel.text = model.date.text
//    }
//}
