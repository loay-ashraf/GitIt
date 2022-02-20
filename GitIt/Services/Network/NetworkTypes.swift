//
//  NetworkTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/11/2021.
//

import Foundation
import Alamofire

// MARK: - Common Types

typealias NetworkLoadingHandler = (NetworkError?) -> Void
typealias DataResult = Result<Data,NetworkError>
typealias ResponseResult<T> = Result<T,NetworkError> where T: Decodable

// MARK: - Generic Response Types

struct BatchResponse<Response: Decodable>: Decodable {
    let count: Int
    let incompleteResults: Bool
    let items: [Response]
    
    enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Error Types

enum NetworkError: Error {
    case noResponse
    case noData
    case client(SessionError)
    case server(HTTPError)
    case api(APIError)
    case decoding(Error)
    case encoding(Error)
}

extension NetworkError {
    init?(response: URLResponse?, error: Error?) {
        // Check for client-side error
        if let error = error {
            self = .client(.other(error))
            return
        }
        // Check for server-side error
        if let response = response as? HTTPURLResponse,
            !(200...299).contains(response.statusCode) {
            self = .server(HTTPError.withCode(response.statusCode))
            return
        // Check for no Response error
        } else if response == nil {
            self = .noResponse
            return
        }
        
        return nil
    }
    
    init?(data: Data?, response: URLResponse?, error: Error?) {
        // Check for client-side error
        if let error = error {
            self = .client(.other(error))
            return
        }
        // Check for server-side error
        if let response = response as? HTTPURLResponse,
            !(200...299).contains(response.statusCode) {
            self = .server(HTTPError.withCode(response.statusCode))
            return
        // Check for no Response error
        } else if response == nil {
            self = .noResponse
            return
        }
        // Check for no Data error
        if data == nil {
            self = .noData
            return
        }
        
        return nil
    }
    
    init?(with afError: AFError?) {
        switch afError {
        case .explicitlyCancelled: self = .client(.requestCancelled)
        case .invalidURL(let url): self = .client(.invalidURL(url as! URL))
        case .responseValidationFailed(AFError.ResponseValidationFailureReason.dataFileNil): self = .noResponse
        case .responseValidationFailed(AFError.ResponseValidationFailureReason.unacceptableStatusCode(let code)): self = .server(HTTPError.withCode(code))
        case .responseSerializationFailed(AFError.ResponseSerializationFailureReason.inputFileNil): self = .noData
        case .responseSerializationFailed(AFError.ResponseSerializationFailureReason.decodingFailed(let error)): self = .decoding(error)
        case .sessionDeinitialized: self = .client(.sessionDeinitialized)
        case .sessionInvalidated(let error): self = .client(.sessionInvalidated(error))
        case .sessionTaskFailed(let error): self = .client(.sessionTaskFailed(error))
        case .urlRequestValidationFailed: self = .client(.urlRequestValidationFailed)
        case nil: return nil
        default: self = .client(.other(afError!))
        }
        return
    }
}

enum SessionError: Error {
    case invalidURL(URL)
    case requestCancelled
    case sessionDeinitialized
    case sessionInvalidated(Error?)
    case sessionTaskFailed(Error)
    case urlRequestValidationFailed
    case other(Error)
}

enum HTTPError: Error {
    case withCode(Int)
}

extension HTTPError: LocalizedError {
    public var localizedDescription: String? {
        switch self {
        case .withCode(let statusCode):
            switch statusCode {
                case 400: return NSLocalizedString("Bad Request", comment: "")
                case 401: return NSLocalizedString("Unauthorized", comment: "")
                case 402: return NSLocalizedString("Payment Required", comment: "")
                case 403: return NSLocalizedString("Forbidden", comment: "")
                case 404: return NSLocalizedString("Not Found", comment: "")
                case 405: return NSLocalizedString("Method Not Allowed", comment: "")
                case 406: return NSLocalizedString("Not Acceptable", comment: "")
                case 407: return NSLocalizedString("Proxy Authentication Required", comment: "")
                case 408: return NSLocalizedString("Request Timeout", comment: "")
                case 409: return NSLocalizedString("Conflict", comment: "")
                case 410: return NSLocalizedString("Gone", comment: "")
                default: return NSLocalizedString("Unrecognized Error", comment: "")
            }
        }
    }
}

struct APIError: Decodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

extension APIError: LocalizedError {
    var localizedDescription: String? { return message }
}

struct AccessToken: Decodable {
    
    let accessToken: String
    let scope: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
    
}

