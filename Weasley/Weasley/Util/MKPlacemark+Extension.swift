//
//  MKPlacemark+Extension.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/15.
//

import MapKit
import Contacts

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}
