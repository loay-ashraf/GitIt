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
    
    static var safariConfiguration: SFSafariViewController.Configuration = {
        let safariConfiguration  = SFSafariViewController.Configuration()
        safariConfiguration.barCollapsingEnabled = false
        safariConfiguration.entersReaderIfAvailable = false
        return safariConfiguration
    }()
    
    class func openURL(_ url: URL) {
        let topViewController = UIApplication.topViewController()
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if urlComponents?.scheme == nil { urlComponents?.scheme = "https" }
        let webURL = urlComponents?.url
        
        let safariVC = SFSafariViewController(url: webURL!, configuration: safariConfiguration)
        safariVC.dismissButtonStyle = .close
        safariVC.preferredBarTintColor = UIColor(named: "AccentColor")
        safariVC.preferredControlTintColor = .white
        topViewController?.present(safariVC, animated: true, completion: nil)
    }

    class func shareURL(_ url: URL) {
        let topViewController = UIApplication.topViewController()
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if urlComponents?.scheme == nil { urlComponents?.scheme = "https" }
        let webURL = urlComponents?.url
        
        let items = [webURL]
        let shareView = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        shareView.excludedActivityTypes = [.assignToContact, .print, .saveToCameraRoll, .addToReadingList]
        topViewController?.present(shareView, animated: true, completion: nil)
    }
    
}
