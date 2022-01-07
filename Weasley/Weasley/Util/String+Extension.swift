//
//  String+Extension.swift
//  Weasley
//
//  Created by Doyoung on 2022/01/07.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
