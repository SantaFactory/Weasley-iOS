//
//  InitialViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/14.
//

import UIKit
import SnapKit

class InitialViewController: UIViewController {

    override func loadView() {
        super.loadView()
        self.view.addSubview(setGroupTextField)
        setGroupTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    lazy var setGroupTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()

    lazy var setButton: UIButton = {
       let button = UIButton()
        button.setTitle("Set Group", for: .normal)
        button.addTarget(self, action: <#T##Selector#>, for: .touchUpInside)
        return button
    }()
    
    @objc func setGroup() {
        //MARK: Set Group Action
    }

}
