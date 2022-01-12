//
//  CommentTableViewCell.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/05.
//

import UIKit
import SnapKit


protocol CommentTableViewCellTextViewDelegate {
    
    func updateTextViewHeight(_ cell: CommentTableViewCell,_ textView: UITextView)

}

protocol CommentTableViewCellDelegate: AnyObject {
    
    func categoryButtonTapped()
    
}

class CommentTableViewCell: UITableViewCell {
    
    static let identifier = "CommentTableViewCell"
    
    var textviewDelegate: CommentTableViewCellTextViewDelegate?
    
    var commentButtonClicked : (() -> ())?

    
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "닉네임"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .bold)
        
        return label
    }()
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        
        textView.text = "댓글 내용"
        textView.textColor = .black
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 12, weight: .medium)
        textView.delegate = self
        
        
        
        return textView
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = UIColor(cgColor: CGColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1))
        button.layer.zPosition = 999
        
        return button
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        //commentButton.addTarget(self, action: #selector(categoryClicked), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentClicked), for: .touchUpInside)
        
        
        setUp()
        setConstraints()


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp() {
        
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(commentTextView)
        contentView.addSubview(commentButton)
        
    }
    
    func setConstraints() {
        
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(4)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(commentButton.snp.leading).offset(-16)
        }
        
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(4)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.bottom.equalTo(commentTextView.snp.top).offset(-4)
            make.width.equalTo(33)
        }

        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-4)
        }
        
    }

    
    @objc func commentClicked() {
        commentButtonClicked?()
        
    }



    
}

extension CommentTableViewCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if let delegate = textviewDelegate {
            delegate.updateTextViewHeight(self, textView)
        }
    }
}




