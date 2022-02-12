//
//  Constants.swift
//  Weasley
//
//  Created by Doyoung on 2022/02/01.
//

import Foundation

/// - Tag: System image constants
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

/// - Tag: URL constants
enum WeasleyURL {
    case login
    case refreshToken
    case location
    case group
    
    var urlString: String {
        switch self {
        case .login:
            return "\(url)/login-process"
        case .refreshToken:
            return "\(url)/refresh-token"
        case .location:
            return "\(url)/api/weasley"
        case .group:
            return "\(url)/api/band"
        }
    }
}
