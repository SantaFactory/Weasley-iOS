//
//  GroupAddition.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/21.
//

import Foundation

class GroupAddition {
    
    var newGroup: Group
    
    func addGroup() {
        //TODO: Complete api
        GroupAPIService().performAddGroup(group: newGroup) { [weak self] _ in
            print(self!.newGroup)
        }
    }

    init(name: String) {
        newGroup = Group(name: name, places: [
            Place(place: "home", latitude: "", longitude: ""),
            Place(place: "school", latitude: "", longitude: ""),
            Place(place: "work", latitude: "", longitude: "")
        ])
    }
}
