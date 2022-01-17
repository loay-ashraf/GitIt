//
//  URLHelper.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/11/2021.
//

import Foundation
import SafariServices
import UIKit

class URLHelper {
    
    class func openURL(_ url: URL) {
        var rootViewController = UIApplication.shared.windows.first!.rootViewController
        while let presentedViewController = rootViewController?.presentedViewController {
            rootViewController = presentedViewController
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if urlComponents?.scheme == nil { urlComponents?.scheme = "https" }
        let webURL = urlComponents?.url
        
        let safariConfiguration  = SFSafariViewController.Configuration()
        safariConfiguration.barCollapsingEnabled = false
        safariConfiguration.entersReaderIfAvailable = false
        let safariVC = SFSafariViewController(url: webURL!, configuration: safariConfiguration)
        safariVC.dismissButtonStyle = .close
        rootViewController?.present(safariVC, animated: true, completion: nil)
    }

    class func shareURL(_ url: URL) {
        var rootViewController = UIApplication.shared.windows.first!.rootViewController
        while let presentedViewController = rootViewController?.presentedViewController {
            rootViewController = presentedViewController
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if urlComponents?.scheme == nil { urlComponents?.scheme = "https" }
        let webURL = urlComponents?.url
        
        let items = [webURL]
        let shareView = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        shareView.excludedActivityTypes = [.assignToContact, .print, .saveToCameraRoll, .addToReadingList]
        rootViewController?.present(shareView, animated: true, completion: nil)
    }
    
}