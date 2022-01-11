//
//  LocationAPIService.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/24.
//

import Foundation

class LocationAPIService {
    
    let locationURL = "\(url)/api/weasley"
    
    func performUpdateLocation(currentLocation: UserLocationCoordinate) {
        guard let url = URL(string: locationURL) else {
            return
        }
        let resource = Resource<String>(url: url, method: .put(currentLocation), header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, _ in
            guard let data = resultData else {
                return
            }
        }
    }
}
