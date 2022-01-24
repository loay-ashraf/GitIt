//
//  AlertHelper.swift
//  GitIt
//
//  Created by Loay Ashraf on 01/01/2022.
//

import UIKit

class AlertHelper {
    
    static var presentedAlertController: UIAlertController!
    
    class func showAlert(title: String, message: String, style: UIAlertController.Style, actions: [UIAlertAction]) {
        let topViewController = UIApplication.topViewController()
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions { alertController.addAction(action) }
        
        presentedAlertController = alertController
        topViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlert(with alertController: UIAlertController, actions: [UIAlertAction]) {
        let topViewController = UIApplication.topViewController()
        
        for action in actions { alertController.addAction(action) }
        
        presentedAlertController = alertController
        topViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlert(with alertController: UIAlertController) {
        let topViewController = UIApplication.topViewController()
        
        presentedAlertController = alertController
        topViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlert(alert: Alert) {
        let topViewController = UIApplication.topViewController()
        
        let alertController = alert.controller
        presentedAlertController = alertController
        topViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func dismissAlert() {
        presentedAlertController?.dismiss(animated: true, completion: nil)
        presentedAlertController = nil
    }
    
}

