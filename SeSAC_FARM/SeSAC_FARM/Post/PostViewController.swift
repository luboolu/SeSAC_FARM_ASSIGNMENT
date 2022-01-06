//
//  PostViewController.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/02.
//

import UIKit
import SnapKit
import JGProgressHUD

class PostViewController: UIViewController {
    
    let hud = JGProgressHUD()
    
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
    
    var resetButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)

        button.backgroundColor = UIColor(cgColor: CGColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1))
        button.tintColor = .black
        button.clipsToBounds = true
        button.layer.cornerRadius = 0.5 * 33
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.textLabel.text = "Loading"
        
        self.navigationController?.isNavigationBarHidden = true
        
        setupView()
        setupConstraints()
        

        hud.show(in: self.view)
        viewModel.getPost {
            print("get post complete!")
            self.postTableView.reloadData()
            self.hud.dismiss(afterDelay: 0)
        }


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
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
        
        view.addSubview(resetButton)
        resetButton.addTarget(self, action: #selector(resetButtonClicked), for: .touchUpInside)
        
        
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
        
        resetButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-50)
            make.width.equalTo(33)
            make.height.equalTo(33)
        }
    }
    
    @objc func postAddButtonClicked() {
        print(#function)
        let vc = PostAddViewController()
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func resetButtonClicked() {
        print(#function)
        //get post api 통신 다시 해서 tableview reload

        hud.show(in: self.view)
        viewModel.getPost {
            print("get post complete!")
            self.postTableView.reloadData()
            self.hud.dismiss(afterDelay: 0)
        }

    }
    
}


extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.postData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        if let data = self.viewModel.postData {
            let row = data[indexPath.row]
            print(row.user.username)
            cell.nicknameLabel.text = "  \(row.user.username)  "
            cell.contentTextView.text = "\(row.text)"
            cell.dateLabel.text = "\(row.createdAt)"
        }



        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = PostDetailViewController()
        
        if let data = self.viewModel.postData {
            vc.postData = data[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        

    }
    
}
