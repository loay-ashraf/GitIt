//
//  OrganizationLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import Foundation

class OrganizationLogicController {
    
    var model = List<OrganizationModel>()
    var context: OrganizationContext
    private var contextParameters: Any?
    
    init(context: OrganizationContext, contextParameters: Any? = nil) {
        self.context = context
        self.contextParameters = contextParameters
        self.model.isPaginable = true
    }
    
    func load(then handler: @escaping ErrorHandler) {
        switch context {
        case .main: loadMain(then: handler)
        case .user: loadUser(then: handler)
        }
    }
    
    func refresh(then handler: @escaping ErrorHandler) {
        model.reset()
        load(then: handler)
    }
    
    private func loadMain(then handler: @escaping ErrorHandler) {
        NetworkClient.standard.getOrganizationPage(page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters()
                                         handler(nil)
            case .failure(let networkError): handler(networkError)
            }
        }
    }
    
    private func loadUser(then handler: @escaping ErrorHandler) {
        let parameters = contextParameters as! OrganizationContext.UserParameters
        NetworkClient.standard.getUserOrganizations(userLogin: parameters, page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters(newItemsCount: response.count)
                                         handler(nil)
            case .failure(let networkError): handler(networkError)
            }
        }
    }
    
    private func updateModelParameters(newItemsCount: Int = 0) {
        model.currentPage += 1
        switch context {
        case .main: model.isPaginable = true
        case .user: model.isPaginable = newItemsCount == 0 ? false : true
        }
    }
    
}
