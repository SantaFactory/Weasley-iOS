//
//  GroupDetail.swift
//  Weasley
//
//  Created by Doyoung on 2022/01/11.
//

import Foundation

class Detail {
    
    var groupData: GroupData?
    
    lazy var groupName: String = {
        return groupData!.name
    }()
    
    lazy var groupID: Int = {
        return groupData!.id
    }()
    
    var members: [DumpMember]?
    
    struct DumpMember {
        let id:Int
        let name: String
        let currentPlace: Location
        let latitude: Double
        let longitude: Double
    }
    
    func loadGroupDetail(completion: @escaping() -> Void) {
        GroupAPIService().performLoadGroupDetail(id: groupID) { [weak self] data in
            switch data {
            case .success(let detail):
                //self?.members = detail.data.members
                DispatchQueue.main.async {
                    completion()
                }
            case .failure:
                print("Error")
            }
        }
    }
    
    func loadMembers() {
        GroupAPIService().performLoadMembers(id: groupID) {
            DispatchQueue.main.async {
               print("Success Load!")
            }
        }
    }
    
    init(group data: GroupData) {
        self.groupData = data
        self.members = [DumpMember(id: 1, name: "iDoyoung", currentPlace: .work, latitude: 37.256634401328036, longitude: 127.0610867098238)]
    }
    //TODO: Member Place
    //TODO: Invite Member
}
