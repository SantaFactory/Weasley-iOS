//
//  GroupAddition.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/21.
//

import Foundation

class GroupAddition {
    
    var newGroup: Group
    var place: String
    var placeLatitude: String? = nil
    var placeLongitude: String? = nil
    
    func addGroup() {
        //TODO: Complete api
        GroupAPIService().performAddGroup(group: newGroup) { [weak self] _ in
            print(self!.newGroup)
        }
    }

    func setPlace() {
        switch place {
        case "Home":
            newGroup.places[0].latitude = placeLatitude
            newGroup.places[0].longitude = placeLongitude
        case "School":
            newGroup.places[1].latitude = placeLatitude
            newGroup.places[1].longitude = placeLongitude
        case "Work":
            newGroup.places[2].latitude = placeLatitude
            newGroup.places[2].longitude = placeLongitude
        default:
            print("Error")
        }
        placeLatitude = nil
        placeLongitude = nil
    }
    
    init(group name: String, set place: String) {
        self.place = place
        newGroup = Group(name: name, places: [
            Place(place: "home", latitude: nil, longitude: nil),
            Place(place: "school", latitude: nil, longitude: nil),
            Place(place: "work", latitude: nil, longitude: nil)
        ])
    }
}
