//
//  URLHelper.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/11/2021.
//

import UIKit
import SafariServices

class URLHelper {
    
    // MARK: - Properties
    
    static let sharedApplication: UIApplication = UIApplication.shared
    static var safariConfiguration: SFSafariViewController.Configuration = {
        let safariConfiguration  = SFSafariViewController.Configuration()
        safariConfiguration.barCollapsingEnabled = false
        safariConfiguration.entersReaderIfAvailable = false
        return safariConfiguration
    }()
    
    // MARK: - Initialization
    
    private init() { }
    
    // MARK: - Website Methods
    
    class func openWebsite(_ url: URL) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if urlComponents?.scheme == nil { urlComponents?.scheme = "https"}
        let webURL = urlComponents?.url
        let safariVC = SFSafariViewController(url: webURL!, configuration: safariConfiguration)
        safariVC.dismissButtonStyle = .close
        safariVC.preferredBarTintColor = UIColor(named: "AccentColor")
        safariVC.preferredControlTintColor = .white
        NavigationRouter.present(viewController: safariVC)
    }
    
    class func shareWebsite(_ url: URL) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if urlComponents?.scheme == nil { urlComponents?.scheme = "https" }
        let webURL = urlComponents?.url
        
        let items = [webURL]
        let shareView = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        shareView.excludedActivityTypes = [.assignToContact, .print, .saveToCameraRoll, .addToReadingList]
        NavigationRouter.present(viewController: shareView)
    }
    
    // MARK: - Apps Methods
    
    class func openMail(_ mailAddress: String) {
        if let mailAppURL = URL(string: "mailto://" + mailAddress), sharedApplication.canOpenURL(mailAppURL) {
            sharedApplication.open(mailAppURL)
        }
    }
    
    class func openTwitter(_ twitterUserName: String) {
        if let appURL = URL(string: "twitter://user?screen_name=" + twitterUserName), sharedApplication.canOpenURL(appURL) {
            sharedApplication.open(appURL)
        } else if let webURL = URL(string: "https://twitter.com/" + twitterUserName) {
            openWebsite(webURL)
        }
    }
    
}
