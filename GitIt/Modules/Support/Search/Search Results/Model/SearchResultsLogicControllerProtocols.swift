//
//  SearchResultsLogicControllerProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchResultsLogicController: WebServiceSearchLogicController {
    
    func processFetchResult(result: Result<BatchResponse<ModelType>,NetworkError>)
    
}

extension SearchResultsLogicController {
    
    // MARK: - Fetch Result Processing Method
    
    func processFetchResult(result: Result<BatchResponse<ModelType>, NetworkError>) {
        switch result {
        case .success(let response): model.append(contentsOf: response.items)
                                     updatePaginability(newItemsCount: response.count)
                                     handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }
    
}
