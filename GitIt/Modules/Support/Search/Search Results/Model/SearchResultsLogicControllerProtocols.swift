//
//  SearchResultsLogicControllerProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchResultsLogicController: AnyObject {
    
    associatedtype ModelType: Model
    
    var model: List<ModelType> { get set }
    var query: String { get set }
    var handler: LoadingHandler? { get set }
    
    init()
    
    func load(then handler: @escaping LoadingHandler)
    func refresh(then handler: @escaping LoadingHandler)
    func reset()
    func processResult(result: Result<BatchResponse<ModelType>,NetworkError>)
    func updateModelParameters(count: Int)
    
}

extension SearchResultsLogicController {
    
    // MARK: - Initialization
    
    init() {
        self.init()
    }
    
    // MARK: - Loading Methods
    
    func refresh(then handler: @escaping LoadingHandler) {
        model.reset()
        load(then: handler)
    }
    
    func reset() {
        model.reset()
    }
    
    // MARK: - Result Processing Methods
    
    func processResult(result: Result<BatchResponse<ModelType>, NetworkError>) {
        switch result {
        case .success(let response): model.append(contentsOf: response.items)
                                     updateModelParameters(count: response.count)
                                     handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }
    
    func updateModelParameters(count: Int) {
        model.currentPage += 1
        if !model.isPaginable {
            model.isPaginable = count > 10 ? true : false
        } else {
            model.isPaginable = model.items.count == count ? false : true
        }
    }
    
}
