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
    var groupMembers = [Member(user: UserInfo(sub: "111", email: "qwerty@apple.com"), currentLoction: .lost)] //MARK: Sample Data
//    let currentUser: UserInfo = UserDefaults.standard.object(forKey: "userLogin") as! UserInfo
    lazy var currentMember = groupMembers.first {
        $0.user.sub == "111"//currentUser.sub
    }
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
