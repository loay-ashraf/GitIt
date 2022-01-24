//
//  NetworkRequestInterceptor.swift
//  GitIt
//
//  Created by Loay Ashraf on 24/01/2022.
//

import Foundation
import Alamofire

class NetworkRequestInterceptor: RequestInterceptor {
  
    let retryLimit = 5
    let retryDelay: TimeInterval = 10
  
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let token = SessionManager.standard.sessionToken {
            urlRequest.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
  
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        //Retry for 5xx status codes
        if let statusCode = response?.statusCode, (500...599).contains(statusCode), request.retryCount < retryLimit {
            completion(.retryWithDelay(retryDelay))
        } else {
            return completion(.doNotRetry)
        }
    }
    
}
