//
//  NetworkProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/02/2022.
//

import Foundation

protocol WebServiceClient {
    
    var networkManager: NetworkManager { get }
    
    init()
    
}

extension WebServiceClient {
    
    // MARK: - Properties
    
    var networkManager: NetworkManager { return NetworkManager.standard }
    
    // MARK: - Initializer
    
    init() {
        self.init()
    }
    
}
