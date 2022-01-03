//
//  PostAddViewController.swift
//  SeSAC_FARM
//
//  Created by 김진영 on 2022/01/04.
//

import UIKit
import SnapKit

class PostAddViewController: UIViewController, ViewRepresentable {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "새싹농장 글쓰기"
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .white

    }
    
    func setupConstraints() {

        
    }
    
}
