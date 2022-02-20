//
//  ViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/02/2022.
//

import Foundation

// MARK: - Protocol Definition

protocol WebServiceViewModel: AnyObject {
    
    associatedtype WebServiceLogicControllerType: WebServiceLogicController
    
    var logicController: WebServiceLogicControllerType { get }
    var handler: NetworkLoadingHandler? { get set }

    init()
    
    func reset()
    func processFetchError(networkError: NetworkError?)
    func synchronize()
    
}

protocol WebServiceDetailViewModel: AnyObject {
    
    associatedtype WebServiceLogicControllerType: WebServiceDetailLogicController
    
    var logicController: WebServiceLogicControllerType { get }
    var handler: NetworkLoadingHandler? { get set }

    init()
    init(withParameter parameter: String)
    
    func load(then handler: @escaping NetworkLoadingHandler)
    func checkForStatus()
    func processFetchError(networkError: NetworkError?)
    func synchronize()
    
}


protocol WebServicePlainViewModel: WebServiceViewModel where WebServiceLogicControllerType: WebServicePlainLogicController {
    
    func load(then handler: @escaping NetworkLoadingHandler)
    func refresh(then handler: @escaping NetworkLoadingHandler)
    func paginate(then handler: @escaping NetworkLoadingHandler)
    
}

protocol WebServiceSearchViewModel: WebServiceViewModel where WebServiceLogicControllerType: WebServiceSearchLogicController {
    
    func search(withQuery query: String, then handler: @escaping NetworkLoadingHandler)
    func refresh(then handler: @escaping NetworkLoadingHandler)
    func paginate(then handler: @escaping NetworkLoadingHandler)
    
}

// MARK: - Protocol Extensions

extension WebServiceViewModel {
    
    // MARK: - Initialization
    
    init() {
        self.init()
    }
    
    // MARK: - Reset Method
    
    func reset() {
        logicController.resetData()
        synchronize()
    }
    
    // MARK: - Fetch Error Processing Methods
    
    func processFetchError(networkError: NetworkError?) {
        if let networkError = networkError {
            handler?(networkError)
        } else {
            synchronize()
            handler?(nil)
        }
    }
    
}

extension WebServiceDetailViewModel {
    
    // MARK: - Initialization
    
    init() {
        self.init()
    }
    
    // MARK: - Load Method
    
    func load(then handler: @escaping NetworkLoadingHandler) {
        self.handler = handler
        logicController.load(then: processFetchError(networkError:))
    }
    
    // MARK: - Fetch Error Processing Methods
    
    func processFetchError(networkError: NetworkError?) {
        if let networkError = networkError {
            handler?(networkError)
        } else {
            synchronize()
            checkForStatus()
        }
    }
    
}

extension WebServicePlainViewModel {
    
    // MARK: - Load, Refresh and Paginate methods
    
    func load(then handler: @escaping NetworkLoadingHandler) {
        self.handler = handler
        logicController.load(then: processFetchError(networkError:))
    }
    
    func refresh(then handler: @escaping NetworkLoadingHandler) {
        self.handler = handler
        logicController.refresh(then: processFetchError(networkError:))
    }
    
    func paginate(then handler: @escaping NetworkLoadingHandler) {
        self.handler = handler
        logicController.paginate(then: processFetchError(networkError:))
    }
    
}

extension WebServiceSearchViewModel {
    
    // MARK: - Search, Refresh and Paginate methods
    
    func search(withQuery query: String, then handler: @escaping NetworkLoadingHandler) {
        self.handler = handler
        logicController.search(withQuery: query, then: processFetchError(networkError:))
    }
    
    func refresh(then handler: @escaping NetworkLoadingHandler) {
        self.handler = handler
        logicController.refresh(then: processFetchError(networkError:))
    }
    
    func paginate(then handler: @escaping NetworkLoadingHandler) {
        self.handler = handler
        logicController.paginate(then: processFetchError(networkError:))
    }
    
}
