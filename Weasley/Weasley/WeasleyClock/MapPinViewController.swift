//
//  MapPinViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/08.
//

import UIKit
import SnapKit

class MapPinViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(backgroundBView)
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(setHomeButton)
        self.view.addSubview(setSchoolButton)
        self.view.addSubview(setWorkButton)
        self.view.addSubview(doneButton)
        backgroundBView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        setHomeButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.setSchoolButton.snp.top).offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        setSchoolButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.setWorkButton.snp.top).offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        setWorkButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.doneButton.snp.top).offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeArea.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
    }
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Where your current loaction?"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    private lazy var backgroundBView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemChromeMaterialDark)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()
    
    private lazy var setHomeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Home", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(setHome), for: .touchUpInside)
        button.backgroundColor = .blue
        return button
    }()
    
    
    private lazy var setSchoolButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.setTitleColor(.white, for: .normal)
        button.setTitle("School", for: .normal)
        button.addTarget(self, action: #selector(setSchool), for: .touchUpInside)
        return button
    }()
    
    private lazy var setWorkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Work", for: .normal)
        button.addTarget(self, action: #selector(setWork), for: .touchUpInside)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(doneSet), for: .touchUpInside)
        return button
    }()

}

extension MapPinViewController {
    
    @objc private func setHome(_ sender: UIButton) {
        print("Home")
    }
    
    @objc private func setSchool(_ sender: UIButton) {
        print("School")
    }
    
    @objc private func setWork(_ sender: UIButton) {
        print("Work")
    }
    
    @objc private func doneSet() {
        //TODO: Set API Post
        dismiss(animated: true, completion: nil)
    }
}
