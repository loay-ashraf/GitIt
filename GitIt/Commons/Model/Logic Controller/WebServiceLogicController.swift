//
//  WebServiceLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/02/2022.
//

import Foundation

// MARK: - Protocol Definition

protocol WebServiceLogicController: AnyObject {
    
    associatedtype WebServiceClientType: WebServiceClient
    associatedtype ModelType: Model
    
    var webServiceClient: WebServiceClientType { get }
    var model: List<ModelType> { get set }
    var handler: NetworkLoadingHandler? { get set }
    var maxItemCount: Int? { get }
    var maxPageCount: Int { get }
    
    init()
    init(maxItemCount: Int?, maxPageCount: Int)
    
    func fetchData()
    func resetData()
    func processFetchResult(result: Result<Array<ModelType>, NetworkError>)
    func updatePaginability(newItemsCount: Int)
    
}

protocol WebServiceDetailLogicController: AnyObject {
    
    associatedtype WebServiceClientType: WebServiceClient
    associatedtype ModelType: Model
    
    var webServiceClient: WebServiceClientType { get }
    var model: ModelType { get set }
    var parameter: String { get set }
    var handler: NetworkLoadingHandler? { get set }
    
    init()
    init(withParameter parameter: String)
    
    func load(then handler: @escaping NetworkLoadingHandler)
    func fetchData()
    func checkForStatus(then handler: @escaping ([Bool]) -> Void)
    func processFetchResult(result: Result<ModelType, NetworkError>)
    
}

protocol WebServicePlainLogicController: WebServiceLogicController {

    func load(then handler: @escaping NetworkLoadingHandler)
    func refresh(then handler: @escaping NetworkLoadingHandler)
    func paginate(then handler: @escaping NetworkLoadingHandler)

}

protocol WebServiceSearchLogicController: WebServiceLogicController {
    
    var query: String { get set }
    
    func search(withQuery query: String, then handler: @escaping NetworkLoadingHandler)
    func refresh(then handler: @escaping NetworkLoadingHandler)
    func paginate(then handler: @escaping NetworkLoadingHandler)
    
}

// MARK: - Protocol Extensions

extension WebServiceLogicController {
    
    // MARK: - Initialization
    
    init() {
        self.init(maxItemCount: nil, maxPageCount: 0)
        model.isPaginable = true
    }
    
    // MARK: - Reset Method
    
    func resetData() {
        model.reset(isPagiable: true)
    }
    
    // MARK: - Fetch Result Processing Methods
    
    func processFetchResult(result: Result<Array<ModelType>, NetworkError>) {
        switch result {
        case .success(let response): model.append(contentsOf: response, withSizeLimit: maxItemCount)
                                     updatePaginability(newItemsCount: response.count)
                                     handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }
    
    // MARK: - Model Paginability Update Methods
    
    func updatePaginability(newItemsCount: Int) {
        if model.count == maxItemCount || model.currentPage == maxPageCount || newItemsCount < NetworkingConstants.minimumPageCapacity {
            model.isPaginable = false
        } else {
            model.currentPage += 1
        }
    }
    
}

extension WebServiceDetailLogicController {
    
    // MARK: - Initialization
    
    init() {
        self.init(withParameter: "")
    }
    
    init(withParameter parameter: String) {
        self.init()
        self.parameter = parameter
    }
    
    // MARK: - Load Method
    
    func load(then handler: @escaping NetworkLoadingHandler) {
        if !parameter.isEmpty, !model.isComplete {
            self.handler = handler
            fetchData()
        } else {
            handler(nil)
        }
    }
    
    // MARK: - Fetch Result Processing Method
    
    func processFetchResult(result: Result<ModelType, NetworkError>) {
        switch result {
        case .success(let response): self.model = response
                                     self.model.isComplete = true
                                     handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }
    
}

extension WebServicePlainLogicController {
    
    // MARK: - Load, Refresh and Paginate methods

    func load(then handler: @escaping NetworkLoadingHandler) {
        self.handler = handler
        fetchData()
    }
    
    func refresh(then handler: @escaping NetworkLoadingHandler) {
        self.handler = handler
        resetData()
        fetchData()
    }
    
    func paginate(then handler: @escaping NetworkLoadingHandler) {
        self.handler = handler
        fetchData()
    }
    
}

extension WebServiceSearchLogicController {
    
    // MARK: - Search, Refresh and Paginate methods

    func search(withQuery query: String, then handler: @escaping NetworkLoadingHandler) {
        self.query = query
        self.handler = handler
        resetData()
        fetchData()
    }
    
    func refresh(then handler: @escaping NetworkLoadingHandler) {
        self.handler = handler
        resetData()
        fetchData()
    }
    
    func paginate(then handler: @escaping NetworkLoadingHandler) {
        self.handler = handler
        fetchData()
    }
    
}
