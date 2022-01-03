//
//  PostDetailViewController.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/03.
//

import UIKit
import SnapKit

class PostDetailViewController: UIViewController {
    
    let viewModel = PostDetailViewModel()
    
    var commentTableView: UITableView = {
        let tableView = UITableView()
        
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
    
    var profileStackView2: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(profileImage)
        
        profileStackView1.addSubview(nicknameLabel)
        profileStackView1.addSubview(dateLabel)
        
        profileStackView2.addSubview(profileImage)
        profileStackView2.addSubview(profileStackView1)
    }
    
    func setupConstraints() {
        
        profileImage.snp.makeConstraints { make in
            make.width.equalTo(33)
            make.height.equalTo(33)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        
        profileStackView2.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        

        
    }
}
