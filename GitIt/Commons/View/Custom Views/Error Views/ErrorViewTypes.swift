//
//  ErrorViewTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/02/2022.
//

import UIKit

struct ErrorViewModel {
    
    var image: UIImage?
    var title: String
    var message: String
    
    init(image: UIImage?, title: String, message: String) {
        self.image = image
        self.title = title
        self.message = message
    }
    
    init?(from error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .noResponse,.noData: self = ErrorConstants.Internet.viewModel
            case .client(SessionError.sessionTaskFailed(let sessionTaskError)): if (sessionTaskError as NSError).code == NSURLErrorNotConnectedToInternet {
                self = ErrorConstants.Internet.viewModel
            } else {
                self = ErrorConstants.Network.viewModel
            }
            case .client,.server,.api,.decoding,.encoding: self = ErrorConstants.Network.viewModel
            }
            return
        } else if error.self is DataError {
            self = ErrorConstants.Data.viewModel
            return
        }
        return nil
    }
    
}
