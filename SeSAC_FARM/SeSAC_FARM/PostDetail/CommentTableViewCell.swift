//
//  CommentTableViewCell.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/05.
//

import UIKit
import SnapKit


protocol TableViewCellDelegate {
    func updateTextViewHeight(_ cell: CommentTableViewCell,_ textView: UITextView)
}

class CommentTableViewCell: UITableViewCell {
    
    static let identifier = "CommentTableViewCell"
    
    var delegate: TableViewCellDelegate?

    
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
        
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = UIColor(cgColor: CGColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1))
        
        return button
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func setUp() {
        
        addSubview(commentButton)
        addSubview(nicknameLabel)
        addSubview(commentTextView)
        
    }
    
    func setConstraints() {
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(4)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(33)
            make.height.equalTo(nicknameLabel.snp.height)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(0)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-4)
        }
        
    }
    
}

extension CommentTableViewCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if let delegate = delegate {
            delegate.updateTextViewHeight(self, textView)
        }
    }
}
