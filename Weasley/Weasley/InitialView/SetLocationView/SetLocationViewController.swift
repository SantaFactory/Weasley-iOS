//
//  SetLocationViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/16.
//

import UIKit
import MapKit
import SnapKit

protocol ShowResultMap {
    func markAreaOverlay(result: MKLocalSearchCompletion)
    func clearOverlay()
}

class SetLocationViewController: UIViewController {

    var viewModel = UsersGroups.shared
    var destinationVC: UIViewController!
    let gradientLayer = CAGradientLayer()
    
    private var suggestionController: SearchedLocationTableViewController!
    private var searchController: UISearchController!
    var showResultMapDelegate: ShowResultMap? = nil
    override func loadView() {
        super.loadView()
        suggestionController = SearchedLocationTableViewController(style: .grouped)
        searchController = UISearchController(searchResultsController: suggestionController)
        searchController.searchResultsUpdater = suggestionController
    }
    
    private func loadUI() {
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
        nextButton.enableStatus(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(back))
        searchController.searchBar.delegate = self
        mapView.delegate = self
        suggestionController.showResultMapDelegate = self
        definesPresentationContext = true
        showResultMapDelegate = self
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 28)
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
        let button = UIButton()
        gradientLayer.getGradientLayer(
            colors: UIColor().themeColors,
            alpha: 0.7,
            frame: self.view.bounds,
            startPoint: CGPoint(x: 0.0, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5)
        )
        let color = UIColor.gradientColor(bounds: self.view.bounds, gradientLayer: gradientLayer)
        button.backgroundColor = color
        button.defaultAction()
        button.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        return button
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        gradientLayer.getGradientLayer(
            colors: UIColor().themeColors,
            alpha: 0.7,
            frame: self.view.bounds,
            startPoint: CGPoint(x: 0.0, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5)
        )
        let color = UIColor.gradientColor(bounds: self.view.bounds, gradientLayer: gradientLayer)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = .clear
        button.defaultAction()
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    func setLocation(latitude: CGFloat, longitude: CGFloat) {
        let digit: Double = pow(10, 3)
        viewModel.placeLatitude = String(round(latitude * digit) / digit)
        viewModel.placeLongitude = String(round(longitude * digit) / digit)
    }
}

//MARK: Action
extension SetLocationViewController {
    @objc func goNext() {
        viewModel.setPlace()
        guard let destinationVC = self.destinationVC as? SetLocationViewController else {
            viewModel.createGroup {
                self.navigationController?.popToRootViewController(animated: true)
            }
            return
        }
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func skip() {
        guard let destinationVC = self.destinationVC as? SetLocationViewController else {
            viewModel.createGroup {
                self.navigationController?.popToRootViewController(animated: true)
            }
            return
        }
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func back() {
        if viewModel.place == "home" {
            viewModel.place = nil
        }
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Search Bar Delegate
extension SetLocationViewController: UISearchBarDelegate {
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
        showResultMapDelegate?.clearOverlay()
        guard let suggestion = suggestionController.completerResults, suggestion.count != 0 else {
            self.showAlert()
            return
        }
        //search(for: suggestion)
        showResultMapDelegate?.markAreaOverlay(result: suggestion[0])
        // The user tapped search on the `UISearchBar` or on the keyboard. Since they didn't
        // select a row with a suggested completion, run the search with the query text in the search field.
    }
}

extension SetLocationViewController: ShowResultMap {
    func markAreaOverlay(result: MKLocalSearchCompletion) {
        searchController.isActive = false
        searchController.searchBar.text = result.title
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
            self.setLocation(latitude: lat, longitude: long)
            let loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let circle = MKCircle(center: loc, radius: 200)
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            self.mapView.setRegion(MKCoordinateRegion(center: loc, span: span), animated: true)
            self.mapView.addOverlay(circle)
            self.nextButton.enableStatus(true)
        }
    }
    
    func clearOverlay() {
        mapView.removeOverlays(mapView.overlays)
    }
}

extension SetLocationViewController: MKMapViewDelegate {
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

extension SetLocationViewController {
    func showAlert() {
        let alert = UIAlertController(title: "No Result", message: nil, preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okay)
        present(alert, animated: true) {
            self.nextButton.enableStatus(false)
        }
    }
}
