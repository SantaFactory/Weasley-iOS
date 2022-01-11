//
//  AppDelegate.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/25.
//

import UIKit
import Firebase
import GoogleSignIn
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let locationManager = CLLocationManager()
    var userLatitude: String?
    var userLongitude: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        locationManager.delegate = self
        return true
    }
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        print(GIDSignIn.sharedInstance.handle(url))
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let digit: Double = pow(10, 3)
            let lat = String(round(location.coordinate.latitude * digit) / digit)
            let long = String(round(location.coordinate.longitude * digit) / digit)
            if lat != userLatitude || long != userLongitude {
                userLatitude = lat
                userLongitude = long
                let location = UserLocationCoordinate(latitude: Double(userLatitude!)!, longitude: Double(userLongitude!)!)
                LocationAPIService().performPutLocation(currentLocation: location)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Cancel Location")
        print("Error: \(error.localizedDescription)")
    }
}

