//
//  NetworkManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/11/2021.
//

import Foundation
import Alamofire

class NetworkManager {
    
    // MARK: - Properties
    
    static let standard = NetworkManager()
    
    var isReachable: Bool {
        if let isReachable = reachabilityHelper.isReachable {
            return isReachable
        }
        return false
    }
    
    private let urlSession: Session!
    private let reachabilityHelper: NetworkReachabilityHelper!
    
    // MARK: - Initialization
    
    private init() {
        urlSession = {
            let configuration = URLSessionConfiguration.af.default
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            let responseCacher = ResponseCacher(behavior: .modify { _, response in
              let userInfo = ["date": Date()]
              return CachedURLResponse(
                response: response.response,
                data: response.data,
                userInfo: userInfo,
                storagePolicy: .allowed)
            })
            let interceptor = NetworkRequestInterceptor()
            let networkLogger = NetworkLogger()
            return Session(configuration: configuration, interceptor: interceptor, cachedResponseHandler: responseCacher, eventMonitors: [networkLogger])
        }()
        reachabilityHelper = NetworkReachabilityHelper()
    }
    
    // MARK: - Data Request Methods
    
    func dataRequest(request: URLRequestConvertible) async -> NetworkError? {
        await urlSession.request(request)
    }
    
    func dataRequest(request: URLRequestConvertible) async -> DataResult {
        await urlSession.request(request)
    }
    
    func dataRequest<Response: Decodable>(request: URLRequestConvertible) async -> ResponseResult<Response> {
        await urlSession.request(request)
    }
    
}
