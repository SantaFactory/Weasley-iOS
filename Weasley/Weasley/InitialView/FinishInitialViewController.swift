//
//  FinishInitialViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/16.
//

import UIKit

class FinishInitialViewController: UIViewController {

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .secondarySystemGroupedBackground
        self.view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 28)
        label.text = "Just wait until registration"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
}
