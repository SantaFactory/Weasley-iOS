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
    var buttonHeight: CGFloat = 40
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(backgroundBView)
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(setHomeButton)
        self.view.addSubview(setSchoolButton)
        self.view.addSubview(setWorkButton)
        self.view.addSubview(cancelButton)
        self.view.addSubview(mapView)
        self.view.addSubview(statusHomeImgView)
        self.view.addSubview(statusSchoolImgView)
        self.view.addSubview(statusWorkImgView)
        
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
        statusWorkImgView.snp.makeConstraints { make in
            make.trailing.equalTo(welcomeLabel.snp.trailing)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        statusSchoolImgView.snp.makeConstraints { make in
            make.trailing.equalTo(statusWorkImgView.snp.leading).offset(-4)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        statusHomeImgView.snp.makeConstraints { make in
            make.trailing.equalTo(statusSchoolImgView.snp.leading).offset(-4)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        setHomeButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.setSchoolButton.snp.top).offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(buttonHeight)
        }
        setSchoolButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.setWorkButton.snp.top).offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(buttonHeight)
        }
        setWorkButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.cancelButton.snp.top).offset(-8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(buttonHeight)
        }
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeArea.bottom).offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(buttonHeight)
        }
        mapView.snp.makeConstraints { make in
            make.top.equalTo(statusHomeImgView.snp.bottom).offset(6)
            make.bottom.equalTo(setHomeButton.snp.top).offset(-30)
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
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let circle = MKCircle(center: location, radius: 200)
        mapView.setRegion(MKCoordinateRegion(center: location, span: span), animated: true)
        mapView.addOverlay(circle)
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
        let button = GradientButton()
        button.backgroundColor = .systemBackground
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Home", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(tapButton), for: .touchDown)
        button.addTarget(self, action: #selector(cancelTap), for: .touchUpOutside)
        button.addTarget(self, action: #selector(setLocation), for: .touchUpInside)
        button.rounded(buttonHeight / 3)
        return button
    }()
    
    private lazy var setSchoolButton: UIButton = {
        let button = GradientButton()
        button.backgroundColor = .systemBackground
        button.setTitleColor(.white, for: .normal)
        button.setTitle("School", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(tapButton), for: .touchDown)
        button.addTarget(self, action: #selector(cancelTap), for: .touchUpOutside)
        button.addTarget(self, action: #selector(setLocation), for: .touchUpInside)
        button.rounded(buttonHeight / 3)
        return button
    }()
    
    private lazy var setWorkButton: UIButton = {
        let button = GradientButton()
        button.backgroundColor = .systemBackground
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Work", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(tapButton), for: .touchDown)
        button.addTarget(self, action: #selector(cancelTap), for: .touchUpOutside)
        button.addTarget(self, action: #selector(setLocation), for: .touchUpInside)
        button.rounded(buttonHeight / 3)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(tapButton), for: .touchDown)
        button.addTarget(self, action: #selector(cancelTap), for: .touchUpOutside)
        button.addTarget(self, action: #selector(skipSet), for: .touchUpInside)
        button.rounded(buttonHeight / 3)
        return button
    }()

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    private lazy var statusHomeImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house.circle")
        imageView.tintColor = .systemPink
        return imageView
    }()
    
    private lazy var statusSchoolImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "graduationcap.circle")
        imageView.tintColor = .systemPink
        return imageView
    }()
    
    private lazy var statusWorkImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "building.2.crop.circle")
        imageView.tintColor = .systemPink
        return imageView
    }()
}

extension EditLocationViewController {
    
    @objc private func setLocation(_ sender: UIButton) {
        sender.alpha = 1.0
        let location = sender.titleLabel?.text!.lowercased()
        viewModel.setLocation(loc: location!, latitude: viewModel.userLatitude!, longitude: viewModel.userLongitude!) { result in
            switch result.task {
            case "success":
                self.dismiss(animated: true, completion: nil)
            case "duplicated":
                //TODO Alert
                let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                let ok = UIAlertAction(title: "Okay", style: .default) { _ in
                    self.viewModel.reSetLocation(loc: location!, latitude: self.viewModel.userLatitude!, longitude: self.viewModel.userLongitude!) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                alert.addAction(cancel)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            default:
                print("Error!!!!")
            }
        }
    }
    
    @objc private func tapButton(_ sender: UIButton) {
        sender.alpha = 0.5
    }
    
    @objc private func cancelTap(_ sender: UIButton) {
        sender.alpha = 1.0
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
