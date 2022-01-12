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
    
    var groups: [GroupData]?
   
    func loadGroups(completion: @escaping () -> Void) {
        //TODO: API Service
        GroupAPIService().performLoadGroups { [weak self] data in
            switch data {
            case .success:
                do {
                    let value = try data.get()
                    self?.groups = value.groupData
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Error retrieving the value: \(error.localizedDescription)")
                }
            case .failure:
                print("Fail load groups")
            }
        }
    }
   
    //MARK: VM for add new one
    var newGroup: Group? = nil
    var place: String? = nil
    var placeLatitude: String? = nil
    var placeLongitude: String? = nil
    
    func setPlace() {
        if newGroup == nil || newGroup!.places.filter({ $0.place == self.place}).isEmpty {
            newGroup?.places.append(Place(place: place!, latitude: placeLatitude, longitude: placeLongitude))
        } else {
            let index = newGroup!.places.firstIndex {
                $0.place == self.place
            }
            newGroup!.places.remove(at: index!)
            newGroup?.places.append(Place(place: place!, latitude: placeLatitude, longitude: placeLongitude))
        }
    }
    
    func createGroup(completion: @escaping () -> Void) {
        GroupAPIService().performAddGroup(group: newGroup!) { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func deleteGroup(groupID: Int, completion: @escaping () -> Void) {
        GroupAPIService().performDeleteGroup(id: groupID) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
