//
//  URLSession.swift
//  GitIt
//
//  Created by Loay Ashraf on 19/12/2021.
//

import Foundation

extension URLSession {
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (NetworkError?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completionHandler(NetworkError(response: response, error: error))
            }
        }
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (DataResult) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: request) { data, response, error in
            if let networkError = NetworkError(data: data, response: response, error: error) {
                DispatchQueue.main.async {
                    completionHandler(.failure(networkError))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(.success(data!))
            }
        }
    }
    
}
