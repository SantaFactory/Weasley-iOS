//
//  EditPlaceViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/17.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit

class EditPlaceViewController: UIViewController {

    var place: String?
    let locationManager = CLLocationManager()
    var placeLocation = "Latitude: lat \nLongitude: long"
    
    var lat: String?
    var long: String?
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .secondarySystemBackground
        self.view.addSubview(titleLabel)
        self.view.addSubview(locationLabel)
        self.view.addSubview(deleteButton)
        self.view.addSubview(mapView)
        self.view.addSubview(requestLocationButton)
        self.view.addSubview(doneButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeArea.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        requestLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.doneButton.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        mapView.snp.makeConstraints { make in
            make.top.equalTo(deleteButton.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(requestLocationButton.snp.top)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Place"
        mapView.delegate = self
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        markLocation()
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Current \(place!) location:"
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = placeLocation
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete place location", for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    private lazy var requestLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Request current location", for: .normal)
        button.addTarget(self, action: #selector(requestCurrentLocation), for: .touchUpInside)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        return button
    }()
    
    func markLocation() {
        mapView.removeOverlays(mapView.overlays)
        guard let latitude = lat, let longitude = long else {
            return
        }
        let lat = Double(latitude)!
        let long = Double(longitude)!
        let loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let circle = MKCircle(center: loc, radius: 200)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        mapView.setRegion(MKCoordinateRegion(center: loc, span: span), animated: true)
        mapView.addOverlay(circle)
    }
}

extension EditPlaceViewController {
    @objc func requestCurrentLocation() {
        locationManager.requestLocation()
    }
}

//MARK: CORE LOCATION MANGER DELEGATE
extension EditPlaceViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let digit: Double = pow(10, 3)
            self.lat = String(round(location.coordinate.latitude * digit) / digit)
            self.long = String(round(location.coordinate.longitude * digit) / digit)
            markLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Cancel Location")
        print("Error: \(error.localizedDescription)")
    }
    
}

extension EditPlaceViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else {
            return MKOverlayRenderer()
        }
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
        circleRenderer.fillColor = .systemBlue
        circleRenderer.alpha = 0.7
        return circleRenderer
    }
}
