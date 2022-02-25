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
    
    func fetchData() async -> Result<Array<ModelType>,NetworkError>
    func resetData()
    func processFetchResult(result: Result<Array<ModelType>, NetworkError>) -> NetworkError?
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
    
    func load() async -> NetworkError?
    func fetchData() async -> Result<ModelType, NetworkError>
    func checkForStatus() async -> Array<Bool>
    func processFetchResult(result: Result<ModelType, NetworkError>) -> NetworkError?
    
}

protocol WebServicePlainLogicController: WebServiceLogicController {

    func load() async -> NetworkError?
    func refresh() async -> NetworkError?
    func paginate() async -> NetworkError?

}

protocol WebServiceSearchLogicController: WebServiceLogicController {
    
    var query: String { get set }
    
    func search(withQuery query: String) async -> NetworkError?
    func refresh() async -> NetworkError?
    func paginate() async -> NetworkError?
    
    func fetchData() async -> Result<BatchResponse<ModelType>,NetworkError>
    func processFetchResult(result: Result<BatchResponse<ModelType>,NetworkError>) -> NetworkError?
    
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
    
    func processFetchResult(result: Result<Array<ModelType>, NetworkError>) -> NetworkError? {
        switch result {
        case .success(let response): model.append(contentsOf: response, withSizeLimit: maxItemCount)
                                     updatePaginability(newItemsCount: response.count)
                                     return nil
        case .failure(let networkError): return networkError
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
    
    func load() async -> NetworkError? {
        if !parameter.isEmpty, !model.isComplete {
            return processFetchResult(result: await fetchData())
        }
        return nil
    }
    
    // MARK: - Fetch Result Processing Method
    
    func processFetchResult(result: Result<ModelType, NetworkError>) -> NetworkError? {
        switch result {
        case .success(let response): model = response
                                     model.isComplete = true
                                     return nil
        case .failure(let networkError): return networkError
        }
    }
    
}

extension WebServicePlainLogicController {
    
    // MARK: - Load, Refresh and Paginate methods

    func load() async -> NetworkError? {
        return processFetchResult(result: await fetchData())
    }
    
    func refresh() async -> NetworkError? {
        resetData()
        return processFetchResult(result: await fetchData())
    }
    
    func paginate() async -> NetworkError? {
        return processFetchResult(result: await fetchData())
    }
    
}

extension WebServiceSearchLogicController {
    
    // MARK: - Search, Refresh and Paginate methods

    func search(withQuery query: String) async -> NetworkError? {
        self.query = query
        resetData()
        let dataResult: Result<BatchResponse<ModelType>,NetworkError> = await fetchData()
        return processFetchResult(result: dataResult)
    }
    
    func refresh() async -> NetworkError? {
        resetData()
        let dataResult: Result<BatchResponse<ModelType>,NetworkError> = await fetchData()
        return processFetchResult(result: dataResult)
    }
    
    func paginate() async -> NetworkError? {
        let dataResult: Result<BatchResponse<ModelType>,NetworkError> = await fetchData()
        return processFetchResult(result: dataResult)
    }
    
    // MARK: - Fetch Result Processing Method
    
    func processFetchResult(result: Result<BatchResponse<ModelType>, NetworkError>) -> NetworkError? {
        switch result {
        case .success(let response): model.append(contentsOf: response.items)
                                     updatePaginability(newItemsCount: response.count)
                                     return nil
        case .failure(let networkError): return networkError
        }
    }
    
}
