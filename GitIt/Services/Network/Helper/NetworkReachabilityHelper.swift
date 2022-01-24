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
    
    init() {
        startNetworkMonitoring()
    }
    
    func startNetworkMonitoring() {
        reachabilityManager?.startListening { status in
            switch status {
            default: break
            }
        }
    }
    
}
