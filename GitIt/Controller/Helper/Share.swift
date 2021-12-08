//
//  Share.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/11/2021.
//

import Foundation
import UIKit
import SafariServices

func share(_ url: URL) {
    var rootViewController = UIApplication.shared.windows.first!.rootViewController
    while let presentedViewController = rootViewController?.presentedViewController {
        rootViewController = presentedViewController
    }
    
    let items = [url]
    let shareView = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
    shareView.excludedActivityTypes = [.assignToContact, .print, .saveToCameraRoll, .addToReadingList]
    rootViewController!.present(shareView, animated: true, completion: nil)
}

func openURL(_ url: URL) {
    var rootViewController = UIApplication.shared.windows.first!.rootViewController
    while let presentedViewController = rootViewController?.presentedViewController {
        rootViewController = presentedViewController
    }
    
    let safariConfiguration  = SFSafariViewController.Configuration()
    safariConfiguration.barCollapsingEnabled = false
    safariConfiguration.entersReaderIfAvailable = false
    let safraiVC = SFSafariViewController(url: url, configuration: safariConfiguration)
    safraiVC.dismissButtonStyle = .close
    rootViewController!.present(safraiVC, animated: true, completion: nil)
}

func formatPoints(num: Double) -> String{
    let thousandNum = num/1000
    let millionNum = num/1000000
    if num >= 1000 && num < 1000000{
        if(floor(thousandNum) == thousandNum){
            return("\(Int(thousandNum))K")
        }
        return("\(String(format: "%.1f", thousandNum))K")
    }
    if num > 1000000{
        if(floor(millionNum) == millionNum){
            return("\(Int(thousandNum))K")
        }
        return ("\(String(format: "%.1f", millionNum))M")
    }
    else{
        if(floor(num) == num){
            return ("\(Int(num))")
        }
        return ("\(num)")
    }
}
