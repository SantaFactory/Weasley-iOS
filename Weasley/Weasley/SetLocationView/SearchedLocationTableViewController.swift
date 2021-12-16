//
//  SuggestionsTableViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/15.
//

import UIKit
import MapKit

class SearchedLocationTableViewController: UITableViewController {

    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    private var currentPlacemark: CLPlacemark?
    
    var completerResults: [MKLocalSearchCompletion]?
    var showResultMapDelegate: ShowResultMap? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchedLocationTableViewCell.self, forCellReuseIdentifier: SearchedLocationTableViewCell.reuseID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startProvidingCompletions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopProvidingCompletions()
    }
    
    private func startProvidingCompletions() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .pointOfInterest
        searchCompleter?.region = searchRegion
    }
    
    private func stopProvidingCompletions() {
        searchCompleter = nil
    }
    
    func updatePlacemark(_ placemark: CLPlacemark?, boundingRegion: MKCoordinateRegion) {
        currentPlacemark = placemark
        searchCompleter?.region = searchRegion
    }
}

//MARK: Table View Data Source
extension SearchedLocationTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completerResults?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchedLocationTableViewCell.reuseID, for: indexPath)

        if let suggestion = completerResults?[indexPath.row] {
            cell.textLabel?.text = suggestion.title
            cell.detailTextLabel?.text = suggestion.subtitle
        }

        return cell
    }
    
}

//MARK: Table View Delegate
extension SearchedLocationTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selected = completerResults?[indexPath.row] else {
            return
        }
        showResultMapDelegate?.clearOverlay()
        showResultMapDelegate?.markAreaOverlay(result: selected)
        dismiss(animated: true, completion: nil)
    }
}

extension SearchedLocationTableViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }
}

extension SearchedLocationTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter?.queryFragment = searchController.searchBar.text ?? ""
    }
}

//MARK: Table View Cell
private class SearchedLocationTableViewCell: UITableViewCell {
    
    static let reuseID = "SearchedLocationTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
