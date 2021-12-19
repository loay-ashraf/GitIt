//
//  RepositoryLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/11/2021.
//

import Foundation

class RepositoryLogicController {
    
    var model = List<RepositoryModel>()
    var context: RepositoryContext
    private var contextParameters: Any?

    typealias ViewStateHandler = (ViewState) -> Void

    init(context: RepositoryContext, contextParameters: Any? = nil) {
        self.context = context
        self.contextParameters = contextParameters
        switch context {
        case .main: model.isPaginable = true
        case .user: model.isPaginable = (contextParameters as! RepositoryContext.UserParameters).1 > 10 ? true : false
        case .organization: model.isPaginable = (contextParameters as! RepositoryContext.OrganizationParameters).1 > 10 ? true : false
        case .forks: model.isPaginable = (contextParameters as! RepositoryContext.ForksParameters).1 > 10 ? true : false
        case .starred: model.isPaginable = true
        }
    }

    func refresh(then handler: @escaping ViewStateHandler) {
        model.reset()
        load(then: handler)
    }

    func load(then handler: @escaping ViewStateHandler) {
        switch context {
        case .main: loadMain(then: handler)
        case .user: loadUser(then: handler)
        case .organization: loadOrganization(then: handler)
        case .forks: loadForks(then: handler)
        case .starred: loadStarred(then: handler)
        }
    }

    private func loadMain(then handler: @escaping ViewStateHandler) {
        NetworkClient.standard.getRepositoryPage(page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters()
                                         handler(.presenting)
            case .failure(let networkError): handler(.failed(networkError))
            }
        }
    }

    private func loadUser(then handler: @escaping ViewStateHandler) {
        let parameters = contextParameters as! RepositoryContext.UserParameters
        NetworkClient.standard.getUserRepositories(userLogin: parameters.0, page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters()
                                         handler(.presenting)
            case .failure(let networkError): handler(.failed(networkError))
            }
        }
    }

    private func loadOrganization(then handler: @escaping ViewStateHandler) {
        let parameters = contextParameters as! RepositoryContext.OrganizationParameters
        NetworkClient.standard.getOrganizationRepositories(organizationLogin: parameters.0, page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters()
                                         handler(.presenting)
            case .failure(let networkError): handler(.failed(networkError))
            }
        }
    }
    
    private func loadForks(then handler: @escaping ViewStateHandler) {
        let parameters = contextParameters as! RepositoryContext.OrganizationParameters
        NetworkClient.standard.getRepositoryForks(fullName: parameters.0, page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters()
                                         handler(.presenting)
            case .failure(let networkError): handler(.failed(networkError))
            }
        }
    }
    
    private func loadStarred(then handler: @escaping ViewStateHandler) {
        let parameters = contextParameters as! RepositoryContext.StarredParameters
        NetworkClient.standard.getUserStarred(userLogin: parameters, page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters(newItemsCount: response.count)
                                         handler(.presenting)
            case .failure(let networkError): handler(.failed(networkError))
            }
        }
    }

    private func updateModelParameters(newItemsCount: Int = 0) {
        model.currentPage += 1
        switch context {
        case .main: model.isPaginable = true
        case .user: model.isPaginable = model.items.count == (contextParameters as! RepositoryContext.UserParameters).1 ? false : true
        case .organization: model.isPaginable = model.items.count == (contextParameters as! RepositoryContext.OrganizationParameters).1 ? false : true
        case .forks: model.isPaginable = model.items.count == (contextParameters as! RepositoryContext.ForksParameters).1 ? false : true
        case .starred: model.isPaginable = newItemsCount == 0 ? false : true
        }
    }

}
