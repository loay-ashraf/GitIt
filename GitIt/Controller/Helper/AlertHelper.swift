//
//  AlertHelper.swift
//  GitIt
//
//  Created by Loay Ashraf on 01/01/2022.
//

import UIKit

class AlertHelper {
    
    class func showAlert(title: String, message: String, style: UIAlertController.Style, actions: [UIAlertAction]) {
        var rootViewController = UIApplication.shared.windows.first!.rootViewController
        while let presentedViewController = rootViewController?.presentedViewController {
            rootViewController = presentedViewController
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions { alertController.addAction(action) }
        
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlert(with alertController: UIAlertController, actions: [UIAlertAction]) {
        var rootViewController = UIApplication.shared.windows.first!.rootViewController
        while let presentedViewController = rootViewController?.presentedViewController {
            rootViewController = presentedViewController
        }
        
        for action in actions { alertController.addAction(action) }
        
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlert(with alertController: UIAlertController) {
        var rootViewController = UIApplication.shared.windows.first!.rootViewController
        while let presentedViewController = rootViewController?.presentedViewController {
            rootViewController = presentedViewController
        }
        
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlert(alert: Alert) {
        var rootViewController = UIApplication.shared.windows.first!.rootViewController
        while let presentedViewController = rootViewController?.presentedViewController {
            rootViewController = presentedViewController
        }
        
        let alertController = alert.controller
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}

