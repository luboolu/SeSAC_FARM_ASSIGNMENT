//
//  PostViewController.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/02.
//

import UIKit
import SnapKit

class PostViewController: UIViewController {
    
    //let mainView = PostView()
    let viewModel = PostViewModel()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "새싹농장"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        
        return label
    }()
    
    var postTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    var postAddButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "plus"), for: .normal)

        button.backgroundColor = UIColor(named: "sesac_green")
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 0.5 * 55
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupView()
        setupConstraints()
        
        viewModel.getPost {
            print("get post complete!")
        }
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        
        postTableView.backgroundColor = .orange
        
        view.addSubview(postTableView)
        
        postTableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        postTableView.delegate = self
        postTableView.dataSource = self
        
        view.addSubview(postAddButton)
        postAddButton.addTarget(self, action: #selector(postAddButtonClicked), for: .touchUpInside)
        
        
        
    }
    
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(30)
        }
        
        postTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        postAddButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(55)
            make.height.equalTo(55)
        }
    }
    
    @objc func postAddButtonClicked() {
        print(#function)
        let vc = PostAddViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        cell.nicknameLabel.text = "  바미  "
        cell.contentTextView.text = "새싹농장 가입인사 드려요 *^^*\n두번째줄\n3번째줄\n4번째줄\n5번째줄"
        cell.dateLabel.text = "01/02"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = PostDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        

    }
    
}
