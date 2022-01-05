//
//  UsersGroups.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/24.
//

import Foundation

class UsersGroups {
    
    static let shared = UsersGroups()
    init() { }
    
    var groups: [Group]?
   
    func loadGroups(completion: @escaping () -> Void) {
        //TODO: API Service
        GroupAPIService().performLoadGroups { [weak self] _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
   
    //MARK: VM for add new one
    var newGroup: Group? = nil
    var place: String? = nil
    var placeLatitude: String? = nil
    var placeLongitude: String? = nil
    
    func setPlace() {
        newGroup?.places.append(Place(place: place!, latitude: placeLatitude, longitude: placeLongitude))
    }
    
    func createGroup(completion: @escaping () -> Void) {
        GroupAPIService().performAddGroup(group: newGroup!) { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func removeGroup() {
        //TODO: Complete API
    }
}
