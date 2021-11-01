//
//  ViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/25.
//

import UIKit
import GoogleSignIn
import SnapKit

class MainViewController: UIViewController {

    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "escape"), for: .normal)
        button.tintColor = .systemYellow
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(signOutButton)
        signOutButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(self.view.safeArea.top).offset(20)
        }
    }

}

extension MainViewController {
    
    @objc func signOut() {
        print("Sign Out")
        GIDSignIn.sharedInstance.signOut()
    }
}
