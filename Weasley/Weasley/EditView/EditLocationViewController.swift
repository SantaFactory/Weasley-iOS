//
//  EditLocationViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/08.
//

import UIKit
import SnapKit
import MapKit

class EditLocationViewController: UIViewController {
    
    let viewModel = CurrentLocations.share
    let annotoation = MKPointAnnotation()
    var buttonHeight: CGFloat = 40
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(backgroundBView)
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(setHomeButton)
        self.view.addSubview(setSchoolButton)
        self.view.addSubview(setWorkButton)
        self.view.addSubview(skipButton)
        self.view.addSubview(mapView)
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
            make.bottom.equalTo(self.setSchoolButton.snp.top).offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(buttonHeight)
        }
        setSchoolButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.setWorkButton.snp.top).offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(buttonHeight)
        }
        setWorkButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.skipButton.snp.top).offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(buttonHeight)
        }
        skipButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeArea.bottom).offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(buttonHeight)
        }
        mapView.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(40)
            make.bottom.equalTo(setHomeButton.snp.top).offset(-40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let lat = Double(viewModel.userLatitude!)!
        let long = Double(viewModel.userLongitude!)!
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let circle = MKCircle(center: location, radius: 500)
        annotoation.coordinate = location
        mapView.setRegion(MKCoordinateRegion(center: location, span: span), animated: true)
        mapView.addOverlay(circle)
        mapView.addAnnotation(annotoation)
        
    }
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Home", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(setHome), for: .touchUpInside)
        button.rounded(buttonHeight / 2)
        return button
    }()
    
    private lazy var setSchoolButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("School", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(setSchool), for: .touchUpInside)
        button.rounded(buttonHeight / 2)
        return button
    }()
    
    private lazy var setWorkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Work", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(setWork), for: .touchUpInside)
        button.rounded(buttonHeight / 2)
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(skipSet), for: .touchUpInside)
        return button
    }()

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
}

extension EditLocationViewController {
    
    @objc private func setHome(_ sender: UIButton) {
        viewModel.setLocation(loc: "home", latitude: viewModel.userLatitude!, longitude: viewModel.userLongitude!) { result in
            if result.task == "success" {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Error!!!!")
            }
        }
    }
    
    @objc private func setSchool(_ sender: UIButton) {
      
    }
    
    @objc private func setWork(_ sender: UIButton) {
     
    }
    
    @objc private func skipSet() {
        dismiss(animated: true, completion: nil)
    }
}

extension EditLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else {
            return MKOverlayRenderer()
        }
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
        circleRenderer.fillColor = .systemPink
        circleRenderer.alpha = 0.5
        return circleRenderer
    }
}
