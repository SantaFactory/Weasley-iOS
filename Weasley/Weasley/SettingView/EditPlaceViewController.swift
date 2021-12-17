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

struct GSC {
    var lat: String?
    var long: String?
}

class EditPlaceViewController: UIViewController {
   
    private var suggestionController: SearchedLocationTableViewController!
    private var searchController: UISearchController!
    
    var place: String?
    let locationManager = CLLocationManager()
    var placeLocation = "Latitude: lat \nLongitude: long"
    
    var gsc: GSC? = nil {
        didSet {
            markLocation()
        }
    }
    
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
        
        suggestionController = SearchedLocationTableViewController(style: .grouped)
        searchController = UISearchController(searchResultsController: suggestionController)
        searchController.searchResultsUpdater = suggestionController
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Place"
        mapView.delegate = self
        locationManager.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        suggestionController.showResultMapDelegate = self
        definesPresentationContext = true
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
        guard let location = gsc else {
            return
        }
        guard let latitude = location.lat, let longitude = location.long else {
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
    private func getGSC(latitude: Double, longitude: Double) {
        let digit: Double = pow(10, 3)
        let lat = String(round(latitude * digit) / digit)
        let long = String(round(longitude * digit) / digit)
        gsc = GSC(lat: lat, long: long)
    }
    
    private func getResut(result: MKLocalSearchCompletion) {
        let searchResult = MKLocalSearch.Request(completion: result)
        MKLocalSearch(request: searchResult).start { response, error in
            guard let response = response else {
                print("response is nil")
                return
                //MARK: TODO nil
            }
            let item = response.mapItems[0]
            let location = item.placemark.location
            let latitude = location?.coordinate.latitude
            let longitude = location?.coordinate.longitude
            guard let lat = latitude, let long = longitude else {
                return
            }
            self.getGSC(latitude: lat, longitude: long)
        }
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
            getGSC(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Cancel Location")
        print("Error: \(error.localizedDescription)")
    }
    
}

// MARK: Map View Delegate
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

// MARK: Search Bar Delegate
extension EditPlaceViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let suggestion = suggestionController.completerResults, suggestion.count != 0 else {
            //self.showAlert()
            dismiss(animated: true, completion: nil)
            return
        }
        getResut(result: suggestion[0])
        dismiss(animated: true, completion: nil)
    }
}

extension EditPlaceViewController: ShowResultMap {
    func markAreaOverlay(result: MKLocalSearchCompletion) {
        searchController.isActive = false
        searchController.searchBar.text = result.title
        getResut(result: result)
    }
    
    func clearOverlay() {
        mapView.removeOverlays(mapView.overlays)
    }
}
