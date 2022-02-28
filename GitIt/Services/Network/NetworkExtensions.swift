//
//  NetworkExtensions.swift
//  GitIt
//
//  Created by Loay Ashraf on 19/12/2021.
//

import Foundation
import Alamofire

extension Session {
    
    // MARK: - URL Convertible Methods
    
    func request(_ convertible: URLConvertible,
                method: HTTPMethod,
                headers: HTTPHeaders? = nil,
                interceptor: RequestInterceptor? = nil,
                requestModifier: RequestModifier? = nil) async -> NetworkError? {
        
        await withUnsafeContinuation { continuation in
            request(convertible,
                    method: method,
                    headers: headers,
                    interceptor: interceptor,
                    requestModifier: requestModifier).validate(statusCode: 200...299).response { response in
                        continuation.resume(returning: NetworkError(with: response.error))
                    }.resume()
        }
    }
    
    func request(_ convertible: URLConvertible,
                method: HTTPMethod,
                headers: HTTPHeaders? = nil,
                interceptor: RequestInterceptor? = nil,
                requestModifier: RequestModifier? = nil) async -> DataResult {
        
        await withUnsafeContinuation { continuation in
            request(convertible,
                    method: method,
                    headers: headers,
                    interceptor: interceptor,
                    requestModifier: requestModifier).validate(statusCode: 200...299).responseData { response in
                        if let networkError = NetworkError(with: response.error) {
                            continuation.resume(returning: .failure(networkError))
                        } else if let items = response.value {
                            continuation.resume(returning: .success(items))
                        }
                    }.resume()
        }
    }
    
    func request<Response: Decodable>(_ convertible: URLConvertible,
                                      method: HTTPMethod,
                                      headers: HTTPHeaders? = nil,
                                      interceptor: RequestInterceptor? = nil,
                                      requestModifier: RequestModifier? = nil) async -> ResponseResult<Response> {
        
        await withUnsafeContinuation { continuation in
            request(convertible,
                    method: method,
                    headers: headers,
                    interceptor: interceptor,
                    requestModifier: requestModifier).validate(statusCode: 200...299).responseDecodable(of: Response.self) { response in
                        if let networkError = NetworkError(with: response.error) {
                            switch networkError {
                            case .decoding:
                            do {
                                if let data = response.data {
                                    let errorObject = try JSONDecoder().decode(APIError.self, from: data)
                                    continuation.resume(returning: .failure(.api(errorObject)))
                                }
                            } catch { continuation.resume(returning: .failure(.decoding(error))) }
                            default: continuation.resume(returning: .failure(networkError))
                            }
                        } else if let items = response.value {
                            continuation.resume(returning: .success(items))
                        }
                    }.resume()
        }
    }
    
    func request<Response: Decodable>(_ convertible: URLConvertible,
                                      method: HTTPMethod,
                                      parameters: Parameters? = nil,
                                      encoding: ParameterEncoding = URLEncoding.default,
                                      headers: HTTPHeaders? = nil,
                                      interceptor: RequestInterceptor? = nil,
                                      requestModifier: RequestModifier? = nil) async -> ResponseResult<Response> {
        
        await withUnsafeContinuation { continuation in
            request(convertible,
                    method: method,
                    parameters: parameters,
                    encoding: encoding,
                    headers: headers,
                    interceptor: interceptor,
                    requestModifier: requestModifier).validate(statusCode: 200...299).responseDecodable(of: Response.self) { response in
                        if let networkError = NetworkError(with: response.error) {
                            switch networkError {
                            case .decoding:
                            do {
                                if let data = response.data {
                                    let errorObject = try JSONDecoder().decode(APIError.self, from: data)
                                    continuation.resume(returning: .failure(.api(errorObject)))
                                }
                            } catch { continuation.resume(returning: .failure(.decoding(error))) }
                            default: continuation.resume(returning: .failure(networkError))
                            }
                        } else if let items = response.value {
                            continuation.resume(returning: .success(items))
                        }
                    }.resume()
        }
    }
    
    // MARK: - URL Request Convertible Methods
    
    func request(_ convertible: URLRequestConvertible,
                interceptor: RequestInterceptor? = nil) async -> NetworkError? {
        
        await withUnsafeContinuation { continuation in
            request(convertible,
                    interceptor: interceptor).validate(statusCode: 200...299).response { response in
                        continuation.resume(returning: NetworkError(with: response.error))
                    }.resume()
        }
    }
    
    func request(_ convertible: URLRequestConvertible,
                interceptor: RequestInterceptor? = nil) async -> DataResult {
        
        await withUnsafeContinuation { continuation in
            request(convertible,
                    interceptor: interceptor).validate(statusCode: 200...299).responseData { response in
                        if let networkError = NetworkError(with: response.error) {
                            continuation.resume(returning: .failure(networkError))
                        } else if let items = response.value {
                            continuation.resume(returning: .success(items))
                        }
                    }.resume()
        }
    }
    
    func request<Response: Decodable>(_ convertible: URLRequestConvertible,
                                      interceptor: RequestInterceptor? = nil) async -> ResponseResult<Response> {
        
        await withUnsafeContinuation { continuation in
            request(convertible,
                    interceptor: interceptor).validate(statusCode: 200...299).responseDecodable(of: Response.self) { response in
                        if let networkError = NetworkError(with: response.error) {
                            switch networkError {
                            case .decoding:
                            do {
                                if let data = response.data {
                                    let errorObject = try JSONDecoder().decode(APIError.self, from: data)
                                    continuation.resume(returning: .failure(.api(errorObject)))
                                }
                            } catch { continuation.resume(returning: .failure(.decoding(error))) }
                            default: continuation.resume(returning: .failure(networkError))
                            }
                        } else if let items = response.value {
                            continuation.resume(returning: .success(items))
                        }
                    }.resume()
        }
    }
    
}
