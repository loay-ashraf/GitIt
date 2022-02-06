//
//  AlertHelper.swift
//  GitIt
//
//  Created by Loay Ashraf on 01/01/2022.
//

import UIKit
import NotificationBannerSwift

class AlertHelper {
    
    // MARK: - Properties
    
    static var presentedStatusBarBanner: StatusBarNotificationBanner!
    static var presentedAlertController: UIAlertController!
    
    // MARK: - Initialization
    
    private init() { }
    
    // MARK: - Show Methods
    
    class func showStatusBarBanner(alert: Alert) {
        let statusBarBanner = alert.statusBarBanner
        presentedStatusBarBanner = statusBarBanner
        statusBarBanner.show()
    }
    
    class func showAlert(title: String, message: String, style: UIAlertController.Style, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions { alertController.addAction(action) }
        
        presentedAlertController = alertController
        NavigationRouter.present(viewController: alertController)
    }
    
    class func showAlert(with alertController: UIAlertController, actions: [UIAlertAction]) {
        for action in actions { alertController.addAction(action) }
        
        presentedAlertController = alertController
        NavigationRouter.present(viewController: alertController)
    }
    
    class func showAlert(with alertController: UIAlertController) {
        presentedAlertController = alertController
        NavigationRouter.present(viewController: alertController)
    }
    
    class func showAlert(alert: Alert) {
        let alertController = alert.controller
        presentedAlertController = alertController
        NavigationRouter.present(viewController: alertController)
    }
    
    // MARK: - Dismiss Methods
    
    class func dismissStatusBarBanner() {
        presentedStatusBarBanner?.dismiss()
        presentedStatusBarBanner = nil
    }
    
    class func dismissAlert() {
        presentedAlertController?.dismiss(animated: true, completion: nil)
        presentedAlertController = nil
    }
    
}

