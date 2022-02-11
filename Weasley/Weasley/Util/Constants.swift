//
//  Constants.swift
//  Weasley
//
//  Created by Doyoung on 2022/02/01.
//

import Foundation

enum SystemImage {
    case add
    case key
    case addFill
    case profile
    case delete
    case back
    case backFill
    case loction
    case invite
    case requestMessage
    case show
    
    var name: String {
        switch self {
        case .add:
            return "plus"
        case .key:
            return "key"
        case .addFill:
            return "plus.circle"
        case .profile:
            return "person.crop.circle"
        case .delete:
            return "trash"
        case .back:
            return "chevron.backward"
        case .backFill:
            return "chevron.backward.circle.fill"
        case .loction:
            return "location.circle.fill"
        case .invite:
            return "paperplane.fill"
        case .requestMessage:
            return "exclamationmark.bubble"
        case .show:
            return "binoculars.fill"
        }
    }
}
