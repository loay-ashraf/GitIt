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
    private var handler: LoadingHandler?
    
    init(context: OrganizationContext, contextParameters: Any? = nil) {
        self.context = context
        self.contextParameters = contextParameters
        self.model.isPaginable = true
    }
    
    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        switch context {
        case .main: loadMain()
        case .user: loadUser()
        }
    }
    
    func refresh(then handler: @escaping LoadingHandler) {
        model.reset()
        load(then: handler)
    }
    
    private func loadMain() {
        NetworkClient.standard.getOrganizationPage(page: model.currentPage, perPage: 10, completionHandler: processResult(result:))
    }
    
    private func loadUser() {
        let parameters = contextParameters as! OrganizationContext.UserParameters
        NetworkClient.standard.getUserOrganizations(userLogin: parameters, page: model.currentPage, perPage: 10, completion: processResult(result:))
    }
    
    private func processResult(result: Result<[OrganizationModel],NetworkError>) {
        switch result {
        case .success(let response): model.append(contentsOf: response)
                                     updateModelParameters(newItemsCount: response.count)
                                     handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }
    
    private func updateModelParameters(newItemsCount: Int = 0) {
        switch context {
        case .main: model.isPaginable = true
        case .user: model.isPaginable = newItemsCount == 0 ? false : true
        }
        if model.currentPage == 100 {
            model.isPaginable = false
        } else {
            model.currentPage += 1
        }
    }
    
}
