//
//  SearchResultsLogicControllerProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchResultsLogicController: WebServiceSearchLogicController { }

extension SearchResultsLogicController {
    
    // MARK: - Fetch Data Method
    
    func fetchData() async -> Result<Array<ModelType>, NetworkError> {
        return .failure(NetworkError.noData)
    }
    
    // MARK: - Fetch Result Processing Method
    
    func processFetchResult(result: Result<Array<ModelType>, NetworkError>) -> NetworkError? {
        return NetworkError.noData
    }
    
}
