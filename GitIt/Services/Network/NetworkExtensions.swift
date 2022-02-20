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
                requestModifier: RequestModifier? = nil,
                completionHandler: @escaping (NetworkError?) -> Void) -> DataRequest {
        
        return request(convertible,
                method: method,
                headers: headers,
                interceptor: interceptor,
                requestModifier: requestModifier).validate(statusCode: 200...299).response { response in
                    completionHandler(NetworkError(with: response.error))
                }.resume()
    }
    
    func request(_ convertible: URLConvertible,
                method: HTTPMethod,
                headers: HTTPHeaders? = nil,
                interceptor: RequestInterceptor? = nil,
                requestModifier: RequestModifier? = nil,
                completionHandler: @escaping (DataResult) -> Void) -> DataRequest {
        
        request(convertible,
                method: method,
                headers: headers,
                interceptor: interceptor,
                requestModifier: requestModifier).validate(statusCode: 200...299).responseData { response in
                    if let networkError = NetworkError(with: response.error) {
                        completionHandler(.failure(networkError))
                    } else if let items = response.value {
                        completionHandler(.success(items))
                    }
                }.resume()
    }
    
    func request<Response: Decodable>(_ convertible: URLConvertible,
                                      method: HTTPMethod,
                                      headers: HTTPHeaders? = nil,
                                      interceptor: RequestInterceptor? = nil,
                                      requestModifier: RequestModifier? = nil,
                                      completionHandler: @escaping (ResponseResult<Response>) -> Void) -> DataRequest {
        
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
                                completionHandler(.failure(.api(errorObject)))
                            }
                        } catch { completionHandler(.failure(.decoding(error))) }
                        default: completionHandler(.failure(networkError))
                        }
                    } else if let items = response.value {
                        completionHandler(.success(items))
                    }
                }.resume()
    }
    
    func request<Response: Decodable>(_ convertible: URLConvertible,
                                      method: HTTPMethod,
                                      parameters: Parameters? = nil,
                                      encoding: ParameterEncoding = URLEncoding.default,
                                      headers: HTTPHeaders? = nil,
                                      interceptor: RequestInterceptor? = nil,
                                      requestModifier: RequestModifier? = nil,
                                      completionHandler: @escaping (ResponseResult<Response>) -> Void) -> DataRequest {
        
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
                                completionHandler(.failure(.api(errorObject)))
                            }
                        } catch { completionHandler(.failure(.decoding(error))) }
                        default: completionHandler(.failure(networkError))
                        }
                    } else if let items = response.value {
                        completionHandler(.success(items))
                    }
                }.resume()
    }
    
    // MARK: - URL Request Convertible Methods
    
    func request(_ convertible: URLRequestConvertible,
                interceptor: RequestInterceptor? = nil,
                completionHandler: @escaping (NetworkError?) -> Void) -> DataRequest {
        
        request(convertible,
                interceptor: interceptor).validate(statusCode: 200...299).response { response in
                    completionHandler(NetworkError(with: response.error))
                }.resume()
    }
    
    func request(_ convertible: URLRequestConvertible,
                interceptor: RequestInterceptor? = nil,
                completionHandler: @escaping (DataResult) -> Void) -> DataRequest {
        
        request(convertible,
                interceptor: interceptor).validate(statusCode: 200...299).responseData { response in
                    if let networkError = NetworkError(with: response.error) {
                        completionHandler(.failure(networkError))
                    } else if let items = response.value {
                        completionHandler(.success(items))
                    }
                }.resume()
    }
    
    func request<Response: Decodable>(_ convertible: URLRequestConvertible,
                                      interceptor: RequestInterceptor? = nil,
                                      completionHandler: @escaping (ResponseResult<Response>) -> Void) -> DataRequest {
        request(convertible,
                interceptor: interceptor).validate(statusCode: 200...299).responseDecodable(of: Response.self) { response in
                    if let networkError = NetworkError(with: response.error) {
                        switch networkError {
                        case .decoding:
                        do {
                            if let data = response.data {
                                let errorObject = try JSONDecoder().decode(APIError.self, from: data)
                                completionHandler(.failure(.api(errorObject)))
                            }
                        } catch { completionHandler(.failure(.decoding(error))) }
                        default: completionHandler(.failure(networkError))
                        }
                    } else if let items = response.value {
                        completionHandler(.success(items))
                    }
                }.resume()
    }
    
}
