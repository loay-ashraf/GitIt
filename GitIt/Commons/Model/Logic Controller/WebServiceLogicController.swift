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
    var model: Observable<List<ModelType>> { get set }
    var modelList: List<ModelType> { get set }
    var maxItemCount: Int? { get }
    var maxPageCount: Int { get }
    
    init()
    init(maxItemCount: Int?, maxPageCount: Int)
    
    func fetchData() async -> Result<Array<ModelType>,NetworkError>
    func resetData()
    func processFetchResult(result: Result<Array<ModelType>, NetworkError>) -> NetworkError?
    func updatePaginability(newItemsCount: Int)
    func bind(_ listener: @escaping (List<ModelType>?) -> Void)
    
}

protocol WebServiceDetailLogicController: AnyObject {
    
    associatedtype WebServiceClientType: WebServiceClient
    associatedtype ModelType: Model
    
    var webServiceClient: WebServiceClientType { get }
    var model: Observable<ModelType> { get set }
    var modelObject: ModelType { get set }
    var parameter: String { get set }
    
    init()
    init(withParameter parameter: String)
    
    func load() async -> NetworkError?
    func fetchData() async -> Result<ModelType, NetworkError>
    func checkForStatus() async -> Array<Bool>
    func processFetchResult(result: Result<ModelType, NetworkError>) -> NetworkError?
    func bind(_ listener: @escaping (ModelType?) -> Void)
    
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
    
    // MARK: - Properties
    
    var modelList: List<ModelType> {
        get { return model.value ?? List<ModelType>() }
        set { model.value = newValue }
    }
    
    // MARK: - Initialization
    
    init() {
        self.init(maxItemCount: nil, maxPageCount: 0)
    }
    
    // MARK: - Reset Method
    
    func resetData() {
        modelList.reset(isPagiable: true)
    }
    
    // MARK: - Fetch Result Processing Methods
    
    func processFetchResult(result: Result<Array<ModelType>, NetworkError>) -> NetworkError? {
        switch result {
        case .success(let response): modelList.append(contentsOf: response, withSizeLimit: maxItemCount)
                                     updatePaginability(newItemsCount: response.count)
                                     return nil
        case .failure(let networkError): return networkError
        }
    }
    
    // MARK: - Model Paginability Update Method
    
    func updatePaginability(newItemsCount: Int) {
        if modelList.count == maxItemCount || modelList.currentPage == maxPageCount || newItemsCount < NetworkingConstants.minimumPageCapacity {
            modelList.isPaginable = false
        } else {
            modelList.currentPage += 1
        }
    }
    
    // MARK: - Bind Method
    
    func bind(_ listener: @escaping (List<ModelType>?) -> Void) {
        model.bind(listener)
    }
    
}

extension WebServiceDetailLogicController {
    
    // MARK: - Properties
    
    var modelObject: ModelType {
        get { return model.value ?? ModelType() }
        set { model.value = newValue }
    }
    
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
        if !parameter.isEmpty, !modelObject.isComplete {
            return processFetchResult(result: await fetchData())
        }
        return nil
    }
    
    // MARK: - Fetch Result Processing Method
    
    func processFetchResult(result: Result<ModelType, NetworkError>) -> NetworkError? {
        switch result {
        case .success(let response): modelObject = response
                                     modelObject.isComplete = true
                                     return nil
        case .failure(let networkError): return networkError
        }
    }
    
    // MARK: - Bind Method
    
    func bind(_ listener: @escaping (ModelType?) -> Void) {
        model.bind(listener)
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
        case .success(let response): modelList.append(contentsOf: response.items)
                                     updatePaginability(newItemsCount: response.count)
                                     return nil
        case .failure(let networkError): return networkError
        }
    }
    
}
