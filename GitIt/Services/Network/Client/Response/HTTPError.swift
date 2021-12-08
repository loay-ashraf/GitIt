//
//  HTTPError.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/11/2021.
//

import Foundation

enum HTTPError: Error {
    
    case withCode(Int)
    
}

extension HTTPError: LocalizedError {
    public var errorDescription: String? {
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
