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
    
//    // MARK: - GET Request Methods
//
//    func GETRequest(url: URL, completionHandler: @escaping (NetworkError?) -> Void) -> DataRequest {
//        urlSession.request(url, method: .get, completionHandler: completionHandler)
//    }
//
//    func GETRequest<Response: Decodable>(url: URL, completionHandler: @escaping (ResponseResult<Response>) -> Void) -> DataRequest {
//        urlSession.request(url, method: .get, completionHandler: completionHandler)
//    }
//
//    // MARK: - POST Request Methods
//
//    func POSTRequest(url: URL, completionHandler: @escaping (NetworkError?) -> Void) -> DataRequest {
//        urlSession.request(url, method: .post, completionHandler: completionHandler)
//    }
//
//    func POSTRequest<Response: Decodable>(url: URL, completionHandler: @escaping (ResponseResult<Response>) -> Void) -> DataRequest {
//        urlSession.request(url, method: .post, completionHandler: completionHandler)
//    }
//
//    func POSTRequest<Response: Decodable, Request: Encodable>(url: URL, body: Request, completionHandler: @escaping (ResponseResult<Response>) -> Void) -> DataRequest {
//        urlSession.request(url, method: .post, parameters: body as? Parameters, completionHandler: completionHandler)
//    }
//
//    // MARK: - PUT Request Methods
//
//    func PUTRequest(url: URL, completionHandler: @escaping (NetworkError?) -> Void) -> DataRequest {
//        urlSession.request(url, method: .put, completionHandler: completionHandler)
//    }
//
//    func PUTRequest<Response: Decodable>(url: URL, completionHandler: @escaping (ResponseResult<Response>) -> Void) -> DataRequest {
//        urlSession.request(url, method: .put, completionHandler: completionHandler)
//    }
//
//    func PUTRequest<Response: Decodable, Request: Encodable>(url: URL, body: Request, completionHandler: @escaping (ResponseResult<Response>) -> Void) -> DataRequest {
//        urlSession.request(url, method: .put, parameters: body as? Parameters, completionHandler: completionHandler)
//    }
//
//    // MARK: - DELETE Request Methods
//
//    func DELETERequest(url: URL, completionHandler: @escaping (NetworkError?) -> Void) -> DataRequest {
//        urlSession.request(url, method: .delete, completionHandler: completionHandler)
//    }
//
//    func DELETERequest<Response: Decodable>(url: URL, completionHandler: @escaping (ResponseResult<Response>) -> Void) -> DataRequest {
//        urlSession.request(url, method: .delete, completionHandler: completionHandler)
//    }
//
//    func DELETERequest<Response: Decodable, Request: Encodable>(url: URL, body: Request, completionHandler: @escaping (ResponseResult<Response>) -> Void) -> DataRequest {
//        urlSession.request(url, method: .delete, parameters: body as? Parameters, completionHandler: completionHandler)
//    }
    
}
