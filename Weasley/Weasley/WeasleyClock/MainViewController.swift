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
    
    //MARK: Sample members parameters
    let members = [Member(user: "doyoung lee", currentLoction: .home), Member(user: "jasper oh", currentLoction: .home), Member(user: "designer", currentLoction: .lost), Member(user: "investor", currentLoction: .travel), Member(user: "Android Dev", currentLoction: .work), Member(user: "analyst", currentLoction: .lost)]
    
    private lazy var clockView: Clock = {
        let view = Clock(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.backgroundColor = .clear
        return view
    }()
    
    func loadNeeles() {
        for member in members {
            let needle = Needle()
            needle.text = "\t\(member.user.uppercased())"
            needle.value = member.currentLoction.location
            self.view.addSubview(needle)
            needle.snp.makeConstraints { make in
                make.centerX.equalTo(clockView.snp.centerX)
                make.centerY.equalTo(clockView.snp.centerY)
            }
        }
    }
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "escape"), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        view.backgroundColor = .secondarySystemBackground
        self.view.addSubview(clockView)
        clockView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        loadNeeles()
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
        dismiss(animated: true, completion: nil)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("Latitude: \(lat)\nLongitude: \(lon)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
}
