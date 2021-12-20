//
//  NetworkTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/11/2021.
//

import Foundation

// MARK: - Common Types

typealias DataResult = Result<Data,NetworkError>

enum HTTPMethod: String {
    case GET
    case HEAD
    case POST
    case PUT
    case DELETE
    case CONNECT
    case OPTIONS
    case TRACE
    case PATCH
}

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
    case client(Error)
    case server(HTTPError)
    case api(APIError)
    case decoding(Error)
    case encoding(Error)
}

extension NetworkError {
    init?(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            self = .client(error)
            return
        }

        if let response = response as? HTTPURLResponse,
            !(200...299).contains(response.statusCode) {
            self = .server(HTTPError.withCode(response.statusCode))
            return
        } else { self = .noResponse }
        
        if data == nil {
            self = .noData
        }
        
        return nil
    }
    
    init?(response: URLResponse?, error: Error?) {
        if let error = error {
            self = .client(error)
            return
        }

        if let response = response as? HTTPURLResponse,
            !(200...299).contains(response.statusCode) {
            self = .server(HTTPError.withCode(response.statusCode))
            return
        } else { self = .noResponse }
        
        return nil
    }
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

