//
//  SetHomeViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/15.
//

import UIKit
import MapKit
import SnapKit

protocol ShowResultMap {
    func markAreaOverlay(result: MKLocalSearchCompletion)
    func clearOverlay()
}

class SetHomeViewController: UIViewController {

    
    private var suggestionController: SearchedLocationTableViewController!
    private var searchController: UISearchController!
    var showResultMapDelegate: ShowResultMap? = nil
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(mapView)
        self.view.addSubview(nextButton)
        self.view.addSubview(skipButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(mapView.snp.top).offset(-20)
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
        
        suggestionController = SearchedLocationTableViewController(style: .grouped)
        searchController = UISearchController(searchResultsController: suggestionController)
        searchController.searchResultsUpdater = suggestionController

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        mapView.delegate = self
        suggestionController.showResultMapDelegate = self
        definesPresentationContext = true
        showResultMapDelegate = self
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

// MARK: Search Bar Delegate
extension SetHomeViewController: UISearchBarDelegate {
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
        guard let suggestion = suggestionController.completerResults?[0] else {
            //MARK: TO DO - 검색결과 없는 경우
            return
        }
        //search(for: suggestion)
        showResultMapDelegate?.clearOverlay()
        showResultMapDelegate?.markAreaOverlay(result: suggestion)
        dismiss(animated: true, completion: nil)
        
        // The user tapped search on the `UISearchBar` or on the keyboard. Since they didn't
        // select a row with a suggested completion, run the search with the query text in the search field.
    }
}

extension SetHomeViewController: ShowResultMap {
    func markAreaOverlay(result: MKLocalSearchCompletion) {
        searchController.isActive = false
        searchController.searchBar.text = result.title
        let searchResult = MKLocalSearch.Request(completion: result)
        MKLocalSearch(request: searchResult).start { response, error in
            guard let response = response else {
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
            let loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let circle = MKCircle(center: loc, radius: 200)
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            self.mapView.setRegion(MKCoordinateRegion(center: loc, span: span), animated: true)
            self.mapView.addOverlay(circle)
        }
    }
    
    func clearOverlay() {
        mapView.removeOverlays(mapView.overlays)
    }
}

extension SetHomeViewController: MKMapViewDelegate {
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
