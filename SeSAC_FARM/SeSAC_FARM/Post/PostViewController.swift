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
    
    var startPage = 0
    var limitPost = 100
    
    let hud = JGProgressHUD()
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
        
        //getPost()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        self.startPage = 0
        self.viewModel.postData = []
        self.viewModel.pagenationData = []
        getPost()
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        
        postTableView.backgroundColor = .white
        
        view.addSubview(postTableView)
        
        postTableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.prefetchDataSource = self
        
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
    
    func getPost() {
        hud.show(in: self.view)
        viewModel.getPost(start: self.startPage, limit: self.limitPost) { result in
            print("get post complete!")
            print(result)
            
            if result == .unauthorized {
                print("사용자 정보 만료!")
                self.hud.dismiss(afterDelay: 0)
                self.updateToken()
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.postTableView.reloadData()
                    self.hud.dismiss(afterDelay: 0)
                }

            }
            print("================================================")
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
    
    @objc func postAddButtonClicked() {
        print(#function)
        let vc = PostAddViewController()
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func resetButtonClicked() {
        print(#function)
        //get post api 통신 다시 해서 tableview reload
        self.startPage = 0
        self.viewModel.postData = []
        self.viewModel.pagenationData = []
        getPost()

    }
    
}


extension PostViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
//        for indexPath in indexPaths {
//            print(indexPath)
//            if indexPath.row == 10 && self.startPage <= indexPath.section {
//
//                self.startPage += 1
//                print("startPageUP: \(self.startPage)")
//                self.getPost()
//            }
//
//        }
        
        
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.viewModel.postData?.count ?? 0
        print("cell: ", self.viewModel.pagenationData.count * self.limitPost)
        return self.viewModel.postData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell else {
            return UITableViewCell()
        }
//
        print(indexPath)
        print("pagenationData: ", self.viewModel.pagenationData.count)
        print("startPage: ", self.startPage)
        
        
//        let data = self.viewModel.pagenationData[indexPath.section]
//        let row = data[indexPath.row]
//        print(row.id)
//        cell.nicknameLabel.text = "  \(row.user.username)  "
//        cell.contentTextView.text = "\(row.text)"
//
//
//        var subStringDate = row.createdAt.substring(from: 0, to: 18)
//        subStringDate.append("Z")
//
//        // The default timeZone for ISO8601DateFormatter is UTC
//        let utcISODateFormatter = ISO8601DateFormatter()
//        let utcDate = utcISODateFormatter.date(from: subStringDate)!
//
//        let df = DateFormatter()
//        df.locale = Locale(identifier: "ko_KR")
//        df.timeZone = TimeZone(abbreviation: "KST")
//        df.dateFormat = "MM/dd hh:mm"
//
//        let date = df.string(from: utcDate)
//
//        cell.dateLabel.text = "\(date)"
//
////
//        cell.nicknameLabel.text = "\(indexPath)"
        
        if let data = self.viewModel.postData {

            let row = try! data[indexPath.row]
            print(row.user.username)
            cell.nicknameLabel.text = "  \(row.user.username)  "
            cell.contentTextView.text = "\(row.text)"


            var subStringDate = row.createdAt.substring(from: 0, to: 18)
            subStringDate.append("Z")

            // The default timeZone for ISO8601DateFormatter is UTC
            let utcISODateFormatter = ISO8601DateFormatter()
            let utcDate = utcISODateFormatter.date(from: subStringDate)!

            let df = DateFormatter()
            df.locale = Locale(identifier: "ko_KR")
            df.timeZone = TimeZone(abbreviation: "KST")
            df.dateFormat = "MM/dd hh:mm"

            let date = df.string(from: utcDate)

            cell.dateLabel.text = "\(date)"

            

        }

//        if let data = self.viewModel.postData {
//            let row = data[indexPath.row]
//            print(row.user.username)
//            cell.nicknameLabel.text = "  \(row.user.username)  "
//            cell.contentTextView.text = "\(row.text)"
//
//
//            var subStringDate = row.createdAt.substring(from: 0, to: 18)
//            subStringDate.append("Z")
//
//            // The default timeZone for ISO8601DateFormatter is UTC
//            let utcISODateFormatter = ISO8601DateFormatter()
//            let utcDate = utcISODateFormatter.date(from: subStringDate)!
//
//            let df = DateFormatter()
//            df.locale = Locale(identifier: "ko_KR")
//            df.timeZone = TimeZone(abbreviation: "KST")
//            df.dateFormat = "MM/dd hh:mm"
//
//            let date = df.string(from: utcDate)
//
//            cell.dateLabel.text = "\(date)"
//        }



        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = PostDetailViewController()
        
        if let data = self.viewModel.postData {
            vc.postId = data[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        

    }
    
}

extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
}
