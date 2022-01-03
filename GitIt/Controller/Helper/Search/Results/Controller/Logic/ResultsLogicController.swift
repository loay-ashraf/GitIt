//
//  ResultsLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 01/01/2022.
//

import Foundation

class ResultsLogicController<Type: Model> {
    
    var model = List<Type>()
    var keyword = String()
    
    private var handler: LoadingHandler?
    
    // MARK: - Load, Refresh and Reset Methods
    
    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        switch Type.self {
        case is UserModel.Type: searchUsers(then: handler)
        case is RepositoryModel.Type: searchRepositories(then: handler)
        case is OrganizationModel.Type: searchOrganizations(then: handler)
        default: return
        }
    }
    
    func refresh(then handler: @escaping LoadingHandler) {
        model.reset()
        load(then: handler)
    }
    
    func reset() {
        model.reset()
    }
    
    // MARK: - Load Helper Methods
    
    private func searchUsers(then handler: @escaping LoadingHandler) {
        NetworkClient.standard.getUserSearchPage(keyword: keyword, page: model.currentPage, perPage: 10, completionHandler: processUserResult(result:))
    }

    private func searchRepositories(then handler: @escaping LoadingHandler) {
        NetworkClient.standard.getRepositorySearchPage(keyword: keyword, page: model.currentPage, perPage: 10, completionHandler: processRepositoryResult(result:))
    }
    
    private func searchOrganizations(then handler: @escaping LoadingHandler) {
        NetworkClient.standard.getOrganizationSearchPage(keyword: keyword, page: model.currentPage, perPage: 10, completionHandler: processOrganizationResult(result:))
    }
    
    private func processUserResult(result: Result<BatchResponse<UserModel>,NetworkError>) {
        switch result {
        case .success(let response): self.model.append(contentsOf: response.items as! [Type])
                                     self.updateModelParameters(count: response.count)
                                     if self.model.isEmpty {
                                         handler?(nil,.searchResults)
                                     } else {
                                         handler?(nil,nil)
                                     }
        case .failure(let networkError): handler?(networkError, nil)
        }
    }
                                                         
    private func processRepositoryResult(result: Result<BatchResponse<RepositoryModel>,NetworkError>) {
        switch result {
        case .success(let response): self.model.append(contentsOf: response.items as! [Type])
                                     self.updateModelParameters(count: response.count)
                                     if self.model.isEmpty {
                                        handler?(nil,.searchResults)
                                     } else {
                                        handler?(nil,nil)
                                    }
        case .failure(let networkError): handler?(networkError, nil)
        }
    }
    
    private func processOrganizationResult(result: Result<BatchResponse<OrganizationModel>,NetworkError>) {
        switch result {
        case .success(let response): self.model.append(contentsOf: response.items as! [Type])
                                     self.updateModelParameters(count: response.count)
                                     if self.model.isEmpty {
                                        handler?(nil,.searchResults)
                                     } else {
                                        handler?(nil,nil)
                                    }
        case .failure(let networkError): handler?(networkError, nil)
        }
    }
                                                         
    private func updateModelParameters(count: Int) {
        model.currentPage += 1
        if !model.isPaginable {
            model.isPaginable = count > 10 ? true : false
        } else {
            model.isPaginable = model.items.count == count ? false : true
        }
    }
                                                         
}
