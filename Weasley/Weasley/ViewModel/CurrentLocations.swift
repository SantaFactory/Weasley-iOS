//
//  CurrentLocations.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/10.
//

import Foundation

class CurrentLocations {
    
    let share = CurrentLocations()
    init() {    }
    var groupMembers = [Member]()
    let currentUser: UserInfo = UserDefaults.standard.object(forKey: "userLogin") as! UserInfo
    
    // 사용자 위치 업데이트하기
    func getLocation(latitude: String, longitude: String, completion: @escaping () -> Void) {
        APIManager().performGetLocation(lat: latitude, long: longitude) { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    //TODO: 맴버들 가져오기
    func getMember() {
    
    }
    //TODO: 맴버들 위치 가져오기
    
}
