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
    
    typealias ViewStateHandler = (ViewState) -> Void
    
    init(context: OrganizationContext, contextParameters: Any? = nil) {
        self.context = context
        self.contextParameters = contextParameters
        self.model.isPaginable = true
    }
    
    func refresh(then handler: @escaping ViewStateHandler) {
        model.reset()
        load(then: handler)
    }
    
    func load(then handler: @escaping ViewStateHandler) {
        switch context {
        case .main: loadMain(then: handler)
        case .user: loadUser(then: handler)
        }
    }
    
    private func loadMain(then handler: @escaping ViewStateHandler) {
        GithubClient.standard.getOrganizationPage(page: model.currentPage, perPage: 10) { response, error in
            if let error = error {
                handler(.failed(error))
            } else {
                self.model.append(contentsOf: response)
                self.updateModelParameters()
                handler(.presenting)
            }
        }
    }
    
    private func loadUser(then handler: @escaping ViewStateHandler) {
        let parameters = contextParameters as! OrganizationContext.UserParameters
        GithubClient.standard.getUserOrganizations(userLogin: parameters, page: model.currentPage, perPage: 10) { response, error in
            if let error = error {
                handler(.failed(error))
            } else {
                self.model.append(contentsOf: response)
                self.updateModelParameters(newItemsCount: response.count)
                handler(.presenting)
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
