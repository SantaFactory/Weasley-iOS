//
//  ViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/25.
//

import UIKit
import CoreLocation
import GoogleSignIn
import SnapKit

class MainViewController: UIViewController {

    let locationManager = CLLocationManager()
    let viewModel = CurrentLocations()
    lazy var members = viewModel.groupMembers
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .secondarySystemBackground
        self.view.addSubview(arcLocationLabel)
        arcLocationLabel.snp.makeConstraints { make in
            make.height.equalTo(self.view.frame.width)
            make.width.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.view.addSubview(signOutButton)
        signOutButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(self.view.safeArea.top).offset(20)
        }
        self.view.addSubview(relocateButton)
        relocateButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.centerX.equalTo(arcLocationLabel.snp.centerX)
            make.centerY.equalTo(arcLocationLabel.snp.centerY)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 위치 서비스를 사용하기 위한 사용자 권한 요청
        locationManager.requestLocation() // 사용자의 현재 위치에 대한 일회성 전달을 요청
        loadNeeles()
    }
    
    func loadNeeles() {
        for member in members {
            let needle = Needle()
            needle.text = member.user.email
            needle.value = member.currentLoction.location
            self.view.addSubview(needle)
            needle.snp.makeConstraints { make in
                make.centerX.equalTo(arcLocationLabel.snp.centerX)
                make.centerY.equalTo(arcLocationLabel.snp.centerY)
            }
            needles.updateValue(needle, forKey: member.user.sub)
        }
    }
    //MARK: Sample members&needle properties
    var needles = [String : Needle]()
    
    private lazy var arcLocationLabel: LocationLabel = {
        let label = LocationLabel()
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var clockView: Clock = {
        let view = Clock(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "escape"), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    private lazy var relocateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "safari.fill"), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(reLocate), for: .touchUpInside)
        return button
    }()
    
}

extension MainViewController {
    
    @objc func signOut() {
        print("Sign Out")
        GIDSignIn.sharedInstance.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Sample Method
    @objc func reLocate() {
        
        }
//        let needle = needles.first {
//            $0.id == me?.user
//        }
//        me!.currentLoction =
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            UIView.animate(withDuration: 1) {
//                needle?.value = me!.currentLoction.location
//            }
//        }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = String(format: "%.4f", location.coordinate.latitude)
            let long = String(format: "%.4f", location.coordinate.longitude)
            viewModel.getLocation(latitude: lat, longitude: long) {
                print("Get Data")
                /*
                 if _ == nil {
                 let destinationVC = MapPinViewController()
                 destinationVC.modalPresentationStyle = .overFullScreen
                 present(destinationVC, animated: true, completion: nil)
                 } else {
                 //MARK: Update View
                 }
                 */
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Cancel Location")
        print("Error: \(error.localizedDescription)")
    }
    
}
