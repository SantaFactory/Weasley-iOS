//
//  CurrentLocations.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/10.
//

import Foundation

class CurrentLocations {
    
    static var share = CurrentLocations()
    init() {    }
    var groupMembers = [Member(user: UserInfo(sub: "111"), currentLoction: .lost)] //MARK: Sample Data
    let currentUser = UserDefaults.standard.string(forKey: "userLogin") ?? ""
    lazy var currentMember = groupMembers.first {
        $0.user.sub == currentUser
    }
    
    //MARK: 위치 전송
    func postLocation(latitude: String, longitude: String, completion: @escaping () -> Void) {
        APIManager().performPostLocation(coordinate: UserLocCoordinate(sub: currentUser, lat: latitude, long: longitude)) { res in
            print(res)
        }
    }
    
    //MARK: 위치 등록
    func setLocation(loc: String, latitude: String, longitude: String, completion: @escaping (SaveRes) -> Void) {
        APIManager().performSetLocation(loc: UserLoc(sub: currentUser, status: loc, lat: latitude, long: longitude)) { res in
            switch res {
            case .success:
                do {
                    let result = try res.get()
                    DispatchQueue.main.async {
                        completion(result)
                    }
                } catch {
                    print("Error retrieving the value: \(error)")
                }
            case .failure:
                print("Error")
            }
        }
    }
    
    //TODO: 맴버들 가져오기
    func getMember() {
    
    }
    //TODO: 맴버들 위치 가져오기
    
}
