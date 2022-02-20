//
//  NetworkReachabilityHelper.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/11/2021.
//

import Foundation
import Alamofire

class NetworkReachabilityHelper {
    
    let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    var isReachable: Bool? { return reachabilityManager?.isReachable }
    
    init() {
        startNetworkMonitoring()
    }
    
    func startNetworkMonitoring() {
        reachabilityManager?.startListening { status in
            switch status {
            case .reachable: AlertHelper.dismissStatusBarBanner()
            case .notReachable: AlertHelper.showStatusBarBanner(alert: .noInternet)
            default: break
            }
        }
    }
    
}
