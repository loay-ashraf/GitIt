//
//  OrganizationLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import Foundation

class OrganizationLogicController {
    
    // MARK: - Properties
    
    var model = List<OrganizationModel>()
    var handler: LoadingHandler?
    
    // MARK: - Initialization
    
    init() {
        self.model.isPaginable = true
    }
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchOrganizations(page: model.currentPage, completionHandler: processResult(result:))
    }
    
    func refresh(then handler: @escaping LoadingHandler) {
        model.reset()
        load(then: handler)
    }
    
    // MARK: - Result Processing Methods
    
    func processResult(result: Result<[OrganizationModel],NetworkError>) {
        switch result {
        case .success(let response): model.append(contentsOf: response)
                                     updateModelParameters(newItemsCount: response.count)
                                     handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }
    
    func updateModelParameters(newItemsCount: Int = 0) {
        if model.currentPage == NetworkingConstants.maxPageCount {
            model.isPaginable = false
            return
        } else {
            model.currentPage += 1
        }
    }
    
}
