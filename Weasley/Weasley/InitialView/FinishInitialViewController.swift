//
//  FinishInitialViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/16.
//

import UIKit
import Lottie

class FinishInitialViewController: UIViewController {

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .secondarySystemGroupedBackground
        self.view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(lottieView)
        navigationController?.navigationBar.isHidden = true
        lottieView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeArea.bottom)
        }
        lottieView.play()
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
    
    private lazy var lottieView: AnimationView = {
        let animationView = AnimationView(name: "lf30_editor_lqe82iao")
        animationView.loopMode = .loop
        return animationView
    }()
    
}
