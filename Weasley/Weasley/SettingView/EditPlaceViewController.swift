//
//  EditPlaceViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/17.
//

import UIKit
import MapKit
import SnapKit

class EditPlaceViewController: UIViewController {

    var place: String?
    var placeLocation = "Latitude: lat \nLongitude: long"
    
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
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        return button
    }()
    
}
