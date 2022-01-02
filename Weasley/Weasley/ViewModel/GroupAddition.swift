//
//  GroupAddition.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/21.
//

import Foundation

class GroupAddition {
    
    var newGroup: Group
    var place: String? = nil
    var placeLatitude: String? = nil
    var placeLongitude: String? = nil

    func setPlace() {
        switch place {
        case "home":
            newGroup.places[0].latitude = placeLatitude
            newGroup.places[0].longitude = placeLongitude
        case "school":
            newGroup.places[1].latitude = placeLatitude
            newGroup.places[1].longitude = placeLongitude
        case "work":
            newGroup.places[2].latitude = placeLatitude
            newGroup.places[2].longitude = placeLongitude
        default:
            print("Error")
        }
        placeLatitude = nil
        placeLongitude = nil
    }
    
    func createGroup(completion: @escaping () -> Void) {
        GroupAPIService().performAddGroup(group: newGroup) { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    init(group name: String) {
        newGroup = Group(name: name, places: [
            Place(place: "home", latitude: nil, longitude: nil),
            Place(place: "school", latitude: nil, longitude: nil),
            Place(place: "work", latitude: nil, longitude: nil)
        ])
        print("Init")
    }
    
    deinit {
        print("Deinit GroupAddition")
    }
}
