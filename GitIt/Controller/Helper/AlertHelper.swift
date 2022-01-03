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
        
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions { alertViewController.addAction(action) }
        
        rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
}

