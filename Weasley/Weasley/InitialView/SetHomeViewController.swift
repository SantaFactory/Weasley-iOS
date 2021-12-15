//
//  SetHomeViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/15.
//

import UIKit
import MapKit
import SnapKit

class SetHomeViewController: UIViewController {

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(searchLocationButton)
        self.view.addSubview(mapView)
        self.view.addSubview(nextButton)
        self.view.addSubview(skipButton)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(searchLocationButton.snp.top).offset(-20)
        }
        searchLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(mapView.snp.top).offset(-20)
            make.height.equalTo(44)
        }
        mapView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.view.snp.bottom).offset(-20)
            make.height.equalTo(44)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 28)
        label.text = "Mark Home Location"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "Pick a location for your home location. You can always change it later."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    lazy var searchLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemRed
        button.setTitle("Search location", for: .normal)
        button.setImage(UIImage(systemName: "map.fill"), for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(searchLocation), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        return button
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .blue
        button.setTitle("Skip", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    @objc func searchLocation() {
        let nextVC = SelectLocationTableViewController()
        let destinationVC = UINavigationController(rootViewController: nextVC)
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    @objc func goNext() {
        let destinationVC = SetSchoolViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    @objc func skip() {
        let destinationVC = MainViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true, completion: nil)
    }
}
