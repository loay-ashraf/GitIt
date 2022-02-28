//
//  AlertTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/02/2022.
//

import UIKit
import NotificationBannerSwift

enum Alert {
    
    case noInternet
    case internetError
    case networkError
    case dataError
    case signInError
    case guestSignIn(() -> Void)
    case clearSearchHistory(() -> Void)
    case clearBookmarks(() -> Void)
    case clearData
    case signOut(() -> Void)
    
    var controller: UIAlertController {
        switch self {
        case .internetError: return AlertConstants.InternetError.alertController()
        case .networkError: return AlertConstants.NetworkError.alertController()
        case .dataError: return AlertConstants.DataError.alertController()
        case .signInError: return AlertConstants.SignInError.alertController()
        case .guestSignIn(let handler): return AlertConstants.GuestSignIn.alertController(with: handler)
        case .clearSearchHistory(let handler): return AlertConstants.ClearSearchHistory.alertController(with: handler)
        case .clearBookmarks(let handler): return AlertConstants.ClearBookmarks.alertController(with: handler)
        case .clearData: return AlertConstants.ClearData.alertController()
        case .signOut(let handler): return AlertConstants.SignOut.alertController(with: handler)
        default: return UIAlertController()
        }
    }
    
    var statusBarBanner: StatusBarNotificationBanner {
        switch self {
        case .noInternet: return AlertConstants.NoInternet.notificationBanner()
        default: return StatusBarNotificationBanner(title: "")
        }
    }
    
}
