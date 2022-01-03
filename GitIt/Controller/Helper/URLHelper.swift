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
        let safraiVC = SFSafariViewController(url: webURL!, configuration: safariConfiguration)
        safraiVC.dismissButtonStyle = .close
        rootViewController?.present(safraiVC, animated: true, completion: nil)
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

func formatPoints(num: Double) -> String{
    let thousandNum = num/1000
    let millionNum = num/1000000
    if num >= 1000 && num < 1000000{
        if(thousandNum.truncatingRemainder(dividingBy: 1) < 0.1){
            return("\(Int(thousandNum))K")
        }
        return("\(thousandNum.truncate(places: 1))K")
    }
    if num > 1000000{
        if(millionNum.truncatingRemainder(dividingBy: 1) < 0.1){
            return("\(Int(thousandNum))M")
        }
        return("\(millionNum.truncate(places: 1))M")
    }
    else{
        if(num.truncatingRemainder(dividingBy: 1) < 0.1){
            return ("\(Int(num))")
        }
        return ("\(num)")
    }
}

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
