//
//  ReachabilityHelper.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/11/2021.
//

import Foundation
import UIKit
import Network

class ReachabilityHelper {
    
    let wifiMonitor: NWPathMonitor!
    let cellularMonitor: NWPathMonitor!
    let ethernetMonitor: NWPathMonitor!
    let queue: DispatchQueue!
    
    var isWifiConnected: Bool = false
    var isCellularConnected: Bool = false
    var isEthernetConnected: Bool = false
    var isInternetConnected: Bool { return isWifiConnected || isCellularConnected || isEthernetConnected }
    
    init() {
        wifiMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
        cellularMonitor = NWPathMonitor(requiredInterfaceType: .cellular)
        ethernetMonitor = NWPathMonitor(requiredInterfaceType: .wiredEthernet)
        queue = DispatchQueue.global(qos: .background)
        setup()
    }

    private func setup() {
        wifiMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isWifiConnected = true
            } else {
                self.isWifiConnected = false
            }
        }
        cellularMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isCellularConnected = true
            } else {
                self.isCellularConnected = false
            }
        }
        ethernetMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isEthernetConnected = true
            } else {
                self.isEthernetConnected = false
            }
        }
        
        wifiMonitor.start(queue: queue)
        cellularMonitor.start(queue: queue)
        ethernetMonitor.start(queue: queue)
    }
    
    func presentNetworkReachabilityAlert(message: String, handler: ((UIAlertAction) -> Void)?) {
        var rootViewController = UIApplication.shared.windows.first!.rootViewController
        while let presentedViewController = rootViewController?.presentedViewController {
            rootViewController = presentedViewController
        }
        let alertController = UIAlertController(title: "Network Unavailable", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        rootViewController!.present(alertController, animated: true, completion: nil)
    }
    
}
